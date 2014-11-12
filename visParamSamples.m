function visParamSamples( param_store, true_param_vec, SampleParams, burn )
%VISPARAMSAMPLES Summary of this function goes here
%   Detailed explanation goes here
titles = {'\sigma_{obs}', '\theta_{1}', '\theta_{2}', '\sigma_{1}', '\sigma_{2}', '\sigma_{jump_1}', '\sigma_{jump_2}', '\lambda_{1}', '\lambda_{2}'};
clf;

set(gcf, 'Position', [100 100 900 600])
set(gcf, 'Color', 'w');

% make all sigma2s into sigmas
param_store([1 6 7], :) = sqrt(param_store([1 6 7], :));
if(numel(true_param_vec)>0)
    true_param_vec([1 6 7]) = sqrt(true_param_vec([1 6 7]));
end

for i=1:9
    subplot(3,6,i*2-1);
    cla;
    hold on;
    if(SampleParams(i))
        plot(param_store(i,:),'b-');
    end
    if(numel(true_param_vec)>0)
        plot([0,size(param_store,2)], [true_param_vec(i),true_param_vec(i)], 'r-');
    end
    title(titles{i});
    set(gca, 'XLim', [1 size(param_store,2)], 'XTick', 0:5000:size(param_store,2)); 
end

for i=1:9
    subplot(3,6,i*2);
    cla;
    hold on;
    if(SampleParams(i))
        [n, xout] = hist(param_store(i,min(burn+1,size(param_store,2)):end),50);
        bar(xout,n, 'FaceColor', [0.5 0.5 0.5], 'BarWidth',1, 'EdgeColor', 'none');
        if(numel(true_param_vec)>0)
            plot([true_param_vec(i),true_param_vec(i)], [0,max(n)], 'r-');
        end
    end
    title(titles{i});
end
drawnow;
end

