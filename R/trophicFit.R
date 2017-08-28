# Fitting models for functional responses using Bayesian inference
#
# Fitting functional reponses using Bayesian inference for objects. 
#
# @param x an object used to select a method
# @param \dots Further arguments to be passed to generic methods
# 
# trophicFit <- function(x, ...){
#   UseMethod("trophicFit")
# }

#' Function to fit H2test model
#'
#' Estimate Bayesian Holling type 2 model using Stan on a single species
#' dataset
#'
#' @param data an object used to select a method
#' 
#' @export
trophicFit_H2test <- function(data, ...){
  
  model_object <- stanmodels$H2test
  
  fit <- rstan::sampling(
    object = model_object,
    data = data,
    ...)
  
  return(fit)
}

#' Function to fit Holling models
#'
#' Estimate Bayesian Holling type 2 or 3 model using Stan
#'
#' @param data an object used to select a method
#' 
#' @export
trophicFit <- function(data, trophic_model = NULL, ...){
  
  if(trophic_model == "holling2"){
    model_object <- stanmodels$holling2
  } else if(trophic_model == "holling3"){
    model_object <- stanmodels$holling3
  } else if(trophic_model == "KTW"){
    model_object <- stanmodels$KTW
  } else stop("'trophic_model' must be 'holling2' or 'holling3'.")
  
  fit <- rstan::sampling(
    object = model_object,
    data = data,
    ...)
  
  return(fit)
}