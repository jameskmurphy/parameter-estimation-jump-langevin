function loginvgampdf = loginvgampdf( x, a, b )
%INVGAMPDF Summary of this function goes here
%   Detailed explanation goes here

%invgampdf = b^a/gamma(a).*(1./x).^(a+1).*exp(-b./x);
%loginvgampdf = log(invgampdf)
loginvgampdf = a*log(b) - log(gamma(a)) - (a+1)*log(x) - b./x;




end

