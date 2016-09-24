#' Function working as testbench for comparison of imputing models
#'
#' @param  dataIn as input data for testing
#' @param  missPercentFrom as variable from which percent of missing values to be considered
#' @param  missPercentTo as variable to state upto what percent missing values are to be considered
#' @param  interval as interval between consecutive missPercent values
#' @param  repetition as an integer to decide the numbers of repetition to be done for each missPercent value
#' @param  errorParameter as type of error calculation (RMSE, MAE or MAPE)
#' @param  MethodPath as location of function for the proposed imputation method
#' @param  MethodName as name for function for the proposed imputation method
#' @param  random as parameter to decide missing value scheme
#' @param  startPoint as index of missing patches in dataset when 'random = 0'
#' @param  patchLength as length of missing patches in dataset when 'random = 0'
#' @import ggplot2
#' @import imputeTS
#' @importFrom stats ts
#' @importFrom methods hasArg
#' @return Returns error comparison for imputation methods
#' @export
#' @examples
#' aa <- impute_errors()
#' aa
#'
#' bb <- impute_errors(random = 0, startPoint = c(10, 20, 40), patchLength = c(3, 4, 5))
#' bb
#'\dontrun{
#' cc <- impute_errors()
#' cc
#'
#' dd <- impute_errors(random = 0, startPoint = c(1,10,30,0,3,50,70,90), patchLength = c(1,5,5,0,3,10,10,10))
#' dd
#' }


#==================================================================================
# impute_error starts here....
#==================================================================================

impute_errors <- function(dataIn, missPercentFrom, missPercentTo, interval, repetition, errorParameter, MethodPath, MethodName, random, startPoint, patchLength)
{

  #==========================================================================
  #==========================================================================
                              # Univariate Dataset #
  #==========================================================================
  #==========================================================================

  # Sample Dataset 'nottem' is provided for testing in default case.
  if(!(hasArg(dataIn)))
  {
    # dataIn <- c(1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5)
    dataIn <- nottem
  }
  dataIn <- as.numeric(unlist(dataIn))

  # For future reference
  dataIn1 <- dataIn

  # Set default values
  if(!(hasArg(errorParameter)))
  {
    errorParameter <- 1     # RMSE (default)
  }
  if(!(hasArg(repetition)))
  {
    repetition <- 5         # Repetition = 5 (default)
  }
  if(!(hasArg(MethodName)))
  {
    MethodName <- "Proposed Method"
  }
  if(!(hasArg(interval)))
  {
    interval <- 10
  }
  if(!(hasArg(missPercentFrom)))
  {
    missPercentFrom <- 10
  }
  if(!(hasArg(missPercentTo)))
  {
    missPercentTo <- 80
  }
  if(!(hasArg(random)))
  {
    random <- 1           # Random placement of Missiong values (default)
  }
  if(!(hasArg(startPoint)))
  {
    startPoint <- NULL
  }
  if(!(hasArg(patchLength)))
  {
    patchLength <- NULL
  }

  e <- 0
  eall <- NULL
  f <- 0
  e1 <- 0
  e1all <- NULL
  f1 <- 0
  enew <- 0
  enewall <- NULL
  fnew <- 0

#=======================================
# random = 1
#=======================================
  if (random == 1)
  {
    # Function to create missing values at
    for(x in seq(missPercentFrom, missPercentTo, interval))
    {
      x <- x/100
      a <- length(dataIn)
      b <- a * x
      b <- round(b)
      out <- NULL

      for(i in 1:repetition)
      {
        dataIn <- dataIn1
        c <- sample(1:length(dataIn), b, replace = F)
        dataIn[c] <- NA
        out[i] <- data.frame(dataIn)
      }

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

          if(errorParameter == 1)
          {
            ghnew[i] <- rmse(dataIn1 - dnew)
            parameter <- "RMSE Plot"
          }
          if(errorParameter == 2)
          {
            ghnew[i] <- mae(dataIn1 - dnew)
            parameter <- "MAE Plot"
          }
          if(errorParameter == 3)
          {
            ghnew[i] <- mape((dataIn1 - dnew), dataIn1)
            parameter <- "MAPE Plot"
          }
          if(errorParameter[1] == 4)
          {
            newPar <- parse(text = errorParameter[2])
            newPar <- eval(newPar)
            newPar <- newPar$value(dataIn1, dnew)
            ghnew[i] <- newPar
            parameter <- errorParameter[3]
          }
        }


        if(errorParameter == 1)
        {
          gh[i] <- rmse(dataIn1 - d)
          gh1[i] <- rmse(dataIn1 - d1)
          parameter <- "RMSE Plot"
        }
        if(errorParameter == 2)
        {
          gh[i] <- mae(dataIn1 - d)
          gh1[i] <- mae(dataIn1 - d1)
          parameter <- "MAE Plot"
        }
        if(errorParameter == 3)
        {
          gh[i] <- mape((dataIn1 - d), dataIn1)
          gh1[i] <- mape((dataIn1 - d1), dataIn1)
          parameter <- "MAPE Plot"
        }
        if(errorParameter[1] == 4)
        {
          newPar <- parse(text = errorParameter[2])
          newPar <- eval(newPar)
          newPar1 <- newPar$value(dataIn1, d)
          gh[i] <- newPar1
          newPar2 <- newPar$value(dataIn1, d1)
          gh1[i] <- newPar2
          parameter <- errorParameter[3]
        }
      }

      e <- append(e,mean(gh))
      eall <- c(eall, list(gh))
      f <- append(f,x)
      e1 <- append(e1,mean(gh1))
      e1all <- c(e1all, list(gh1))
      f1 <- append(f1,x)

      if((hasArg(MethodPath)))
      {
        enew <- append(enew,mean(ghnew))
        enewall <- c(enewall, list(ghnew))
        fnew <- append(fnew,x)
      }
    }
    if((hasArg(MethodPath)))
    {

      # output as list
      out <- list(Parameter = parameter, Missing_Percent = f[-1], Historic_Mean = e[-1], Interpolation = e1[-1], Proposed_Method = enew[-1])

      # create errprof object
      out <- structure(
        .Data = out,
        class = c('errprof', 'list'),
        errall = list(Historic_Mean = eall, Interpolation = e1all, Proposed_Method = enewall)
      )
      return(out)

    }
    else{

      # output as list
      out <- list(Parameter = parameter, Missing_Percent = f[-1], Historic_Mean = e[-1], Interpolation = e1[-1])

      # create errprof object
      out <- structure(
        .Data = out,
        class = c('errprof', 'list'),
        errall = list(Historic_Mean = eall, Interpolation = e1all)
      )
      return(out)

    }

  }

