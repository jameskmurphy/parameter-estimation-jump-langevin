function [ x xdot y alljumptimes alljumptypes ] = GenerateData2( T, params )
%GENERATEDATA2 Summary of this function goes here
%   Detailed explanation goes here

% Generate a jump-time series for x and xdot
% Generate the jump process
xjumptimes(1) = 1 + exprnd(1/params.jumprate(1));
xdotjumptimes(1) = 1 + exprnd(1/params.jumprate(2));
xjumpintensity(1) = randn(1)*params.sigmajump(1);
xdotjumpintensity(1) = randn(1)*params.sigmajump(2);

i=1;
while(xjumptimes(i)<T)
     xjumptimes(i+1) = xjumptimes(i) + exprnd(1/params.jumprate(1));
     %xjumpintensity(i+1) = randn(1)*params.sigmajump(1);
     i = i+1;
end

i=1;
while(xdotjumptimes(i)<T)
     xdotjumptimes(i+1) = xdotjumptimes(i) + exprnd(1/params.jumprate(2));
     %xdotjumpintensity(i+1) = randn(1)*params.sigmajump(2);
     i = i+1;
end

% make a list of all jump times
xind  = 1;
xdind = 1;
alljumptimes=[];
alljumptypes=[];
%alljumpintensities=[];
while(numel(alljumptimes)==0 || alljumptimes(end)<T)
    if(xjumptimes(xind)<xdotjumptimes(xdind))
        alljumptimes(end+1) = xjumptimes(xind);
        %alljumpintensities(end+1) = xjumpintensity(xind);
        xind=xind+1;
        alljumptypes(end+1) = 1;
    else
        alljumptimes(end+1) = xdotjumptimes(xdind);
        %alljumpintensities(end+1) = xdotjumpintensity(xdind);
        xdind = xdind+1;
        alljumptypes(end+1) = 2;
    end
end

jind=1;
A = [-params.lambdax, 1; 0, -params.lambdaxdot];
b = [params.sigmax 0; 0 params.sigmaxdot];
tcur = 1;

X(:,1) = [0;0];

for t=2:T
    % this is the step from tcur to t
    
    cov = zeros(2);
    
    while(alljumptimes(jind)<t)
        cov = CalculateCov(A,b, alljumptimes(jind)-tcur, cov);
        covJump = [ (alljumptypes(jind)==1)*params.sigmajump(1)^2 0; 0 (alljumptypes(jind)==2)*params.sigmajump(2)^2];
        cov = cov + covJump;
        tcur = alljumptimes(jind);
        jind=jind+1;
    end
    
    cov = CalculateCov(A,b, t-tcur, cov);
    mu = expm(A*1)*X(:,t-1);
    X(:,t) = mvnrnd(mu,max(cov,cov'))';
    tcur=t;
end

x = X(1,:);
xdot = X(2,:);
y(:,1) = 1:T;
y(:,2) = x + randn(size(x))*params.sigmaobs;

% Plot the data to look at it
clf;
subplot(3,1,1);
hold on;
plot(y(:,1), xdot, 'r-');
subplot(3,1,2);
plot(y(:,1), x);
subplot(3,1,3);
plot(y(:,1), y(:,2), 'g-');

end

