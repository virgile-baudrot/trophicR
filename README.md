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

**trophicR** is deeply inspired by the [rstanarm](https://github.com/stan-dev/rstanarm) package.

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
