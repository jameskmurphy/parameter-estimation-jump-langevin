function [ output_args ] = covcalculations( input_args )
%COVCALCULATIONS Summary of this function goes here
%   Detailed explanation goes here

% Set up symbols
sigma = sym('sigma', 'positive');
theta = sym('theta', 'real');
t     = sym('t', 'real');
T     = sym('T', 'real');

bs = [0;sigma];
As = [0 1; 0 -theta];
eATmts = expm(-As*(t-T));
covs = int( eATmts * bs * bs' * eATmts', t, 0, T);

% Test
sig = 1;
th  = 0.1;
Tv   = 1;

Qeval = eval(subs( covs, [sigma, theta, T], [sig, th, Tv]));
 
Qtrue = CalculateCov([0 1;0 -th], [0;sig], Tv, zeros(2));


Qeval-Qtrue


Qtest = [ (1/theta^3) * Tv/th^2 - exp(-2*th*Tv)

covs
end

