function [ output_args ] = visEstimateQuality( inputdata, data, true_Jumps, burn, jumpburn )
%VISESTIMATEQUALITY Summary of this function goes here
%   Detailed explanation goes here

y = data.y(:,2)';

% Get the average parameter values
posterior_mean_param_vec = mean(inputdata.params(:,burn:end),2);
posterior_mean_params    = VectorToParams(posterior_mean_param_vec, inputdata.true_params);

nojumps.tau = [];
nojumps.isjumping = [];

loglikelihood_true_true = EvaluateLikelihood(true_Jumps, y, inputdata.true_params);
loglikelihood_estp_true = EvaluateLikelihood(true_Jumps, y, posterior_mean_params);
loglikelihood_true_nojm = EvaluateLikelihood(nojumps, y, inputdata.true_params);
loglikelihood_estp_nojm = EvaluateLikelihood(nojumps, y, posterior_mean_params);


for i=1:50

    % select a jump sample
    j = ceil(rand*(numel(inputdata.JumpSample)-jumpburn)+jumpburn);
    jumps = inputdata.JumpSample(j);
    
    loglikelihood_true_estj(i) = EvaluateLikelihood(jumps, y, inputdata.true_params);
    loglikelihood_estp_estj(i) = EvaluateLikelihood(jumps, y, posterior_mean_params);


end

for i=1:50
    myparams = VectorToParams([rand*2, -rand,-rand, rand*2, rand*2, rand*20, rand*20, 0*rand*0.3, rand*0.3] ,inputdata.true_params);
    loglikelihood_rndp_true(i) = EvaluateLikelihood(true_Jumps, y, myparams);
end

for i=1:50
    param_vec = ParamsToVector(inputdata.true_params);
    myparams = VectorToParams(param_vec + rand(size(param_vec)).*2*0.1.*param_vec-0.1*param_vec ,inputdata.true_params);
    loglikelihood_clse_true(i) = EvaluateLikelihood(true_Jumps, y, myparams);
end
for i=1:50
    param_vec = ParamsToVector(inputdata.true_params);
    myparams = VectorToParams(param_vec + rand(size(param_vec)).*2*0.25.*param_vec-0.25*param_vec ,inputdata.true_params);
    loglikelihood_cl25_true(i) = EvaluateLikelihood(true_Jumps, y, myparams);
end
for i=1:50
    param_vec = ParamsToVector(inputdata.true_params);
    myparams = VectorToParams(param_vec + rand(size(param_vec)).*2*0.5.*param_vec-0.5*param_vec ,inputdata.true_params);
    loglikelihood_cl50_true(i) = EvaluateLikelihood(true_Jumps, y, myparams);
end
for i=1:50
    param_vec = ParamsToVector(inputdata.true_params);
    myparams = VectorToParams(param_vec + rand(size(param_vec)).*2*1.*param_vec-param_vec ,inputdata.true_params);
    loglikelihood_cl100_true(i) = EvaluateLikelihood(true_Jumps, y, myparams);
end

fprintf('                      estimated jumps                true jumps                no jumps\n');
fprintf('estimated params      %g (%g)              %g                 %g\n', mean(loglikelihood_estp_estj), std(loglikelihood_estp_estj), loglikelihood_estp_true, loglikelihood_estp_nojm);
fprintf('true params           %g (%g)              %g                 %g\n', mean(loglikelihood_true_estj), std(loglikelihood_true_estj), loglikelihood_true_true, loglikelihood_true_nojm);
fprintf('true params +/- 10%%       N/A                    %g (%g)\n', mean(loglikelihood_clse_true), std(loglikelihood_clse_true));
fprintf('true params +/- 25%%       N/A                    %g (%g)\n', mean(loglikelihood_cl25_true), std(loglikelihood_cl25_true));
fprintf('true params +/- 50%%       N/A                    %g (%g)\n', mean(loglikelihood_cl50_true), std(loglikelihood_cl50_true));
fprintf('true params +/- 100%%       N/A                    %g (%g)\n', mean(loglikelihood_cl100_true), std(loglikelihood_cl100_true));
fprintf('random params             N/A                    %g (%g)\n', mean(loglikelihood_rndp_true), std(loglikelihood_rndp_true));

end

