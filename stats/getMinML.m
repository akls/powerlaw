function D = getMinML(varargin)
%GETMINML Calculates ...
%   v = getMinML(param,distname,X,smin,smax)

    param    = varargin{1};
    distname = varargin{2};
    X        = varargin{3};
    xmin = varargin{4};
    xmax = varargin{5};
    
    P = getPdf(distname,param,xmin,xmax);
    %P
    if isempty(P)
        D = inf; idx = -1;
        fprintf('%s (%.2e, %d..%d)\n', distname, param, xmin, xmax);
        return;
    elseif isnan(sum(P))
        D = inf; idx = -1;
        fprintf('%s (%.2e, %d..%d)\n', distname, param, xmin, xmax);
        return;
    end
    
    prob = P(X-xmin+1);
    D = -sum(sort(log(prob)));
    