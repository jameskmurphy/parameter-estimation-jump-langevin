function VRPFFullEstimationVis( inputfile )
%VRPFSTATEESTIMATIONVIS Summary of this function goes here
%   Detailed explanation goes here

%addpath('C:\Users\jm362\Documents\MATLAB\thirdparty\export_fig\');

load(inputfile);

RJMCMCMarginalizedBurn = 5000;

real_data=false;  % this is not perfect
if(~exist('true_Jumps','var'))
    true_Jumps.tau = [];
    true_Jumps.isjumping = zeros(2,0);
    
end;
if(~exist('data','var'))
    % expected by visJumpSamples
    data.y = y;
    data.x = y;
    data.xdot = [];
    real_data=true;
end

figure(1);
visJumpSamples( ['Jumps - ' fileids '.png'], JumpParamSamples, RJMCMCMarginalizedBurn, true_Jumps, data )
figure(2);
%visParamSamples5( JumpParamSamples.params, ParamsToVector(JumpParamSamples.true_params), JumpParamSamples.SampleParams, RJMCMCMarginalizedBurn );
visParamSamples5( JumpParamSamples.params, [], JumpParamSamples.SampleParams, RJMCMCMarginalizedBurn );
filename = ['Params - ' fileids '.png'];
%export_fig(filename, '-a2', '-r300', '-painters');
%visEstimateQuality(JumpParamSamples, data, true_Jumps, RJMCMCMarginalizedBurn, RJMCMCMarginalizedBurn);


end

