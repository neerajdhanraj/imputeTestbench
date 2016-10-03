#' Function working as testbench for comparison of imputing models
#'
#' @param dataIn input \code{\link[stats]{ts}} for testing, defaults to \code{\link[datasets]{nottem}}
#' @param smps chr string indicating sampling type for generating missing data, see details
#' @param methods chr string of imputation methods to use, one to many.  A user-supplied function can be included if \code{MethodPath} is used, see details.
#' @param methodPath chr string of location of function for the proposed imputation method
#' @param errorParameter chr string indicating which error type to use, acceptable values are \code{"rmse"} (default), \code{"mae"}, or \code{"mape"}.  Alternatively, a user-supplied function can be passed if \code{errorPath} is used, see details.
#' @param errorPath chr string of location of error function for evaluating imputations
#' @param blck numeric indicating block sizes as a percentage of the sample size for the missing data, applies only if \code{smps = 'mcar'}
#' @param blckper logical indicating if the value passed to \code{blck} is a percentage of the sample size for missing data, otherwise \code{blck} indicates number of observations
#' @param missPercentFrom numeric from which percent of missing values to be considered
#' @param missPercentTo numeric for up to what percent missing values are to be considered
#' @param interval numeric for interval between consecutive missPercent values
#' @param repetition numeric for repetitions to be done for each missPercent value
#' @param ... arguments passed to other imputation methods
#'
#' @details The \code{smps} argument indicates the type of sampling for generating missing data.  Options are \code{smps = 'mcar'} for missing completely at random and \code{smps = 'mar'} for missing at random.  Additional information about the sampling method is described in \code{\link{sample_dat}}.
#'
#' A user-supplied funcion can be passed to \code{methods} as an additional imputation method.  A character string indicating the path of the function must also be supplied to \code{methodPath}.  The path must point to a function where the first argument is the time series to impute.  Additional arguments for the function are passed as a list to the \code{...} argument, where the list contains the same number of elements equal in length to the \code{methods} argument, i.e., a list of lists where each element is a smaller list passed to each function in \code{methods}. See the examples.
#'
#' Similarly, an alternative error function can be passed to \code{errorParameter} if \code{errorPath} is not \code{NULL}.  The function specified in \code{errorPath} must have two arguments where the first is a vector for the observed time series and the second is a vector for the predicted time series.
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
#'
#' # passing additional imputation methods
impute_errors <- function(dataIn = NULL, smps = 'mcar', methods = c("na.mean", "na.interpolation"),  methodPath = NULL, errorParameter = 'rmse', errorPath = NULL, blck = 50, blckper = TRUE, missPercentFrom = 10, missPercentTo = 90, interval = 10, repetition = 10, ...)
{

  # Sample Dataset 'nottem' is provided for testing in default case.
  if(is.null(dataIn))
    dataIn <- nottem

  dataIn <- as.numeric(unlist(dataIn))

  # check if methods are okay
  meth_chk <- sapply(methods, function(x) exists(x), simplify = FALSE)
  if(any(!unlist(meth_chk))){
    no_func <- names(meth_chk)[!unlist(meth_chk)]
    no_func <- paste(no_func, collapse = ', ')
    stop(no_func, ' does not exist')
  }

  # check if errorParameter is okay
  if(!exists(errorParameter))
    stop(errorParameter, ' does not exist')

  # missing percentages to evaluate
  percs <- seq(missPercentFrom, missPercentTo, interval)

  # create master list for output
  errall <- vector('list', length = length(percs))
  errall <- rep(list(errall), length(methods))
  names(errall) <- methods

  # create missing data for each missing percentage
  # take error estimates for each repetition
  for(x in seq_along(percs)){

    # create the missing data for imputation
    b <- percs[x]
    out <- sample_dat(dataIn, smps = smps, b = b, repetition = repetition,
      blck = blck, blckper = blckper, plot = FALSE)

    # go through each imputation method
    for(method in methods){

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
