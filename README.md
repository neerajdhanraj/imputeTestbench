
## imputeTestbench

#### *Neeraj Bokde, neerajdhanraj@gmail.com, Marcus W. Beck, beck.marcus@epa.gov*



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
## [1]  0.9314818  1.3907689  2.0607283  2.8861244  3.5637052  4.9158789
## [7]  6.4131929  8.2528277 10.0580649
## 
## $na.interp
## [1] 0.756944 1.099818 1.412798 1.586325 1.835997 2.119822 2.214915 2.533648
## [9] 3.251729
## 
## $na.interpolation
## [1]  0.9771439  1.5100036  2.0772976  2.9099799  3.6141572  5.0736151
## [7]  6.5072629  8.3734161 10.1321833
## 
## $na.locf
## [1]  1.865308  3.006465  3.819017  5.002598  6.276696  7.543415  9.230569
## [8] 10.389976 11.396348
## 
## $na.mean
## [1] 2.738661 3.783800 4.784753 5.517070 5.996845 6.664098 7.240930 7.822131
## [9] 8.265659
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
