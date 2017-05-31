
## imputeTestbench

#### *Neeraj Bokde, neerajdhanraj@gmail.com, Marcus W. Beck, beck.marcus@epa.gov*

[![Travis-CI Build Status](https://travis-ci.org/fawda123/imputeTestbench.svg?branch=master)](https://travis-ci.org/fawda123/imputeTestbench)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/fawda123/imputeTestbench?branch=master&svg=true)](https://ci.appveyor.com/project/fawda123/imputeTestbench)

[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/grand-total/imputeTestbench)](https://CRAN.R-project.org/package=imputeTestbench)



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
## [1] 0.901363 1.482835 1.958872 2.561620 3.469172 4.475716 6.442243 8.398182
## [9] 9.978482
## 
## $na.interp
## [1] 0.8001211 1.2240711 1.4138565 1.6581240 1.9295977 2.0984056 2.2763186
## [8] 2.5622631 3.4401437
## 
## $na.interpolation
## [1]  0.9089811  1.5266646  2.0002243  2.6406035  3.4855723  4.6469917
## [7]  6.5879328  8.4999919 10.1895907
## 
## $na.locf
## [1]  1.821598  2.800376  3.981163  4.881498  6.313571  8.063412  8.970904
## [8] 10.464801 11.432153
## 
## $na.mean
## [1] 2.654795 3.788465 4.684407 5.436173 5.943522 6.615894 7.252700 7.840248
## [9] 8.306318
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
