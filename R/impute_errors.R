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

impute_errors <- function(dataIn = NULL, smps = 'mcar', blck = 0.5, blckper = TRUE, missPercentFrom = 10, missPercentTo = 90, interval = 10, repetition = 10, errorParameter = 'rmse', MethodPath = NULL, MethodName = 'Proposed Method')
{

  # Sample Dataset 'nottem' is provided for testing in default case.
  if(is.null(dataIn))
    dataIn <- nottem

  dataIn <- as.numeric(unlist(dataIn))

  # check if errorParameter is okay
  if(!errorParameter[1] %in% c('rmse', 'mae', 'mape', 'other'))
    stop('errorParameter must be one of rmse, mae, mape, other')

  # placeholders for error estimates for each method
  f <- 0
  e <- 0
  eall <- NULL
  e1 <- 0
  e1all <- NULL
  enew <- 0
  enewall <- NULL

  # create missing data for each missing percentage
  # take error estimates for each repetition
  for(x in seq(missPercentFrom, missPercentTo, interval)){

    # create the missing data for imputation
    out <- sample_dat(dataIn, smps = smps, b = x/100, blck = blck, blckper = blckper, plot = FALSE)

    gh <- NULL
    gh1 <- NULL
    ghnew <- NULL
    for(i in 1:repetition)
    {
      outs <- as.numeric(unlist(out[i]))

      #d <- impute(outs,mean)
      out1 <- ts(outs)
      d <- na.mean(out1)
      d1 <- na.interpolation(out1)

      if((hasArg(MethodPath)))
      {
        # to call functions from provided "MethodPath"
        dnew <- parse(text = MethodPath)
        dnew <- eval(dnew)
        dnew <- dnew$value(outs)

        if(errorParameter == 'rmse')
        {
          ghnew[i] <- rmse(dataIn - dnew)
          parameter <- "RMSE Plot"
        }
        if(errorParameter == 'mae')
        {
          ghnew[i] <- mae(dataIn - dnew)
          parameter <- "MAE Plot"
        }
        if(errorParameter == 'mape')
        {
          ghnew[i] <- mape((dataIn - dnew), dataIn)
          parameter <- "MAPE Plot"
        }
        if(errorParameter[1] == 'other')
        {
          newPar <- parse(text = errorParameter[2])
          newPar <- eval(newPar)
          newPar <- newPar$value(dataIn, dnew)
          ghnew[i] <- newPar
          parameter <- errorParameter[3]
        }
      }

      if(errorParameter == 'rmse')
      {
        gh[i] <- rmse(dataIn - d)
        gh1[i] <- rmse(dataIn - d1)
        parameter <- "RMSE Plot"
      }
      if(errorParameter == 'mae')
      {
        gh[i] <- mae(dataIn - d)
        gh1[i] <- mae(dataIn - d1)
        parameter <- "MAE Plot"
      }
      if(errorParameter == 'mape')
      {
        gh[i] <- mape((dataIn - d), dataIn)
        gh1[i] <- mape((dataIn - d1), dataIn)
        parameter <- "MAPE Plot"
      }
      if(errorParameter[1] == 4)
      {
        newPar <- parse(text = errorParameter[2])
        newPar <- eval(newPar)
        newPar1 <- newPar$value(dataIn, d)
        gh[i] <- newPar1
        newPar2 <- newPar$value(dataIn, d1)
        gh1[i] <- newPar2
        parameter <- errorParameter[3]
      }
    }

    e <- append(e, mean(gh))
    eall <- c(eall, list(gh))
    f <- append(f, x)
    e1 <- append(e1, mean(gh1))
    e1all <- c(e1all, list(gh1))

    if((hasArg(MethodPath)))
    {
      enew <- append(enew, mean(ghnew))
      enewall <- c(enewall, list(ghnew))
    }

  }

  ##
  # output

  if((hasArg(MethodPath))){

    # output as list
    out <- list(Parameter = parameter, Missing_Percent = f[-1], Historic_Mean = e[-1], Interpolation = e1[-1], Proposed_Method = enew[-1])

    # create errprof object
    out <- structure(
      .Data = out,
      class = c('errprof', 'list'),
      errall = list(Historic_Mean = eall, Interpolation = e1all, Proposed_Method = enewall)
    )

  } else {

    # output as list
    out <- list(Parameter = parameter, Missing_Percent = f[-1], Historic_Mean = e[-1], Interpolation = e1[-1])

    # create errprof object
    out <- structure(
      .Data = out,
      class = c('errprof', 'list'),
      errall = list(Historic_Mean = eall, Interpolation = e1all)
    )

  }

  return(out)

}
