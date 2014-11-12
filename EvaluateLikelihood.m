function [loglikelihood, mu, cov, Jumpmu, PreJumpcov, PostJumpcov] = EvaluateLikelihood( JumpSample, y, params )
%EVALUATELIKELIHOOD Calculate the likelihood for a given set of parameters
%and jump times using the Kalman filter
%   With fixed jump times this can be calculated with the Kalman filter

T = size(y,2);
H = params.ObsMatrix;  % Observation matrix
A = [-params.lambdax, 1; 0, -params.lambdaxdot];
b = [params.sigmax 0; 0 params.sigmaxdot];

Jumpmu = [];
PreJumpcov = [];
PostJumpcov = [];
            
% Calculate the likelihood of the first observation - used in overall
% likelihood calculation
loglikelihood = logmvnpdf(y(:,1), H*params.muprior, H*params.covprior*H'+params.ObsCov);

% Incorporate the first observation with the Kalman filter step
ytilde = y(:,1) - H * params.muprior;
S = H * params.covprior * H' + params.ObsCov;
K = params.covprior * H' / S ; 
cov(:,:,1) = (eye(2) - K*H)*params.covprior;
mu(:,1) = params.muprior + K*ytilde;

% Now step through the observations
for t=2:T

    % Predict step (need to take account of any jumps here)
    
    % Check if there are any jumps since the last observation
    taujump = [];
    jumptype = [];
    if(numel(JumpSample.tau)>0)
        ix = find(JumpSample.tau>t-1 & JumpSample.tau<t);
        if(numel(ix)>0)
            % There is a jump (or jumps)
            taujump = JumpSample.tau(ix);
            jumptype = JumpSample.isjumping(:,ix);
        end
    end

    if(numel(taujump)>0)
        
        tstep = taujump(1)-(t-1);
        covprejump = CalculateCov(A,b, tstep, cov(:,:,t-1));
        
        % Store this for use in the backward sampling if we want it
        Jumpmu(:,ix(1)) = expm(A*tstep)*mu(:,t-1);
        PreJumpcov(:,:,ix(1)) = covprejump;
        PostJumpcov(:,:,ix(1)) = covprejump+(jumptype(:,1)*jumptype(:,1)').*params.covJump;
        
        for i = 2:numel(taujump)
            tstep = taujump(i)-taujump(i-1);
            covprejump = CalculateCov(A,b, tstep, covprejump+(jumptype(:,i-1)*jumptype(:,i-1)').*params.covJump);
            
            % Store this for use in the backward sampling if we want it
            Jumpmu(:,ix(i)) = expm(A*(taujump(i)-(t-1)))*mu(:,t-1);
            PreJumpcov(:,:,ix(i)) = covprejump;
            PostJumpcov(:,:,ix(i)) = covprejump+(jumptype(:,i-1)*jumptype(:,i-1)').*params.covJump;

        end
        tstep = t-taujump(end);
        covpredict = CalculateCov(A,b, tstep, covprejump+ (jumptype(:,end)*jumptype(:,end)').*params.covJump);
    else
        tstep = 1;
        covpredict = CalculateCov(A,b, tstep, cov(:,:,t-1));
    end
    mupredict = expm(A*tstep)*mu(:,t-1);
    
    % Likelihood calculation
    loglikelihood = loglikelihood + logmvnpdf(y(:,t), H*mupredict, H*covpredict*H' + params.ObsCov);
    
    % Correct step (standard KF correct step)
    ytilde = y(:,t) - H * mupredict;
    S = H * covpredict * H' + params.ObsCov;
    K = covpredict * H' / S ; 
    cov(:,:,t) = (eye(2) - K*H)*covpredict;
    mu(:,t) = mupredict + K*ytilde;
%     subplot(2,1,1);
%     hold on;
%     plot(t, mu(1,t), 'bx');
%     plot(t, y(t), 'go');
%     subplot(2,1,2);
%     hold on;
%     plot(t, mu(2,t), 'bx');
%     drawnow;
end

end

