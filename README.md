![In progress](http://i.stack.imgur.com/kmfPT.png)
Work in progress, the package not ready for release.

<a href="https://github.com/virgile-baudrot/trophicR">
<img src="https://github.com/virgile-baudrot/trophicR/blob/master/images/logo.png" width=200 alt="TrophicR Logo"/>
</a>

# trophicR

<!---
[![Build Status](https://travis-ci.org/stan-dev/rstanarm.svg?branch=master)](https://travis-ci.org/stan-dev/rstanarm)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rstanarm?color=blue)](http://cran.r-project.org/package=rstanarm)
[![Downloads](http://cranlogs.r-pkg.org/badges/rstanarm?color=blue)](http://cran.rstudio.com/package=rstanarm)
-->

**trophicR** is an R package to facilitate model-fitting of functional
responses (trophic interactions) using a Bayesian approach with [Stan](http://mc-stan.org) (via the **rstan** package).

The way I'm developping **trophicR** is deeply inspired by the [rstanarm](https://github.com/stan-dev/rstanarm) package.

## Installation

This package is not yet on the CRAN (basically, the classical command line
`install.packages("trophicR")` won't work), so please use the development
version provided on this Github repository.

To install from GitHub, first make sure that you can install the **rstan**
package and C++ toolchain by following these
[instructions](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started).
Once **rstan** is successfully installed, you can install **trophicR** from
GitHub using the **devtools** package by executing the following in R:

```r
if (!require(devtools)) {
  install.packages("devtools")
  library(devtools)
}
install_github("virgile-baudrot/trophicR", args = "--preclean", build_vignettes = FALSE)
```

Make sure to include the `args = "--preclean"` and `build_vignettes = FALSE` arguments
or the development version of package will not install properly. If installation fails,
please let us know by [filing an issue](https://github.com/virgile-baudrot/trophicR/issues).

## Starting with trophicR

Once the package **trophicR** is installed in your environment, try to estimate a classical Holling type 2 functional response.

Holling type 2 functional response for multi species is mathematically described by the function *Phi* (the rate of ingestion of prey *i* depending on density of *n* prey species):

<a href="https://www.codecogs.com/eqnedit.php?latex=\Phi_1(x_1,&space;x_2)&space;=&space;\frac{a_1&space;x_1}{&space;1&space;&plus;&space;a_1&space;h_1&space;x_1&space;&plus;&space;a_2&space;h_2&space;x_2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\Phi_1(x_1,&space;x_2)&space;=&space;\frac{a_1&space;x_1}{&space;1&space;&plus;&space;a_1&space;h_1&space;x_1&space;&plus;&space;a_2&space;h_2&space;x_2}" title="\Phi_1(x_1, x_2) = \frac{a_1 x_1}{ 1 + a_1 h_1 x_1 + a_2 h_2 x_2}" /></a>


with *x_1* and *x_2* the densities of prey species (or any other measures of prey availability). Parameters *a_1*, *a_2* are the attack rate toward prey *1* and *2* respectivelly, and *h_1*, *h_2* are the handling times for both preys. 

1. load the library
```r
library(trophicR)
```

2. load the data set, and then a plot (using the library **ggplot2**)

The data set is totally explained in [Raoul et al. (2010)](https://link.springer.com/article/10.1007/s00442-010-1647-8) and was use in our common paper [Baudrot et al. (2016)](http://onlinelibrary.wiley.com/doi/10.1890/15-0427.1/full).

*Raoul, F.; Deplazes, P.; Rieffel, D.; Lambert, J.-C. & Giraudoux, P. Predator dietary response to prey density variation and consequences for cestode transmission. Oecologia, Springer, 2010, 164, 129-139*

*Baudrot, V.; Perasso, A.; Fritsch, C.; Giraudoux, P. & Raoul, F. The adaptation of generalist predators diet in a multi-prey context: insights from new functional responses. Ecology, 2016, 97, 1832-1841*

```r
data("fox_Raoul2010")

# plot of the data set
library(ggplot2)
df_fox <- data.frame(density = c(fox_Raoul2010$N_avail[,1], fox_Raoul2010$N_avail[,2]),
                     diet = c(fox_Raoul2010$N_diet[,1], fox_Raoul2010$N_diet[,2] ),
                     nFaeces = rep(fox_Raoul2010$nFaeces, 2),
                     species = c(rep("Arvicola scherman",41), rep("Microtus arvalis", 41)))

ggplot(data = df_fox) + theme_light() +
  labs(x = "prey available", y = "proportion of prey ingested") +
  geom_point(aes(x = density, y = diet/nFaeces, group = species)) +
  facet_wrap(~ species)
```

<img src="https://github.com/virgile-baudrot/trophicR/blob/master/images/foxData.png" width=800 alt="fox Data"/>



3. Fit the model with the function `trophicFit`. Do not forget to specify the type of functional response (here `holling2`).
```r
fit_foxH2 <- trophicFit(data = fox_Raoul2010, trophic_model = "holling2")
```
Eplore the object `fit_foxH2`. Red point in the following graph are predictions of medians from Bayesian estimates.

<img src="https://github.com/virgile-baudrot/trophicR/blob/master/images/foxH2rep.png" width=800 alt="fox H2 rep"/>

4. Try to predict for other densities
```r
# Extract results
result_foxH2 <- extract(fit_foxH2, pars = c('a', 'h', 'phi', 'rep'))

aA <- result_foxH2$a[,1]
aM <- result_foxH2$a[,2]
hA <- result_foxH2$h[,1]
hM <- result_foxH2$h[,2]

# Compute prediction

dens <- expand.grid(A = seq(1,100,length.out = 12),
                    M = seq(1,100,length.out = 12))

phiA <- aA %*% t(dens$A) / (1 + (aA * hA) %*% t(dens$A) + (aM * hM) %*% t(dens$M))
phiM <- aM %*% t(dens$M) / (1 + (aA * hA) %*% t(dens$A) + (aM * hM) %*% t(dens$M))

df_foxH2pred <- data.frame(densA = dens$A,
                           densM = dens$M,
                           phiA_q50 = apply(phiA, 2, quantile, probs = 0.5),
                           phiM_q50 = apply(phiM, 2, quantile, probs = 0.5),
                           phiA_qinf95 = apply(phiA, 2, quantile, probs = 0.025),
                           phiM_qinf95 = apply(phiM, 2, quantile, probs = 0.025),
                           phiA_qsup95 = apply(phiA, 2, quantile, probs = 0.975),
                           phiM_qsup95 = apply(phiM, 2, quantile, probs = 0.975))

#
# Graphic in 2D while a 3D would be more relevant in that case
#

ggplot(data = df_foxH2pred) + theme_light() +
  labs(x = "prey available", y = "proportion of prey ingested",
       title ="Ingestion rate of Microtus arvalis depending of its density.\n Panel corresond to different density of Arvicola scherman") +
  geom_ribbon(aes(x = densM,
                  ymin = phiM_qinf95, ymax = phiM_qsup95), fill="pink", alpha = 0.3) +
  geom_line(aes(x = densM, y = phiM_q50), color="red") +
  facet_wrap(~ densA, ncol=4)

```

<img src="https://github.com/virgile-baudrot/trophicR/blob/master/images/foxH2Pred.png" width=800 alt="fox H2 predict"/>



## Getting help

* [Create an issue on GitHub](https://github.com/virgile-baudrot/trophicR/issues)

#### `trophicR` has been developped using package `rstantools`, here are some notes:

* It is important to clear the global environement of **Rstudio** before using
the function `rstan_package_skeleton`.

* A warning messages appears when compiling the package produce by
`rstan_package_skeleton`: *All text must be in a section line 26 in
 `myPackage/man/myPackage-package.Rd`*. To solve this, simply remove this
 sentence, or move it between braces.

* In the `Read-and-delete-me` file, line 16, it could be better to write:
 `#' @useDynLib mypackage, .registration = TRUE` rather than
  `#' @useDynLib rstanarm, .registration = TRUE`  which can be confusing in
  regards   with the begin of the sentence:
  `useDynLib(mypackage, .registration = TRUE)`. It could be also relevant to
  specify that it's necessary to use `#' @useDynLib rstanarm, .registration = TRUE`
   if the user generate the NAMESPACE file with roxygen2.

* For the warning with cleanup and cleanup.win not executable :
```
$ chmod +x cleanup
$ chmod +x cleanup.win
```
