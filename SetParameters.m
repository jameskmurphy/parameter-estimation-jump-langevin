function params = SetParameters(  )
%VRPFPARAMETERS1 Summary of this function goes here
%   Detailed explanation goes here


% scale is a meta parameter, indicating the scale of the process
params.jumprate   = [0; 0.05];
params.sigmajump  = [0; 150];

params.lambdax    = 0;
params.lambdaxdot = 0.1;
params.sigmax     = 0;
params.sigmaxdot  = 10;

params.sigmaobs   = 10;

params.xinitialcov = [40, 0; 0, 40];

params.SmootherLag = 0;
params.UsePredictForward = false;
params.Estimatesigmaobs = false;


% parameters used in vrpf3

params.muprior = [0;0];
params.covprior = params.xinitialcov;
params.ObsCov = params.sigmaobs^2;
params.covJump = diag(params.sigmajump.^2);
params.ObsMatrix = [1 0];


% gamma priors (note matlab's gampdf uses 1/beta as second parameter to gampdf)
% mean is alpha / beta
% std  is sqrt(alpha) / beta
params.jumpstdprior_alpha(1) = 2;
params.jumpstdprior_beta(1) = 0.05;
params.jumpstdprior_alpha(2) = 2;
params.jumpstdprior_beta(2) = 0.05;

params.obsstdprior_alpha = 2;
params.obsstdprior_beta = 0.1;

params.jumprateprior_alpha(1) = 1;
params.jumprateprior_beta(1) = 10;
params.jumprateprior_alpha(2) = 1;
params.jumprateprior_beta(2) = 10;

params.processnoiseprior_alpha = 1.3;
params.processnoiseprior_beta = 1;

params.meanreversionprior_alpha = 1;
params.meanreversionprior_beta = 50;


% Proposal widths  (there is also a large proposal, which is 5x these)
params.obsstdprop_std = 2;
params.jumpstdprop_std = 20;
params.statetxstdprop_std = 3; 
params.meanreversionprop_std = 0.05;



end

