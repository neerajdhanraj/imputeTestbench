## ------------------------------------------------------------------------
datax <- c(1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5,1:5)

## ------------------------------------------------------------------------
library(imputeTestbench)

## ---- fig.height= 5, fig.width= 7.5--------------------------------------
q <- impute_errors(datax)
q
# By default, the bar plot is used to show the comparison
plot_errors(q)
# Also, User can plot the comparison with line plot as:
plot_errors(dataIn = q, plotType = 2)

## ------------------------------------------------------------------------
#aa <- append_method(existing_method = q,dataIn= datax,missPercentFrom = 10, missPercentTo = 80, interval = 10, MethodPath = "source('~/imputeTestbench/R/inter.R')", MethodName = "Random")

#aa
#plot_errors(aa)

## ------------------------------------------------------------------------
#bb <- append_method(existing_method = aa, dataIn= datax,missPercentFrom = 10, missPercentTo = 80, interval = 10, MethodPath = "source('~/imputeTestbench/R/PSFimpute.R')", MethodName = "PSFimpute")

#bb
#plot_errors(bb)

## ------------------------------------------------------------------------
#cc <- remove_method(existing_method = bb, method_number = 1)
#cc
#plot_errors(cc)

## ------------------------------------------------------------------------
dd <- impute_errors(random = 0, startPoint = c(10, 20, 30), patchLength = c(3, 4, 5))
dd

