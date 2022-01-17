function param = estimateParam(varargin)
%ESTIMATEPARAM Estimates the parameter for the given empirical distribution
%              assuming a model given by 'distname'.
%   param = estimateParam(CDF,xmin,xmax,distname,pinit)

    CDF      = varargin{1};
    xmin     = varargin{2};
    xmax     = varargin{3};
    distname = varargin{4};
    pinit    = varargin{5};
    
    % Least-square fitting of log-log data.
    if nargin > 7
        PDF    = varargin{7};
        binvec = varargin{8};
        param = fminsearch(@(p) getMSE(p,distname,PDF,xmin,xmax,binvec), ...
                           pinit,optimset('TolX',1e-8,'Display','off'));
    % Maximum likelihood estimation.
    elseif nargin > 5
        X = varargin{6};
        param = fminsearch(@(p) getMinML(p,distname,X,xmin,xmax), ...
                           pinit,optimset('TolX',1e-8,'Display','off'));
	
	% KS estimation.
    else
        param = fminsearch(@(p) getD(p,distname,CDF,xmin,xmax), ...
                           pinit,optimset('TolX',1e-8,'Display','off'));
    end
end

