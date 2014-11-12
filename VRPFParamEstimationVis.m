function VRPFParamEstimationVis( inputfile )
%VRPFSTATEESTIMATIONVIS Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Users\jm362\Documents\MATLAB\vrpf3\');
addpath('C:\Users\jm362\Documents\MATLAB\useful\');

addpath('C:\Users\jm362\Documents\MATLAB\thirdparty\export_fig\');

load(inputfile);

burn = 100;

if(exist('NoX','var'))
    visParamSamples( NoX.params, ParamsToVector(NoX.true_params), NoX.SampleParams, burn );
    filename = ['VRPFParamEstimation ' fileids ' NoX.png'];
    export_fig(filename, '-a2', '-r300', '-painters');
end

if(exist('SampleX','var'))
    visParamSamples( SampleX.params, ParamsToVector(SampleX.true_params), SampleX.SampleParams, burn );
    filename = ['VRPFParamEstimation ' fileids ' SampleX.png'];
    export_fig(filename, '-a2', '-r300', '-painters');
end

if(exist('Collapsed','var'))
    visParamSamples( Collapsed.params, ParamsToVector(Collapsed.true_params), Collapsed.SampleParams, burn );
    filename = ['VRPFParamEstimation ' fileids ' Collapsed.png'];
    export_fig(filename, '-a2', '-r300', '-painters');
end


end

