function [p,Z] = truncnormpdf(x, mu, sigma, a, b)
Z = 1/ ( normcdf(b,mu,sigma)-normcdf(a,mu,sigma));

if(x>=a && x<=b), p = Z*normpdf(x,mu,sigma);
else p = 0;
end

end

