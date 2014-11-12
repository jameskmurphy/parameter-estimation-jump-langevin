function [ output_args ] = tuncatedtest( input_args )
%TUNCATEDTEST Summary of this function goes here
%   Detailed explanation goes here

sigma = 1;

a= -2;
b=2;

x1 = -0.5;
x2 = 0.9;

d = truncnormpdf(x1,x2, sigma, a,b) - truncnormpdf(x2,x1, sigma, a,b)
dx = normpdf(x1,x2, sigma) - normpdf(x2,x1, sigma)

clf;
nsamp = 50000;
for i=1:nsamp
    x(i) = sampletruncnorm(x1, sigma, a, b);
end
nbins = 30;
hist(x,nbins);
hold on;

xs = a-1:0.01:b+1;
for i=1:numel(xs)
    ys(i) = truncnormpdf(xs(i), x1, sigma, a, b);
end
plot(xs, ys*nsamp*(b-a)/nbins, 'r-');  

end

function [p,Z] = truncnormpdf(x, mu, sigma, a, b)
Z = 1/ ( normcdf(b,mu,sigma)-normcdf(a,mu,sigma));

if(x>=a && x<=b), p = Z*normpdf(x,mu,sigma);
else p = 0;
end

end

function x = sampletruncnorm(mu, sigma, a, b)

u=inf;
tn=1; Z=1; x=mu;

while ( u > tn / (Z*normpdf(x,mu,sigma)) )

    x = randn*sigma + mu;
    u = rand;
    [tn,Z] = truncnormpdf(x,mu,sigma, a,b);

end

end