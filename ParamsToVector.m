function paramvec = ParamsToVector( params )
%PARAMSTOVECTOR Summary of this function goes here
%   Detailed explanation goes here

%   params.muprior
%   params.covprior
%   params.ObsCov
%   params.ObsMatrix
%   params.lambdax
%   params.lambdaxdot
%   params.sigmax
%   params.sigmaxdot
%   params.covJump      
%   params.jumprate       - jump rate (vector)


paramvec(1) = params.ObsCov;
paramvec(2) = params.lambdax;
paramvec(3) = params.lambdaxdot;
paramvec(4) = params.sigmax;
paramvec(5) = params.sigmaxdot;
paramvec(6) = params.covJump(1,1);
paramvec(7) = params.covJump(2,2);
paramvec(8) = params.jumprate(1);
paramvec(9) = params.jumprate(2);




end

