function visJumpSamples( filename, inputdata, burnin, true_Jumps, data)
%VISJUMPSAMPLES Summary of this function goes here
%   Detailed explanation goes here

%addpath('C:\Users\jm362\Documents\MATLAB\thirdparty\export_fig\');

set(gcf, 'Position', [100 100 800 800])
set(gcf, 'Color', 'w');

jump_store = inputdata.JumpSample;
accepts    = inputdata.accepts(2:end);

PLOT_COLS = 1;

if(numel(accepts)>0)
    PLOT_ROWS = 3;
else
    PLOT_ROWS = 2;
end

if(size(data.y,2)>size(data.y,1)), data.y=data.y'; end

T = numel(data.y(:,end));%max(size(data.y))/min(size(data.y));%numel(data.y(:,2));

clf;
subplot(PLOT_ROWS,PLOT_COLS,1);
hold on;
ix = find(true_Jumps.isjumping(1,:) > 0);
safex = [0 data.x 0];
intensity = safex(ceil(true_Jumps.tau(ix))+1) - safex(floor(true_Jumps.tau(ix))+1);
VisMarkJumpTimes(true_Jumps.tau(ix), intensity, T);
subplot(PLOT_ROWS,PLOT_COLS,2);
hold on;
ix = find(true_Jumps.isjumping(2,:) > 0);
safexdot = [0 data.xdot 0];
intensity = safexdot(ceil(true_Jumps.tau(ix))+1) - safexdot(floor(true_Jumps.tau(ix))+1);
VisMarkJumpTimes(true_Jumps.tau(ix), intensity, T);

allxjumps = [];
allxdjumps = [];

for i=min(burnin,numel(jump_store)-1):numel(jump_store)
    if(numel(jump_store(i).tau)>0)
        ix = find(jump_store(i).isjumping(1,:) > 0);
        if(numel(ix)>0)
            %plot(jump_store(i).tau(ix), i, 'b.'); 
            allxjumps = [allxjumps,jump_store(i).tau(ix)];
        end
        ix = find(jump_store(i).isjumping(2,:) > 0);
        if(numel(ix)>0)
            %plot(jump_store(i).tau(ix), i, 'b.'); 
            allxdjumps = [allxdjumps,jump_store(i).tau(ix)];
        end
    end
end
subplot(PLOT_ROWS,PLOT_COLS,1);
hold on;
[n,xout] = hist(allxjumps(:), 0.5:1:(T+0.5));
bar(xout,n/(numel(jump_store)-burnin), 'FaceColor', [0.5 0.5 0.5], 'BarWidth',1, 'EdgeColor', 'none');
%shading flat

subplot(PLOT_ROWS,PLOT_COLS,2);
hold on;
[n,xout] = hist(allxdjumps(:), 0.5:1:(T+0.5));
bar(xout,n/(numel(jump_store)-burnin), 'FaceColor', [0.5 0.5 0.5], 'BarWidth',1, 'EdgeColor', 'none');
%shading flat


% draw on the data (scaled to fit)
subplot(PLOT_ROWS,PLOT_COLS,1);
hold on;
plot((data.x - min(data.x)) / (max(data.x)-min(data.x)) + 0.1, 'color', [0 0 0]);
axis([1,T,0,1.2]); 
ylabel('jumping')
title('x_1 process')

subplot(PLOT_ROWS,PLOT_COLS,2);
hold on;
if(numel(data.xdot)>0)
    plot((data.xdot - min(data.xdot)) / (max(data.xdot)-min(data.xdot)) + 0.1, 'color', [0 0 0]);
    plot((zeros(size(data.xdot)) - min(data.xdot)) / (max(data.xdot)-min(data.xdot)) + 0.1, 'k:', 'color', [0 0 0]);
end
axis([1,T,0,1.2]); 
ylabel('jumping')
xlabel('observation number (t)')
title('x_2 process')

% Regenerate the accepts from the results
if(numel(accepts)>0)
    accepts(1) = 0;
    for i=2:numel(jump_store)

        if(isequal(jump_store(i).tau, jump_store(i-1).tau))
            accepts(i) = accepts(i-1);
        else
            accepts(i) = accepts(i-1)+1;
        end

    end

    subplot(PLOT_ROWS,PLOT_COLS,3);
    plot(accepts, 'b-');
    axis([1,numel(accepts)+1,0, max(accepts)+1]); 
    ylabel('Accepted proposals')
    xlabel('Number of proposals')
end
drawnow;

if(numel(filename)>0)
    try
        export_fig(filename, '-a2', '-r300', '-painters');
    catch
        warning('image output failed');
    end
end



end

