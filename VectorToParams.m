function params = VectorToParams( paramvec, oldparams )
%VECTORTOPARAMS Summary of this function goes here
%   Detailed explanation goes here

params = oldparams;
params.ObsCov      = paramvec(1);
params.lambdax     = paramvec(2);
params.lambdaxdot  = paramvec(3);
params.sigmax      = paramvec(4);
params.sigmaxdot   = paramvec(5);
params.covJump(1,1)= paramvec(6);
params.covJump(2,2)= paramvec(7);
params.jumprate(1) = paramvec(8);
params.jumprate(2) = paramvec(9);

end

