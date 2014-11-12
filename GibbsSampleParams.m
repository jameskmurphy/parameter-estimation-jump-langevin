function [params accepts] = GibbsSampleParams( SampleParams, JumpSample, y, params )
%GIBBSSAMPLEPARAMS Summary of this function goes here
%   Detailed explanation goes here

% X  params.muprior
% X  params.covprior
% -  params.ObsCov         - as a single observation noise
% X  params.ObsMatrix
% -  params.lambdax
% -  params.lambdaxdot
% -  params.sigmax
% -  params.sigmaxdot
% -  params.covJump        - as a vector of two jump variances
% -  params.jumprate       - as a vector of two jump rates (a bit sketchy)

% total: 9 scalar parameters

% jumprate - can estimate from the jump sequences using a gamma prior

    % make a sequence for each process
if(SampleParams(8)||SampleParams(9))
    j1=[1]; j2=[1];  % initial time
    for i=1:numel(JumpSample.tau)
        if(JumpSample.isjumping(1,i)), j1(end+1) = JumpSample.tau(i); end
        if(JumpSample.isjumping(2,i)), j2(end+1) = JumpSample.tau(i); end
    end

    n1 = numel(j1)-1;
    n2 = numel(j2)-1;
    
    if(SampleParams(8))
        mean1 = mean(j1(2:end) - j1(1:end-1));
        params.jumprate(1) = gamrnd(params.jumprateprior_alpha(1) + n1, 1/(params.jumprateprior_beta(1) + n1*mean1)); 
    else
        params.jumprate(1) = 0;
    end
    if(SampleParams(9))
        mean2 = mean(j2(2:end) - j2(1:end-1));
        params.jumprate(2) = gamrnd(params.jumprateprior_alpha(2) + n2, 1/(params.jumprateprior_beta(2) + n2*mean2)); 
    else
        params.jumprate(2) = 0;
    end
end
    
    
% calculate current loglikelihood
curloglikelihood = EvaluateLikelihood(JumpSample, y, params); 
    
% M-wi-G sample the other 7 parameters
% titles = {'ObsCov', '\lambda-x', '\lambda-xd', '\sigma-x', '\sigma-xd', 'covJump-x', 'covJump-xd', 'jumprate-x', 'jumprate-xd'};

propstd     = [params.obsstdprop_std^2, params.meanreversionprop_std, params.meanreversionprop_std, params.statetxstdprop_std, params.statetxstdprop_std, params.jumpstdprop_std^2,params.jumpstdprop_std^2 5 5];
propstdlge     = 5*propstd;%[5 1 1 1 5 100 100];
nonnegative = [1 1 1 1 1 1 1];

accepts = [0 0 0 0 0 0 0 1 1];

for i=1:7
    if(SampleParams(i))
        paramvec = ParamsToVector(params);
        original = paramvec(i);
        if(rand<0.9), stdvn =  propstd(i);
        else stdvn =  propstdlge(i);
        end
        paramvec(i) = paramvec(i) + randn*stdvn;
        propparams = VectorToParams(paramvec, params);
        
        
        % priors
        if(i==4 || i==5)
            logpriorratio = log(gampdf(paramvec(i), params.processnoiseprior_alpha, 1/params.processnoiseprior_beta)) - log(gampdf(original, params.processnoiseprior_alpha, 1/params.processnoiseprior_beta));
        elseif(i==2 || i==3)
            logpriorratio = log(gampdf(paramvec(i), params.meanreversionprior_alpha, 1/params.meanreversionprior_beta)) - log(gampdf(original, params.meanreversionprior_alpha, 1/params.meanreversionprior_beta));
        elseif(i==1)
            logpriorratio = log(gampdf(sqrt(paramvec(i)), params.obsstdprior_alpha, 1/params.obsstdprior_beta )) - log(gampdf(sqrt(original), params.obsstdprior_alpha, 1/params.obsstdprior_beta ));

            
            %            logpriorratio = loginvgampdf(paramvec(i), params.obscovprior_alpha, params.obscovprior_beta) - loginvgampdf(original, params.obscovprior_alpha, params.obscovprior_beta);
%        elseif(i==6)
%            logpriorratio = loginvgampdf(paramvec(i), params.jumpvarprior_alpha(1), params.jumpvarprior_beta(1)) - loginvgampdf(original, params.jumpvarprior_alpha(1), params.jumpvarprior_beta(1));
            %logpriorratio=0; %uniform in range
            %if(sqrt(paramvec(6))<3*paramvec(4) || sqrt(paramvec(6))>10*paramvec(4)), logpriorratio=-inf; end 
        elseif(i==6 || i==7)
            logpriorratio = log(gampdf(sqrt(paramvec(i)), params.jumpstdprior_alpha(i-5), 1/params.jumpstdprior_beta(i-5))) - log(gampdf(sqrt(original), params.jumpstdprior_alpha(i-5), 1/params.jumpstdprior_beta(i-5)));

            
            %logpriorratio = loginvgampdf(paramvec(i), params.jumpvarprior_alpha(2), params.jumpvarprior_beta(2)) - loginvgampdf(original, params.jumpvarprior_alpha(2), params.jumpvarprior_beta(2));
            
            
            %logpriorratio=0;
            %if(sqrt(paramvec(7))<3*paramvec(5) || sqrt(paramvec(7))>10*paramvec(5)), logpriorratio=-inf; end 
        else
            logpriorratio = 0;
        end
                

        if(nonnegative(i) && paramvec(i)<0)
            % reject
        else
            propll = EvaluateLikelihood(JumpSample, y, propparams);
            if(rand < exp(logpriorratio+propll-curloglikelihood))
                params = propparams;
                accepts(i) = accepts(i) + 1;
                curloglikelihood = propll;
            end
        end
    end
    
end
    
end

