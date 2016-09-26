#' Function working as testbench for comparison of imputing models
#'
#' @param dataIn input \code{\link[stats]{ts}} for testing, defaults to \code{\link[datasets]{nottem}}
#' @param smps chr string indicating sampling type for generating missing data, see details
#' @param missPercentFrom numeric from which percent of missing values to be considered
#' @param missPercentTo numeric for up to what percent missing values are to be considered
#' @param interval numeric for interval between consecutive missPercent values
#' @param blck numeric indicating block sizes as a proportion of the sample size for the missing data, applies only if \code{smps = 'mcar'}
#' @param blckper logical indicating if the value passed to \code{blck} is a proportion of the sample size for missing data, otherwise \code{blck} indicates number of observations
#' @param repetition numeric for repetitions to be done for each missPercent value
#' @param errorParameter chr string indicating which error type to use, acceptable values are \code{"rmse"} (default), \code{"mae"}, \code{"mape"}, or \code{"other"}
#' @param errorPath chr string of location of error function for evaluating imputations, applies only if \code{errorParameter = "other"}
#' @param errorName chr string for name of error function for evaluating imputations, applies only if \code{errorParameter = "other"}
#' @param MethodPath chr string of location of function for the proposed imputation method
#' @param MethodName chr string for name for function for the proposed imputation method
#'
#' @details The \code{smps} argument indicates the type of sampling for generating missing data.  Options are \code{smps = 'mcar'} for missing completely at random and \code{smps = 'mar'} for missing at random.  Additional information about the sampling method is described in \code{\link{sample_dat}}.
#'
#' @import imputeTS
#' @importFrom stats ts
#' @importFrom methods hasArg
#'
#' @seealso \code{\link{sample_dat}}
#'
#' @return Returns error comparison for imputation methods
#'
#' @export
#'
#' @examples
#' aa <- impute_errors()
#' aa

#==================================================================================
# impute_error starts here....
#==================================================================================

impute_errors <- function(dataIn = NULL, smps = 'mcar', methods = c("na.mean", "na.interpolation"), args = list(na.approx = list(na.rm = FALSE), na.spline = list(na.rm = FALSE)), blck = 0.5, blckper = TRUE, missPercentFrom = 10, missPercentTo = 90, interval = 10, repetition = 10, errorParameter = 'rmse', errorPath = NULL, errorName = NULL, MethodPath = NULL, MethodName = 'Proposed Method', ...)
{

  # Sample Dataset 'nottem' is provided for testing in default case.
  if(is.null(dataIn))
    dataIn <- nottem

  dataIn <- as.numeric(unlist(dataIn))

  # check if errorParameter is okay
  if(!errorParameter %in% c('rmse', 'mae', 'mape', 'other'))
    stop('errorParameter must be one of rmse, mae, mape, other')

  # missing percentages to evaluate
  percs <- seq(missPercentFrom, missPercentTo, interval)

  # create master list for output
  errall <- vector('list', length = length(percs))
  errall <- rep(list(errall), length(methods))
  names(errall) <- methods

  # get other error
  if(errorParameter == 'other'){

    source(errorPath)

    if(is.null(errorName))
      stop('name of error function not provided in errorName')

    errorParameter <- errorName

  }

  # go through each imputation method
  for(method in methods){

    # create missing data for each missing percentage
    # take error estimates for each repetition
    for(x in seq_along(percs)){

      # create the missing data for imputation
      b <- percs[x]/100
      out <- sample_dat(dataIn, smps = smps, b = b, repetition = repetition,
        blck = blck, blckper = blckper, plot = FALSE)

      # iterate through each repetition, get predictions, get error
      errs <- lapply(out, function(x){

        toeval <- paste0(method, '(x, ...)')
        filled <- eval(parse(text = toeval))
        errout <- paste0(errorParameter, '(dataIn, filled)')
        eval(parse(text = errout))

      })

      # append to master list
      errall[[method]][[x]] <- unlist(errs)

    }

  }

  ##
  # summarize for output
  out <- lapply(errall, function(x) unlist(lapply(x, mean)))
  out <- c(list(Parameter = errorParameter, Missing_Percent = percs), out)

  # create errprof object
  out <- structure(
    .Data = out,
    class = c('errprof', 'list'),
    errall = errall
  )

  return(out)

}
