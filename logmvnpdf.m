function logp = logmvnpdf( x, mu, sigma )
%LOGMVNPDF log of pdf of a multivariate normal N(mu, sigma) at x
%  x     = 1xN ROW vector - point to evaluate
%  mu    = 1xN ROW vector - mean of MVN
%  sigma = NxN matrix     - covariance matrix of MVN

    logdetsigma = sum(log(eig(sigma)));
    
    if(imag(logdetsigma)>0)
        warning('The sigma matrix in logmvnpdf is not poitive definite (it has negative determinant)');
    elseif(logdetsigma==-Inf)
        warning('The sigma matrix is singular.  This might be an error or numerical inaccuracy.  Masking and continuing.');
        logp = -Inf;
        return;
    end
    
    if(min(size(x))>1), error('x is not a vector'); end
    if(min(size(mu))>1), error('mu is not a vector'); end
    
    if(size(x,1)>size(x,2)), x=x'; end
    if(size(mu,1)>size(mu,2)), mu=mu'; end

    k = numel(mu);
    
    logp = -0.5*((x-mu)/sigma)*(x-mu)' - (k/2)*log(2*pi) - 0.5*logdetsigma;
    
    if(imag(logp)~=0)
        warning('Imaginary number generated.  Is this what you wanted?');
    end
end

