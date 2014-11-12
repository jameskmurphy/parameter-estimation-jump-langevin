function visParamSamples5( param_store, true_param_vec, SampleParams, burn )
%VISPARAMSAMPLES Summary of this function goes here
%   Detailed explanation goes here
titles = {'\sigma_{obs}', '\gamma', '\sigma', '\sigma_{J}', '\lambda'};
clf;

set(gcf, 'Position', [100 100 900 600])
set(gcf, 'Color', 'w');

% make all sigma2s into sigmas
param_store([1 6 7], :) = sqrt(param_store([1 6 7], :));
if(numel(true_param_vec)>0)
    true_param_vec([1 6 7]) = sqrt(true_param_vec([1 6 7]));
end

%todraw = [1 0 1 0 1 0 1 0 1]
todraw = [1 3 5 7 9];

for i=1:numel(todraw)
    ix=todraw(i);
    subplot(3,4,i*2-1);
    cla;
    hold on;
    if(SampleParams(ix))
        plot(param_store(ix,:),'b-');
    end
    if(numel(true_param_vec)>0)
        plot([0,size(param_store,2)], [true_param_vec(ix),true_param_vec(ix)], 'r-');
    else
        plot([0,size(param_store,2)], mean(param_store(ix,burn:end))*[1 1], 'g-');
    end
    title(titles{i});
    set(gca, 'XLim', [1 size(param_store,2)], 'XTick', 0:5000:size(param_store,2)); 
    fprintf('Param %s:  %5.2f (%5.2f)\n', titles{i}, mean(param_store(ix,burn:end)), std(param_store(ix,burn:end)));

end

for i=1:1:numel(todraw)
    ix=todraw(i);
    subplot(3,4,i*2);
    cla;
    hold on;
    if(SampleParams(ix))
        [n, xout] = hist(param_store(ix,min(burn+1,size(param_store,2)):end),20);
        bar(xout,n, 'FaceColor', [0.5 0.5 0.5], 'BarWidth',1, 'EdgeColor', 'none');
        if(numel(true_param_vec)>0)
            plot([true_param_vec(ix),true_param_vec(ix)], [0,max(n)], 'r-');
        else
            plot(mean(param_store(ix,burn:end))*[1 1], [0,max(n)], 'g-');
        end
    end
    title(titles{i});
end
drawnow;
end

