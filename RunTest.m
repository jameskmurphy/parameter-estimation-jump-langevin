function [ output_args ] = RunTest( filesuffix, dataset )
%RUNTEST Summary of this function goes here
%   Detailed explanation goes here
    

    timestamp = getTimestamp();
    fileids = [filesuffix ' (' timestamp ')'];
    filename = ['Estimation ' fileids '.mat'];
    save(filename, 'timestamp');
    
    T = 1500;
    NumSamplesRJMCMC = 10000;
    NumParamSamplesPerStateSample = 1;
    NumStateSamplesPerParamSample = 5;
    TrueParams = SetParameters();
    
    if(dataset==1)
        Tsp = 1500;
        load('sp500.mat','sp500');
        y = flipud(sp500(1:Tsp,:));
        y = y-y(1);
        y=y';
    elseif(dataset==2)
        load('gbpusddaily.mat','gbpusd');
        y = gbpusd(end-(T-1):end,:);
        y = y-y(1);
        y=y';
        y=y*1000;
    elseif(dataset==3)
        load('vi.mat','convi');
        y = flipud(convi);
        y=y';
    elseif(dataset==0)
        [ data, true_Jumps ] = GenerateData( TrueParams,T );
        y=data.y(:,2)';
    end
    
    save(filename, 'y', '-append');
    save(filename, 'fileids', '-append');
    if(dataset==0)
        save(filename, 'data', '-append');
        save(filename, 'true_Jumps', '-append');
    end
    
    SampleParams = [1 0 1 0 1 0 1 0 1]; 
    %SampleParams = [0 0 1 0 0 0 0 0 0]; 
    InitialParams = SetInitialParams();
    JumpParamSamples = EstimateParams(y, InitialParams, SampleParams, NumSamplesRJMCMC, NumParamSamplesPerStateSample, NumStateSamplesPerParamSample);
    JumpParamSamples.true_params = TrueParams;
    save(filename, 'JumpParamSamples', '-append');
    
    

end


function params = SetInitialParams()
    % Initial parameters (set everything not being estimated to true value)
    params = SetParameters(); % get all the basic parameters from this
    
    params.ObsCov = 10^2;
    params.lamdax = 0;
    params.lambdaxdot = 0.01;
    params.sigmax    = 0;
    params.sigmaxdot = 10;
    params.covJump = diag([0,100^2]);
    params.jumprate = [0;0.01]; 
end
