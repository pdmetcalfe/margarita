#' @importFrom stats simulate
#' @importFrom utils head
NULL

#' Create an object of class 'margarita'
#' @param rlm An object of class 'rlm' returned by \code{lmr}.
#' @param evmSim An object of class 'evmSim'.
#' @param newdata A \code{data.frame} containing the new data from which
#'        predictions are to be made. Defaults to \code{newdata=NULL} which will
#'        only work of there are no covariates in the linear model or the extreme
#'        value model (with the exception of the baseline term in the linear model)
#' @param trans A function matching that used to transform the response
#'        in the robust regression. Defaults to \code{trans=log}. Use
#'        \code{trans=I} if no transformation was made.
#' @param invtrans A function, the inverse of \code{trans}.
#' @param baseline Character string giving the name of the baseline variable.
#' @param minima Are the extremes minima rather than maxima (i.e. the response
#'        was multiplied by -1 prior to all modelling). Defaults to
#'        \code{minima=FALSE}.
#' @details Returns a list with class 'margarita', to be used with
#'       \code{simulate.margarita}.
#' @keywords models
#' @export margarita
margarita <- function(rlm, evmSim, newdata=NULL,
                      trans=log, invtrans=exp,
                      baseline="alt.b", minima=FALSE){
  if (class(rlm)[1] != "rlm"){
    stop("object should have class 'rlm'")
  }
  else if (is.null(rlm$cov)){
    stop("object should be created by lmr, not rlm")
  }
  if (class(evmSim) != "evmSim"){
    stop("object should have class 'evmSim'")
  }

  # Construct string for transformed baseline
  if (missing(trans)){ ctrans <- "log" }
  else {
    ctrans <- as.character(as.list(match.call())$trans)
  }
  rawBaseline <- baseline
  baseline <- if (ctrans != "I") paste0(ctrans, "(", rawBaseline, ")")
  else baseline
  
  if (! baseline %in% colnames(rlm$x))
    stop(paste0("Baseline variable '", baseline, "' is not in the linear model"))
  
  if (is.null(newdata))
    if (length(coef(evmSim)) == 2) newdata <- data.frame(1)
  else stop("There are covariates in the model: you need to provide newdata")
  
  # Construct output object and return
  res <- list(rlm, evmSim, newdata=newdata,
              baseline=baseline, rawBaseline=rawBaseline,
              trans=trans, invtrans=invtrans,
              minima=minima)
  oldClass(res) <- "margarita"
  res
}

#' @method print margarita
#' @export
print.margarita <- function(x, ...){
  print(x[[1]])
  cat("\n")
  print(x[[2]])
}
