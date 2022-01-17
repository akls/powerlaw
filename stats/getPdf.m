function [P  C] = getPdf(varargin)
%GETPDF Calculates the PDF and CDF for a vector of events, or a model such
%       as the zeta or log-normal distribution.
%   [P C] = getPdf(X,a,b) returns the PDF and the CDF for the vector of event
%           sizes X in the range a to b.
%   [P C] = getPdf(CDF,a,b,n) returns a synthetic PDF and CDF for a given
%           CDF.
%   [P C] = getPdf(distname,param,a,b,...) returns the theoretical PDF and CDF
%           for the distribution given by distname with parameters param in the
%           range a to b.
%           Distributions are: 'zeta' (alpha)    - Power law.
%                              'geom' (lambda)   - Exponential.
%                              'logn' (mu,sigma) - Lognormal.
%           Power law:   x.^-alpha
%           Exponential: lambda*exp(-lambda*x)
%
%   [P C] = getPdf(distname,param,a,b,n) returns a synthetic PDF and CDF for
%           the distribution given by distname with n sample points in the
%           range a to b.
% Examples: [P C] = getPdf(x,xmin,xmax)
%           [P C] = getPdf('zeta',alpha,xmin,xmax)
%           [P C] = getPdf('zeta',alpha,xmin,xmax,10e3)
%           [P C] = getPdf('geom',lambda,xmin,xmax)
%           [P C] = getPdf('logn',[mu, sigma],xmin,xmax)

    P = [];
    
    % Calculate PDF for the vector x of event sizes.
    if nargin == 3
        x    = varargin{1};
        xmin = varargin{2};
        xmax = varargin{3};
        for i = xmin:xmax; P(end+1) = length(find(x==i)); end
    
    % Calculate synthetic PDF and CDF from given CDF.
    elseif (nargin == 4) && isfloat(varargin{1})
        C = varargin{1};
        xmin = varargin{2};
        xmax = varargin{3};
        
        n = varargin{4};
        U = rand(1, n);
        
        % Get the synthetic PDF and CDF.
        P = [];
        for i = 1:length(C); P(end+1) = length(find(U<C(i))); end
        P = diff(P);
        
    % Calculate the PDF for a theoretical distribution.
    elseif nargin >= 4
        param = varargin{2};
        xmin  = varargin{3};
        xmax  = varargin{4};
        
        % Zeta distribution.
        if strcmp(varargin{1}, 'zeta')
            P = (xmin:xmax).^-param;
        
        % Geometrical distribution (discr. exponential).
        elseif strcmp(varargin{1}, 'geom')
            P = param*exp(-param*(xmin:xmax));
            
        % Binomial distribution.
        elseif strcmp(varargin{1}, 'binom')
            P = binopdf(xmin:xmax,xmax,param);
            
        % Geometrical distribution (discr. exponential, streched).
        elseif strcmp(varargin{1}, 'exp')
            %a=0.70207; h=1.33;
            %a=0.7; h=2.0;
            a = param(1); h = param(2);
            x=erfcinv(2*(xmin:xmax+1+3)/(xmax+1+3));
            y=2^0.5*(1-a)^0.5;
            e=a^-0.5*(h-x*y);
            z=a^0.5 *h/(2*a-1);
            b=(2*a-1)/(2*(1-a));
            q = exp(b*(e-z).^2);
            q(end-3:end) = [];
            P = q;
            
        % Lognormal distribution.
        elseif strcmp(varargin{1}, 'logn')
            P = exp(-0.5*((log(xmin:xmax)-param(1))/param(2)).^2) ./ ...
                  ((xmin:xmax)*param(2)*sqrt(2*pi));
              
        % Lognormal distribution with positive mean.
        elseif strcmp(varargin{1}, 'lognorm')
            P = exp(-0.5*((log(xmin:xmax)-param(1))/param(2)).^2) ./ ...
                  ((xmin:xmax)*param(2)*sqrt(2*pi));
            P(1) = P(1) + exp(1*log(eps)*param(1));
        
        else
            error('Unknown distribution %s.\n', distname);
        end
    end
    
    if sum(P) < realmin; P = []; C = []; return; end
    
    % Normalize the empirical or theoretical PDF.
    P(end+1) = 0; P = P/sum(P);
    
    % Calculate the empirical or theoretical CDF.
    C = cumsum([0  P]); C(end) = [];
    
    % Calculate a synthetic PDF and CDF.
    if nargin == 5
        n = varargin{5};
        U = rand(1, n);
        
        P = [];
        for i = 1:length(C)
            P(end+1) = length(find(U<C(i)));
        end
        
        % Get the synthetic PDF and CDF.
        P = diff(P);
        P(end+1) = 0; P = P/sum(P);
        C = cumsum([0  P]); C(end) = [];
    end
	