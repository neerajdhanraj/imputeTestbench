#' Function to plot the Error Comparison
#'
#' @param  dataIn as input data in list format (returned by function inpute_errors())
#' @param  \dots as additive functions for plot
#' @param  plotType as parameter to decide Plot Type to achieve: 1: Barplot, 2: Line plot
#' @return It returns the Error comparison for different methods
#' @importFrom  reshape2 melt
#' @importFrom graphics barplot
#' @export
#' @examples
#' # aa <- impute_errors()
#' # bb <- plot_errors(aa)
#' # bb
#'
#' # cc <- impute_errors()
#' # dd <- plot_errors(dataIn = cc, plotType = 1, main = "Bar plot",
#' #         args.legend = list(x="topleft", bg = "NA"))
#'
#' # cc <- impute_errors()
#' # dd <- plot_errors(dataIn = cc, plotType = 2)

plot_errors <- function(dataIn, plotType, ...)
{
  if(!(hasArg(plotType)))
  {
    plotType <- 1
  }
  if(plotType == 2)
  {
    #melt <- NULL
    Percent_of_Missing_Values <- NULL
    Error_Values <- NULL
    Methods <- NULL

    qq1 <-  as.character(dataIn[[1]])
    qq <- data.frame(dataIn[-1])
    #qq1 <- dataIn$Parameter

    melted <- melt(qq, id.vars = "Missing_Percent")
    colnames(melted) <- c("Percent_of_Missing_Values", "Methods", "Error_Values")
    d <- ggplot(data=melted, aes(x=Percent_of_Missing_Values, y=Error_Values, group=Methods, color=Methods)) + labs(title = qq1) + geom_line()
  }

  if(plotType == 1)
  {
    q1 <-  as.character(dataIn[[1]])
    q <- data.frame(dataIn)
    q2 <- q[-1]
    hd <- q2[1]
    head <- as.numeric(unlist(hd))
    q3 <- q2[-1]
    meth <- names(q3)
    q4 <- t(q3)
    q5 <- data.frame(q4)
    names(q5) <- head

    args <- list(...)
    y <- as.matrix(q5)
    if (length(args) == 0)
    {
      d <- barplot(y, main=q1, ylab="Error Value", xlab = "% of Missing Values", beside=TRUE,
                   col= 1:nrow(q5), legend.text = meth, args.legend = list(x="topleft", bg = "NA"))
    }
    else
    {
      d <- barplot(as.matrix(q5), beside=TRUE, legend.text = meth, col= 1:nrow(q5),...)
    }
  }
return(d)
}
