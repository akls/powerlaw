# powerlaw
Statistical testing of truncated power law distributions using the log-likelihood ratio test.

This code can be used to estimate the alpha parameter for discrete, truncated power law distributions and to evaluate statistical significance by comparison to alternative distributions (e.g., exponential distribution, lognormal distribution).

An example to estimate parameters can be found in `getLLR.m`. The example estimates power law and exponential (`distname='geom'`) distribution parameters using the log-likelihood ratio. For the power law, use `distname='zeta'`. For the exponential distribution, use `distname='geom'`. For the log-normal distribution, use `distname='logn'`.

`avsz.txt` contains an example of power law distributed values.

Fore more details, please see Klaus et al. (2011) and Clauset et al. (2009).

Please cite this paper when using this code in your research: Klaus A, Yu S, Plenz D (2011) [Statistical Analyses Support Power Law Distributions Found in Neuronal Avalanches.](https://doi.org/10.1371/journal.pone.0019779) PLoS ONE 6(5): e19779.

See also: Clauset A, Shalizi CR, Newman MEJ (2009) [Power-law distributions in empirical data. SIAM Review 51: 661–703.](https://epubs.siam.org/doi/abs/10.1137/070710111)