#============================================
# random = 0
#============================================
    # startPoint = c(5,15,20)
    # patchLength = c(5,6,7)
    if (random == 0)
    {
      if(length(startPoint) != length(patchLength))
      {
        stop("Enter valid values for Parameters 'startPoint' and 'patchLength'. Lengths of these parameters should be equal.")
      }
      gh <- NULL
      gh1 <- NULL
      ghnew <- NULL
      outs <- dataIn
      for(i in 1:length(startPoint))
      {
        outs[startPoint[i]:(startPoint[i] + patchLength[i])] <- NA
      }

      #d <- impute(outs,mean)
      out <- ts(outs)
      d <- na.mean(out)
      d1 <- na.interpolation(out)

      if((hasArg(MethodPath)))
      {
        # to call functions from provided "MethodPath"
        dnew <- parse(text = MethodPath)
        dnew <- eval(dnew)
        dnew <- dnew$value(outs)

        if(errorParameter == 1)
        {
          ghnew[i] <- rmse(dataIn1 - dnew)
          parameter <- "RMSE Plot"
        }
        if(errorParameter == 2)
        {
          ghnew[i] <- mae(dataIn1 - dnew)
          parameter <- "MAE Plot"
        }
        if(errorParameter == 3)
        {
          ghnew[i] <- mape((dataIn1 - dnew), dataIn1)
          parameter <- "MAPE Plot"
        }
        if(errorParameter[1] == 4)
        {
          newPar <- parse(text = errorParameter[2])
          newPar <- eval(newPar)
          newPar <- newPar$value(dataIn1, dnew)
          ghnew[i] <- newPar
          parameter <- errorParameter[3]
        }
      }


      if(errorParameter == 1)
      {
        gh[i] <- rmse(dataIn1 - d)
        gh1[i] <- rmse(dataIn1 - d1)
        parameter <- "RMSE Plot"
      }
      if(errorParameter == 2)
      {
        gh[i] <- mae(dataIn1 - d)
        gh1[i] <- mae(dataIn1 - d1)
        parameter <- "MAE Plot"
      }
      if(errorParameter == 3)
      {
        gh[i] <- mape((dataIn1 - d), dataIn1)
        gh1[i] <- mape((dataIn1 - d1), dataIn1)
        parameter <- "MAPE Plot"
      }
      if(errorParameter[1] == 4)
      {
        newPar <- parse(text = errorParameter[2])
        newPar <- eval(newPar)
        newPar1 <- newPar$value(dataIn1, d)
        gh[i] <- newPar1
        newPar2 <- newPar$value(dataIn1, d1)
        gh1[i] <- newPar2
        parameter <- errorParameter[3]
      }

      e <- gh
      e1 <- gh1

      # startPoint' and 'patchLength
      missL <- 0
      for(i in 1:length(patchLength))
      {
        missL <- missL + patchLength[i]
      }
      f <- missL/length(dataIn)

      #x <- x + 10
      if((hasArg(MethodPath)))
      {
        enew <- append(enew,mean(ghnew))
        fnew <- append(fnew,x)
      }

      options(warn=-1)

      if((hasArg(MethodPath)))
      {

        # output as list
        out <- list(Parameter = parameter, Missing_Percent = f, Historic_Mean = as.numeric(na.omit(e)), Interpolation = as.numeric(na.omit(e1)), Proposed_Method = as.numeric(na.omit(enew)))

        # create errprof object
        out <- structure(
          .Data = out,
          class = c('errprof', 'list'),
          errall = list(Historic_Mean = as.numeric(na.omit(e)), Interpolation = as.numeric(na.omit(e1)), Proposed_Method = as.numeric(na.omit(enew)))
        )

        return(out)

      }
      else{

        # output as list
        out <- list(Parameter = parameter, Missing_Percent = f, Historic_Mean = as.numeric(na.omit(e)), Interpolation = as.numeric(na.omit(e1)))

        # create errprof object
        out <- structure(
          .Data = out,
          class = c('errprof', 'list'),
          errall = list(Historic_Mean = as.numeric(na.omit(e)), Interpolation = as.numeric(na.omit(e1)))
        )

        return(out)

      }
    }


}
