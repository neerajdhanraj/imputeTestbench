#' Function to plot the Error Comparison
#'
#' @param dataIn an errprof object returned from \code{\link{impute_errors}}
#' @param plotType chr string indicating plot type, accepted values are \code{"boxplot"}, \code{"bar"}, or \code{"line"}
#'
#' @return A ggplot object that can be further modified.  The entire range of errors are shown if \code{plotType = "boxplot"}, otherwise the averages are shown if \code{plotType = "bar"} or \code{"line"}.
#'
#' @importFrom  reshape2 melt
#' @import ggplot2
#'
#' @export
#'
#' @examples
#' aa <- impute_errors(dataIn = nottem)
#'
#' # default plot
#' plot_errors(aa)
#' \dontrun{
#' # bar plot of averages at each repetition
#' plot_errors(aa, plotType = 'bar')
#'
#' # line plot of averages at each repetition
#' plot_errors(aa, plotType = 'line')
#'
#' # change the plot aesthetics
#'
#' library(ggplot2)
#' p <- plot_errors(aa)
#' p + scale_fill_brewer(palette = 'Paired', guide_legend(title = 'Default'))
#' p + theme(legend.position = 'top')
#' p + theme_minimal()
#' p + ggtitle('Distribution of error for imputed values')
#' p + scale_y_continuous('RMSE')
#' }
plot_errors <- function(dataIn, plotType = c('boxplot')) UseMethod('plot_errors')

#' @rdname plot_errors
#'
#' @export
#'
#' @method plot_errors errprof
plot_errors.errprof <- function(dataIn, plotType = c('boxplot')){
  if(!plotType %in% c('boxplot', 'bar', 'line'))
    stop('plotType must be boxplot, bar, or line')

  # boxplot
  if(plotType == 'boxplot'){

    toplo <- attr(dataIn, 'errall')
    toplo <- melt(toplo)
    percs <- dataIn$MissingPercent
    toplo$L2 <- factor(toplo$L2, levels = unique(toplo$L2), labels = percs)
    names(toplo) <- c('Error value', 'Percent of missing observations', 'Methods')

    p <- ggplot(toplo, aes(x = `Percent of missing observations`, y = `Error value`)) +
      ggtitle(dataIn$Parameter) +
      geom_boxplot(aes(fill = Methods)) +
      theme_bw()

    return(p)

  }

  # data for line or bar
  toplo <- data.frame(dataIn[-1])
  toplo <- melt(toplo, id.var = 'MissingPercent')
  toplo$MissingPercent <- factor(toplo$MissingPercent)
  names(toplo) <- c('Percent of missing observations', 'Methods', 'Error value')

  # barplot
  if(plotType == 'bar'){

    p <- ggplot(toplo, aes(x = `Percent of missing observations`, y = `Error value`)) +
      ggtitle(dataIn$Parameter) +
      geom_bar(aes(fill = Methods), stat = 'identity', position = 'dodge') +
      theme_bw()

    return(p)

  }

  # line plot
  if(plotType == 'line'){

    p <- ggplot(toplo, aes(x = `Percent of missing observations`, y = `Error value`, group = Methods)) +
      ggtitle(dataIn$Parameter) +
      geom_line() +
      geom_point(aes(fill = Methods), shape = 21, size = 5, alpha = 0.75) +
      theme_bw()

    return(p)

  }

}
