function str = getTimestamp( )
%GETTIMESTAMP Summary of this function goes here
%   Detailed explanation goes here

    c = clock();
    str = sprintf('%4d-%2d-%2d %2d.%2d.%2d',c(1),c(2),c(3),c(4),c(5),floor(c(6)));

end

