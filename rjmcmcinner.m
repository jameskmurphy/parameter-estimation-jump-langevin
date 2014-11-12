function [JumpSample, loglikelihood] = rjmcmcinner( y, params, NumSteps, CurJumpSample, loglikelihood_cur)
%RJMCMC Summary of this function goes here
%   Detailed explanation goes here
OUTPUT.JumpSample(1) = CurJumpSample;  % because we are retrofitting this bit of code

%loglikelihood_cur = EvaluateLikelihood(OUTPUT.JumpSample, y, params);

pMove = 0.8;
pBirth = 0.1;
pDeath = 0.1;

pXJump = 0;
pXdotJump = 1;
% => pBothJump = 0.1

sigma_move = 10; 

T = numel(y);

OUTPUT.accepts(1) = 0;
for s=2:NumSteps+1
    
    nochange = false;
    % propose
    
    JumpSampleProp = OUTPUT.JumpSample(s-1);
    SafeJumpTimes = [1 OUTPUT.JumpSample(s-1).tau T];
    
    u=rand;
    if(u<pMove) % move proposal
        
        if(numel(JumpSampleProp.tau)==0)
            nochange=true;
        else
            % choose a jump to move
            j = ceil(rand * numel(OUTPUT.JumpSample(s-1).tau));
            JumpSampleProp.tau(j) = JumpSampleProp.tau(j) + randn*sigma_move;
            [JumpSampleProp.tau, ix] = sort(JumpSampleProp.tau, 'ascend');
            JumpSampleProp.isjumping = JumpSampleProp.isjumping(:,ix);
            % without truncation, this is a symmetric proposal, so don't
            % need to evaluate proposal density
            logqcurprop = 0; logqpropcur=0;
        end
        
        
    elseif(u<pMove+pBirth) % birth
        
        %fprintf('birth\n');
        
        newjumptime = rand * (T-1);
        v = rand;
        if(v<pXJump)
            jumptype = [1;0];
            pjumptype = pXJump;
        elseif(v<pXJump+pXdotJump)
            jumptype = [0;1];
            pjumptype = pXdotJump;
        else
            jumptype = [1;1];
            pjumptype = 1-pXJump-pXdotJump;
        end
        
        ix = find(SafeJumpTimes < newjumptime, 1, 'last')-1;
        if(ix>0)
            JumpSampleProp.tau = [JumpSampleProp.tau(1:ix) newjumptime JumpSampleProp.tau(ix+1:end)];
            JumpSampleProp.isjumping = [JumpSampleProp.isjumping(:,1:ix) jumptype JumpSampleProp.isjumping(:,ix+1:end)];
        else
            JumpSampleProp.tau = [newjumptime JumpSampleProp.tau];
            JumpSampleProp.isjumping = [jumptype JumpSampleProp.isjumping];
        end
        
        logqcurprop = log(pDeath / numel(JumpSampleProp.tau));
        logqpropcur = log(pBirth * pjumptype / (T-1));
    
    
    else % death
        
        if(numel(JumpSampleProp.tau)==0)
            nochange=true;
        else
            
            j = ceil(rand * numel(JumpSampleProp.tau));
            JumpSampleProp.tau = [JumpSampleProp.tau(1:j-1) JumpSampleProp.tau(j+1:end)];
            jumptype = JumpSampleProp.isjumping(:,j);
            JumpSampleProp.isjumping = [JumpSampleProp.isjumping(:,1:j-1) JumpSampleProp.isjumping(:,j+1:end)];
            
            if(jumptype(1) && jumptype(2))
                pjumptype = 1-pXJump-pXdotJump;
            elseif(jumptype(1))
                pjumptype = pXJump;
            else
                pjumptype = pXdotJump;
            end
            
            logqcurprop = log(pBirth * pjumptype / (T-1));
            logqpropcur = log(pDeath / numel(OUTPUT.JumpSample(s-1).tau));
            
        end
        
    end
    
    if(~nochange)
        
        if(numel(JumpSampleProp.tau)>0 && (min(JumpSampleProp.tau)<1 || max(JumpSampleProp.tau)>T))
            loglikelihood_prop = -inf;
        else
            loglikelihood_prop = EvaluateLikelihood(JumpSampleProp, y, params);
        end
        
        
        paccept = exp( loglikelihood_prop + logqcurprop + logpriorprop(JumpSampleProp,params,T) - loglikelihood_cur - logqpropcur - logpriorprop(OUTPUT.JumpSample(s-1),params,T));
        
        if(rand<paccept)
            OUTPUT.JumpSample(s) = JumpSampleProp;
            loglikelihood_cur = loglikelihood_prop;
            OUTPUT.accepts(s) = OUTPUT.accepts(s-1) + 1;
        else
            OUTPUT.JumpSample(s) = OUTPUT.JumpSample(s-1);
            OUTPUT.accepts(s) = OUTPUT.accepts(s-1);
        end
        
    else
        OUTPUT.JumpSample(s) = OUTPUT.JumpSample(s-1);
        OUTPUT.accepts(s) = OUTPUT.accepts(s-1);
    end
    
    
    
end

JumpSample = OUTPUT.JumpSample(s);
loglikelihood = loglikelihood_cur;

end


function logp = logpriorprop(JumpSample,params,T)

% prior for a jump sequence

% get the jump sequence for each process
xjumps = 1;
xdotjumps = 1;


for i=1:numel(JumpSample.tau)
    if(JumpSample.isjumping(1,i))
        xjumps = [xjumps JumpSample.tau(i)];
    end
    if(JumpSample.isjumping(2,i))
        xdotjumps = [xdotjumps JumpSample.tau(i)];
    end
end

Nx = numel(xjumps)-1;
Nxd = numel(xdotjumps)-1;

logp=0;
if(params.jumprate(1)>0)
    logp = logp+Nx*log(params.jumprate(1)) - params.jumprate(1)*(T-1);
else
    if(Nx>0), logp=-inf; end
end
if(params.jumprate(2)>0)
    logp=logp+Nxd*log(params.jumprate(2)) - params.jumprate(2)*(T-1);
else
    if(Nxd>0), logp=-inf; end
end

end

