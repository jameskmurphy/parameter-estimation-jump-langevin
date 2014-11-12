function VisMarkJumpTimes( jumptimes, jumpsize, maxtime )
%VISMARKJUMPTIMES Summary of this function goes here
%   Detailed explanation goes here
i=1;

intensity = abs(jumpsize) / max(abs(jumpsize));

if(numel(intensity)==1), intensity = intensity*ones(size(jumptimes)); end

for i=1:numel(jumptimes)
    if(jumptimes(i)>maxtime), break; end
    rectangle('Position',[jumptimes(i)-0.5, 0, 1, 2], 'LineStyle', 'none', 'LineWidth', 2, 'FaceColor', [1 1-min(intensity(i),1) 1-min(intensity(i),1)]);
end




end

