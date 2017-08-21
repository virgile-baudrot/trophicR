#' Fitting models for functional responses using Bayesian inference
#'
#' Fitting functional reponses using Bayesian inference for objects.
#'
#' @param x an object used to select a method
#' @param \dots Further arguments to be passed to generic methods

#' @export
trophicFit <- function(x, ...){
  UseMethod("trophicFit")
}
