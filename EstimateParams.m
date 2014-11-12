function OUTPUT = EstimateParams(y, InitialParams, SampleParams, NumSamples, NumParamSamplesPerStateSample, NumStateSamplesPerParamSample)
tic

    OUTPUT.SampleParams = SampleParams;    

    OUTPUT.Xsamples = cell(0);
    params = InitialParams;
    OUTPUT.params(:,1) = ParamsToVector(params)';
    
    T = numel(y);
    
    wb = InitializeWaitBar( NumSamples, 'Sample');
    
    
    initialjumptimes = cumsum(rand(1,20)*(2*T/10));
    ix = find(initialjumptimes < T, 1, 'last');
    
    
    JumpSample.tau=initialjumptimes(1:ix);
    for i=1:ix
        u=rand;
        if(u<0), JumpSample.isjumping(:,i) = [1;0];
        elseif(u<1), JumpSample.isjumping(:,i) = [0;1];
        else JumpSample.isjumping(:,i) = [1;1];
        end
    end
    
    loglikelihood = EvaluateLikelihood(JumpSample, y, params);
    
    OUTPUT.accepts(1) = 0;
    
    for s=1:NumSamples
        % ------------- STATE SAMPLING ------------------------------------
        
        for ps=1:NumStateSamplesPerParamSample
            [JumpSample, loglikelihood] = rjmcmcinner( y, params, 1, JumpSample, loglikelihood);
            OUTPUT.JumpSample(s) = JumpSample;
        end
        
        % ------------ PARAM SAMPLING  ------------------------------------
        
        for ps=1:NumParamSamplesPerStateSample
            [params, thisaccepts2] = GibbsSampleParams(SampleParams, JumpSample,y,params);
            OUTPUT.params(:,end+1) = ParamsToVector(params)';
        end
        %visParamSamples( OUTPUT.params, [], SampleParams,0 );
        %fprintf('RJMCMC: %d of %d\n', s, NumSamples);
        UpdateWaitBar( wb, s )
    end

OUTPUT.runtime = toc;
end

