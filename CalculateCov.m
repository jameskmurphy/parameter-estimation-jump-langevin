function Cov = CalculateCov( A, B, t, CovIn )
%CALCULATECOV Calculates the covariance matrix  of the system 
%     dX = (AX + C)dt + BdW 
% over a period 0 to t using the matrix fraction decomposition 
% (see, e.g. J. Murphy PhD thesis, appendix B and references therein)
%
% The result Cov is the covariance of X_t
% CovIn is the covariance of X_0 (use 0 (or zero matrix) is X_0 is
% deterministic)

N = size(A,1);

F = A;
L = B;
Q = eye(N);

E = [F L*L'; zeros(N) -F'];

E0 = [CovIn; eye(N)];

Et = expm(E*t)*E0;

Ct = Et(1:N, :);
Dt = Et(N+1:end, :);

Cov = Ct/Dt;

end

