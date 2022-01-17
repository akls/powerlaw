function [LLR   pval] = getLLR(X,xmin,xmax,distname0,pinit0,distname1,pinit1)
%GETLLR Summary of this function goes here
%   Detailed explanation goes here

    [P  C]  = getPdf(X,xmin,xmax);
    param0  = estimateParam(C,xmin,xmax,distname0,pinit0,X);
    param1  = estimateParam(C,xmin,xmax,distname1,pinit1,X);
    %P0 = realmin + getPdf(distname0,param0,xmin,xmax);
    %P1 = realmin + getPdf(distname1,param1,xmin,xmax);
    P0 = getPdf(distname0,param0,xmin,xmax);
    P1 = getPdf(distname1,param1,xmin,xmax);
    
    %figure;loglog(P,'r.-');hold on;loglog(P0,'b');loglog(P1,'g');pause(0.1);
    
    prob0 = P0(X-xmin+1);
    prob1 = P1(X-xmin+1);
    
    if ~isempty(find(log(prob0) == -Inf)) || ...
       ~isempty(find(log(prob1) == -Inf))
        error('Zero probability.');
    end
    
    LLR = sum(log(prob0) - log(prob1));
    
    %pval = length(find(LLRvec<LLR)) / n;
    ml0 = sum(log(prob0))/length(X);
    ml1 = sum(log(prob1))/length(X);
    tmp = (log(prob0)-log(prob1))-(ml0-ml1);
    sigma2 = sum(tmp.*tmp)/length(X);
    %fprintf('n = %d\n', length(X));
    %fprintf('Sigma2=%.2f\n', sigma2);
    pval = erfc(abs(LLR)/sqrt(2*length(X)*sigma2));
    
    %fprintf('LR = %.3f\n', LR);
	%fprintf('LRvec from %.3f to %.3f (%.3f, %d trials)\n', min(LRvec), max(LRvec), LRvec(5), ntrial);
end
