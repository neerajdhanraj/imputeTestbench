#' Function to plot the Error Comparison
#'
#' @param dataIn an errprof object returned from \code{\link{impute_errors}}
#' @param plotType chr string indicating plot type, accepted values are \code{"boxplot"} or \code{"bar"}
#' @param \dots arguments passed to or from other methods
#'
#' @return A ggplot object that can be further modified.  The entire range of errors are shown if \code{plotType = "boxplot"}, otherwise the averages are shown if \code{plotType = "bar"}.
#'
#' @importFrom  reshape2 melt
#' @import ggplot2
#'
#' @export
#'
#' @examples
#' aa <- impute_errors()
#' plot_errors(aa)
#' plot_errors(aa, plotType = 'bar')
plot_errors <- function(dataIn, ...) UseMethod('plot_errors')

#' @rdname plot_errors
#'
#' @export
#'
#' @method plot_errors errprof
plot_errors.errprof <- function(dataIn, plotType = c('boxplot'), ...){

  if(!plotType %in% c('boxplot', 'bar'))
    stop('plotType must be boxplot or bar')

  if(plotType == 'boxplot'){

    toplo <- attr(dataIn, 'errall')
    toplo <- melt(toplo)
    percs <- dataIn$Missing_Percent
    toplo$L2 <- factor(toplo$L2, levels = unique(toplo$L2), labels = percs)
    names(toplo) <- c('Error value', 'Percent of missing values', 'Methods')

    p <- ggplot(toplo, aes(x = `Percent of missing values`, y = `Error value`)) +
      ggtitle(dataIn$Parameter) +
      geom_boxplot(aes(fill = Methods)) +
      theme_bw()

  }

  if(plotType == 'bar'){

    toplo <- data.frame(dataIn[-1])
    toplo <- melt(toplo, id.var = 'Missing_Percent')
    toplo$Missing_Percent <- factor(toplo$Missing_Percent)
    names(toplo) <- c('Percent of missing values', 'Methods', 'Error value')

    p <- ggplot(toplo, aes(x = `Percent of missing values`, y = `Error value`)) +
      ggtitle(dataIn$Parameter) +
      geom_bar(aes(fill = Methods), stat = 'identity', position = 'dodge') +
      theme_bw()

  }

  return(p)

}
