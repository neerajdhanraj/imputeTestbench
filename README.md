
## imputeTestbench

#### *Neeraj Bokde, neerajdhanraj@gmail.com, Marcus W. Beck, beck.marcus@epa.gov*

[![Travis-CI Build Status](https://travis-ci.org/fawda123/imputeTestbench.svg?branch=master)](https://travis-ci.org/fawda123/imputeTestbench)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/fawda123/imputeTestbench?branch=master&svg=true)](https://ci.appveyor.com/project/fawda123/imputeTestbench)

[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/grand-total/imputeTestbench)](https://CRAN.R-project.org/package=pkgname)



This is the development repository for the imputeTestbench package.  This package provides a testbench for comparing imputation methods for missing data in univariate time series. 

The development version of this package can be installed from GitHub:


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
a <- impute_errors(data = nottem)
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
## [1] 0.8804981 1.4573228 1.8954284 2.7820839 3.7419015 4.8470468 6.7241222
## [8] 8.1860716 9.8007152
## 
## $na.interp
## [1] 0.7588867 1.1022012 1.4251466 1.5929429 1.8101345 2.0824277 2.3012204
## [8] 2.6340942 3.1302777
## 
## $na.interpolation
## [1] 0.9125865 1.4687927 1.9096735 2.8467569 3.8264397 4.9972156 6.7555194
## [8] 8.3039206 9.9086338
## 
## $na.locf
## [1]  1.798383  2.762896  3.821827  4.697825  6.216114  7.394276  9.095603
## [8] 10.155524 11.809507
## 
## $na.mean
## [1] 2.697090 3.928079 4.651401 5.384437 6.115109 6.766826 7.265182 7.804455
## [9] 8.328458
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
