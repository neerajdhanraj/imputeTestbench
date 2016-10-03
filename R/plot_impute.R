#' Plot imputations
#'
#' Plot imputations for data from multiple methods
#'
#' @param dataIn input \code{\link[stats]{ts}} for testing, defaults to \code{\link[datasets]{nottem}}
#' @param smps chr string indicating sampling type for generating missing data, see details
#' @param methods chr string of imputation methods to use, one to many.  A user-supplied function can be included if \code{MethodPath} is used.
#' @param methodPath chr string of location of function for the proposed imputation method
#' @param blck numeric indicating block sizes as a percentage of the sample size for the missing data, applies only if \code{smps = 'mcar'}
#' @param blckper logical indicating if the value passed to \code{blck} is a percentage of the sample size for missing data, otherwise \code{blck} indicates number of observations
#' @param missPercent numeric for percent of missing values to be considered
#' @param showmiss logical if actual missing values are plotted
#' @param ... arguments passed to other imputation methods
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing the imputed data for each method.
#'
#' @import ggplot2
#'
#' @details See the documentation for \code{\link{impute_errors}} for an explanation of the arguments.
#'
#' @export
#'
#' @examples
#' plot_impute()
plot_impute <- function(dataIn = NULL, smps = 'mcar', methods = c("na.mean", "na.interpolation"),  methodPath = NULL, blck = 50, blckper = TRUE, missPercent = 10, showmiss = FALSE, ...){

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

  # create master list for output
  imps <- vector('list', length = length(methods))
  names(imps) <- methods

  # create the missing data for imputation
  b <- missPercent
  out <- sample_dat(dataIn, smps = smps, b = b, repetition = 1,
    blck = blck, blckper = blckper, plot = FALSE)

  # go through each imputation method
  for(method in methods){

    # get predictions
    toeval <- paste0(method, '(out[[1]], ...)')
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
  toplo$ind <- 1:nrow(toplo)
  toplo <- tidyr::gather(toplo, 'Method', 'Estimate', -ind, -Filled, -Actual)

  # plot
  p <- ggplot(toplo, aes(x = ind, y = Estimate)) +
    geom_point(aes(colour = Filled)) +
    facet_wrap(~Method, ncol = 1) +
    theme_bw() +
    theme(
      axis.title.x = element_blank(),
      legend.position = 'top'
      )

  # add actual missing values if T
  if(showmiss)
    p <- p +
      geom_point(aes(y = Actual), pch = 21, fill = NA) +
      geom_point(aes(colour = Filled))

  return(p)

}
