% This is the code used for the test and parameter estimation of power law
% distributions in Klaus et al., 2011, PLOS One, Statistical analyses support power
% law distributions found in neuronal avalanches, DOI: 10.1371/journal.pone.0019779
% 
% 

%% Config.
clear;
addpath('stats');

%% Load data.
fprintf('Load synthethic data set ...\n');
avsz = load('avsz.txt');

%% Run test, get and show fits.
xmin =  1;
xmax = 64;

avsz(avsz<xmin) = []; avsz(avsz>xmax) = [];
[Pn  Cn] = getPdf(avsz,xmin,xmax);

alpha  = estimateParam(Cn,xmin,xmax,'zeta',1.5,avsz); Pz = getPdf('zeta',alpha,xmin,xmax);
lambda = estimateParam(Cn,xmin,xmax,'geom',1.0,avsz); Pe = getPdf('geom',lambda,xmin,xmax);

[LLR  p]  = getLLR(avsz,xmin,xmax,'zeta',1.5,'geom',1.0);

fprintf('=== Distribution with %d samples ===\n',length(avsz));
fprintf('Alpha  = %.2f\n',alpha);
fprintf('Lambda = %.2f\n',lambda);
fprintf('LLR    = %.2f (p=%.5f)\n',LLR,p);

figure(10);
loglog(Pn, 'ro-','LineWidth',2); hold on;
loglog(Pz, 'g-','LineWidth',2); axis square;
loglog(Pe, 'b-','LineWidth',2);
xlabel('Size s'); ylabel('p(s)');
title(sprintf('n=%d samples, LLR=%.2f, p=%.5f',length(avsz),LLR,p));
legend({'Data';'Power law fit';'Exponential fit'});
