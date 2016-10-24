
## imputeTestbench

#### *Neeraj Bokde, neerajdhanraj@gmail.com, Marcus W. Beck, beck.marcus@epa.gov*

[![Travis-CI Build Status](https://travis-ci.org/fawda123/imputeTestbench.svg?branch=master)](https://travis-ci.org/fawda123/imputeTestbench)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/fawda123/imputeTestbench?branch=master&svg=true)](https://ci.appveyor.com/project/fawda123/imputeTestbench)

[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/grand-total/imputeTestbench)](http://cran.rstudio.com/package=imputeTestbench)



This is the development repository for the imputeTestbench package.  This package provides a testbench for comparing imputation methods for missing data in univariate time series. 

The development version of this package can be installed from Github:


```r
install.packages('devtools')
library(devtools)
install_github('neerajdhanraj/imputeTestbench', ref = 'development')
```

The current release can be installed from CRAN:


```r
install.packages('imputeTestbench')
```

#### Basic use

The core function is `impute_errors()`.  See the help documentation for more details.


```r
library(imputeTestbench)
a <- impute_errors()
a
```

```
## $Parameter
## [1] "rmse"
## 
## $MissingPercent
## [1] 10 20 30 40 50 60 70 80 90
## 
## $na.approx
## [1] 0.9487195 1.3551689 1.8287319 2.8499620 3.6178854 4.6592562 6.4600441
## [8] 8.2361118 9.8981246
## 
## $na.interp
## [1] 0.7679054 1.1328513 1.3713050 1.6197456 1.8502538 2.1180169 2.3079583
## [8] 2.5567402 3.0259601
## 
## $na.interpolation
## [1] 0.9701737 1.4012817 1.8520263 2.8657296 3.6599247 4.7046867 6.5583047
## [8] 8.3618126 9.9443988
## 
## $na.locf
## [1]  1.768138  3.008227  3.733738  5.168307  6.354235  7.696832  9.243164
## [8] 10.419655 11.245193
## 
## $na.mean
## [1] 2.838550 3.868051 4.646613 5.514563 6.083541 6.664628 7.251263 7.673111
## [9] 8.443754
```

```r
plot_errors(a, plotType = 'line')
```

![](README_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

#### Citation

Neeraj Bokde and Marcus W. Beck (2016). imputeTestbench: Test Bench for the comparison of imputation methods. R package version 3.0. http://www.neerajbokde.com/cran/imputetestbench

#### Bug reports 

Please submit any bug reports (or suggestions) using the [issues](https://github.com/neerajdhanraj/imputeTestbench/issues) tab of the GitHub page.

#### License

This package is released in the public domain under the creative commons license CC0.
