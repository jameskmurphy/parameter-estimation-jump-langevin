function x = sampletruncnorm(mu, sigma, a, b)

u=inf;
tn=1; Z=1; x=mu;

while ( u > tn / (Z*normpdf(x,mu,sigma)) )

    x = randn*sigma + mu;
    u = rand;
    [tn,Z] = truncnormpdf(x,mu,sigma, a,b);

end

end

