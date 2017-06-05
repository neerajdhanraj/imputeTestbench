#' Plot imputations
#'
#' Plot imputations for data from multiple methods
#'
#' @param dataIn input \code{\link[stats]{ts}} for testing
#' @param smps chr string indicating sampling type for generating missing data, see details
#' @param methods chr string of imputation methods to use, one to many.  A user-supplied function can be included if \code{MethodPath} is used.
#' @param methodPath chr string of location of script containing one or more functions for the proposed imputation method(s)
#' @param blck numeric indicating block sizes as a percentage of the sample size for the missing data, applies only if \code{smps = 'mar'}
#' @param blckper logical indicating if the value passed to \code{blck} is a percentage of the sample size for missing data, otherwise \code{blck} indicates number of observations
#' @param missPercent numeric for percent of missing values to be considered
#' @param showmiss logical if removed values missing from the complete dataset are plotted
#' @param addl_arg arguments passed to other imputation methods as a list of lists, see details.
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing the imputed data for each method.  Red points are labelled as 'imputed' and blue points are labelled as 'retained' from the original data set.  Missing data that were removed can be added to the plot as open circles if \code{showmiss = TRUE}.
#'
#' @import ggplot2
#' @import zoo
#'
#' @details See the documentation for \code{\link{impute_errors}} for an explanation of the arguments.
#'
#' @export
#'
#' @examples
#' # default
#' plot_impute(dataIn = nottem)
#'
#' # change missing percent total
#' plot_impute(dataIn = nottem, missPercent = 10)
#'
#' # show missing values
#' plot_impute(dataIn = nottem, showmiss = TRUE)
#'
#' # use mar sampling
#' plot_impute(dataIn = nottem, smps = 'mar')
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
  toplo$Filled <- 'Retained'
  toplo$Filled[is.na(out[[1]])] <- 'Imputed'
  toplo$Filled <- factor(toplo$Filled)
  toplo$Actual <- dataIn
  toplo$Actual[toplo$Filled %in% 'Retained'] <- NA
  toplo$Time <- 1:nrow(toplo)
  toplo <- tidyr::gather(toplo, 'Method', 'Value', -Time, -Filled, -Actual)

  # plot
  p <- ggplot(toplo, aes(x = Time, y = Value)) +
    geom_point(aes(colour = Filled), alpha = 0.75, na.rm = TRUE) +
    facet_wrap(~Method, ncol = 1) +
    theme_bw() +
    theme(
      legend.position = 'top',
      legend.key = element_blank(),
      legend.title = element_blank()
      )

  # add actual missing values if T
  if(showmiss)
    p <- p +
      geom_point(aes(y = Actual, pch = 'Removed'), fill = NA, alpha = 0.75, na.rm = TRUE) +
      scale_shape_manual(values = 21)

  return(p)

}
