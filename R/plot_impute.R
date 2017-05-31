#' Plot imputations
#'
#' Plot imputations for data from multiple methods
#'
#' @param dataIn input \code{\link[stats]{ts}} for testing
#' @param smps chr string indicating sampling type for generating missing data, see details
#' @param methods chr string of imputation methods to use, one to many.  A user-supplied function can be included if \code{MethodPath} is used.
#' @param methodPath chr string of location of script containing one or more functions for the proposed imputation method(s)
#' @param blck numeric indicating block sizes as a percentage of the sample size for the missing data, applies only if \code{smps = 'mcar'}
#' @param blckper logical indicating if the value passed to \code{blck} is a percentage of the sample size for missing data, otherwise \code{blck} indicates number of observations
#' @param missPercent numeric for percent of missing values to be considered
#' @param showmiss logical if actual missing values are plotted
#' @param addl_arg arguments passed to other imputation methods as a list of lists, see details.
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing the imputed data for each method.  Imputed data are colored as 'filled'.  Actual missing data can be added to the plot if \code{showmiss = TRUE}.
#'
#' @import ggplot2
#' @import zoo
#'
#' @details See the documentation for \code{\link{impute_errors}} for an explanation of the arguments.
#'
#' @export
#'
#' @examples
#' plot_impute(dataIn = nottem)
plot_impute <- function(dataIn, smps = 'mcar', methods = c("na.approx", "na.interp", "na.interpolation", "na.locf", "na.mean"),  methodPath = NULL, blck = 50, blckper = TRUE, missPercent = 50, showmiss = FALSE, addl_arg = NULL){

  # source method if provided
  if(!is.null(methodPath))
    source(methodPath)

  # check if methods are okay
  meth_chk <- sapply(methods, function(x) exists(x), simplify = FALSE)
  if(any(!unlist(meth_chk))){
    no_func <- names(meth_chk)[!unlist(meth_chk)]
    no_func <- paste(no_func, collapse = ', ')
    stop(no_func, ' does not exist')
  }

  # create master list for output
  imps <- vector('list', length = length(methods))
  names(imps) <- methods

  # fill arguments with list
  args <- rep(list(list()), length = length(methods))
  names(args) <- methods
  if(!is.null(addl_arg))
    args[names(addl_arg)] <- addl_arg

  # create the missing data for imputation
  b <- missPercent
  out <- sample_dat(dataIn, smps = smps, b = b, repetition = 1,
    blck = blck, blckper = blckper, plot = FALSE)

  # go through each imputation method
  for(method in methods){

    # arguments and method to eval
    arg <- list(args[[method]])
    toeval <- paste0('do.call(', method, ', args = c(list(out[[1]]),', arg, '))')
    toeval <- gsub(',)', ')', toeval)

    # get predictions
    filled <- eval(parse(text = toeval))

    # append to master list
    imps[[method]] <- filled

  }

  # prep for plot
  toplo <- do.call('cbind', c(imps))
  toplo <- data.frame(toplo)
  toplo$Filled <- 0
  toplo$Filled[is.na(out[[1]])] <- 1
  toplo$Filled <- factor(toplo$Filled)
  toplo$Actual <- dataIn
  toplo$Actual[toplo$Filled %in% '0'] <- NA
  toplo$Time <- 1:nrow(toplo)
  toplo <- tidyr::gather(toplo, 'Method', 'Value', -Time, -Filled, -Actual)

  # plot
  p <- ggplot(toplo, aes(x = Time, y = Value)) +
    geom_point(aes(colour = Filled), alpha = 0.75, na.rm = TRUE) +
    facet_wrap(~Method, ncol = 1) +
    theme_bw() +
    theme(
      legend.position = 'top',
      legend.key = element_blank()
      )

  # add actual missing values if T
  if(showmiss)
    p <- p +
      geom_point(aes(y = Actual), pch = 21, fill = NA, alpha = 0.75, na.rm = TRUE)

  return(p)

}
