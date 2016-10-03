#' Sample time series data
#'
#' Sample time series using completely at random (MCAR) or at random (MAR)
#'
#' @param datin input numeric vector
#' @param smps chr sring of sampling type to use, options are \code{"mcar"} or \code{"mar"}
#' @param repetition numeric for repetitions to be done for each missPercent value
#' @param b numeric indicating sample size for missing data
#' @param blck numeric indicating block sizes as a proportion of the sample size for the missing data
#' @param blckper logical indicating if the value passed to \code{blck} is a proportion of \code{missper}, i.e., blocks are to be sized as a percentage of the total size of the missing data
#' @param plot logical indicating if a plot is returned showing the sampled data, plots only the first repetition
#'
#' @return Input data with \code{NA} values for the sampled observations if \code{plot = FALSE}, otherwise a plot showing the missing observations over the complete dataset.
#'
#' The missing data if \code{smps = 'mar'} are based on random sampling by blocks.  The start location of each block is random and overlapping blocks are not counted uniquely for the required sample size given by \code{b}.  Final blocks are truncated to ensure the correct value of \code{b} is returned.  Blocks are fixed at 1 if the proportion is too small, in which case \code{"mcar"} should be used.  Block sizes are also truncated to the required sample size if the input value is too large if \code{blckper = FALSE}.  For the latter case, this is the same as setting \code{blck = 1} and \code{blckper = TRUE}.
#'
#' @export
#'
#' @import dplyr
#'
#' @examples
#' a <- rnorm(1000)
#' sample_dat(a)
#' sample_dat(a, smps = 'mar')
#' sample_dat(a, plot = TRUE)
#' sample_dat(a, smps = 'mar', plot = TRUE)
sample_dat <- function(datin, smps = 'mcar', repetition = 10, b = 50, blck = 50, blckper = TRUE, plot = FALSE){

  # sanity checks
  if(!smps %in% c('mcar', 'mar'))
    stop('smps must be mcar or mar')

  # sample to take for missing data given x
  pool <- 1:length(datin)
  torm <- round(length(pool) * b/100)
  out <- vector('list', length = repetition)

  # sampling complately at random
  if(smps == 'mcar'){

    for(i in 1:repetition){

      c <- sample(pool, torm, replace = FALSE)
      datsmp <- datin
      datsmp[c] <- NA
      out[i] <- data.frame(datsmp)

      }

  }

  # sampling at random
  if(smps == 'mar'){

    # block size
    if(blckper){

      if(blck > 100 | blck < 0)
        stop('block must be between 0 - 100 if blckper = T')

      blck <- pmax(1, round(torm * blck/100))

    } else {

      if(blck < 1)
        stop('block must be at least one if blckper = F')

      blck <- pmin(torm, blck)

    }


    # get number of samples for initial grab
    blck_sd <- floor(torm/blck)

    # create samples for each repetition
    for(i in 1:repetition){

      pool <- 1:length(datin)

      # initial grab
      grbs <- sample(pool, blck_sd, replace = F) %>%
        sapply(function(x) x:(x + blck - 1)) %>%
        c %>%
        unique %>%
        .[. <= length(datin)] %>%
        sort

      # adjust sampling pool and number of samples left
      pool <- pool[!pool %in% grbs]
      lft <- torm - length(grbs)

      # continue sampling one block at a time until enough samples in missper
      while(lft > 0){

        # take one sample with block size as minimum between block of samples left
        grbs_tmp <- sample(pool, 1, replace = F) %>%
              .:(. + pmin(lft, blck) - 1)

        # append new sample to initial grab
        grbs <- c(grbs, grbs_tmp) %>%
          unique %>%
          sort %>%
          .[. <= length(datin)]

        # update samples left and sample pool
        lft <- torm - length(grbs)
        pool <- pool[!pool %in% grbs]

      }

    # append for each repetition
    datsmp <- datin
    datsmp[grbs] <- NA
    out[i] <- data.frame(datsmp)

    }

  }

  # outplot for plot, otherwise return sampled data
  if(plot){

    miss <- is.na(out[[1]])
    plot(1:length(datin), datin)
    points(which(miss), datin[miss], col = 'red')


  } else {

    return(out)

  }

}
