function [data, trueJumpSample] = GenerateData( params, T )
%GENERATEDATA Summary of this function goes here
%   Detailed explanation goes here

[ x xdot y alljumptimes alljumptypes] = GenerateData2( T, params );

data.x = x;
data.xdot = xdot;
data.y = y;
data.alljumptimes = alljumptimes;
data.alljumptypes = alljumptypes;

trueJumpSample.tau = data.alljumptimes(1:end-1);
trueJumpSample.isjumping = zeros(2, numel(trueJumpSample.tau));
for i=1:size(alljumptypes,2)-1
    trueJumpSample.isjumping(data.alljumptypes(i),i) = 1;
end

end

