
## imputeTestbench

#### *Neeraj Bokde, neerajdhanraj@gmail.com, Marcus W. Beck, beck.marcus@epa.gov*

[![Travis-CI Build Status](https://travis-ci.org/fawda123/imputeTestbench.svg?branch=master)](https://travis-ci.org/fawda123/imputeTestbench)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/fawda123/imputeTestbench?branch=master&svg=true)](https://ci.appveyor.com/project/fawda123/imputeTestbench)

[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/grand-total/imputeTestbench)](https://cran.r-project.org/web/packages/imputeTestbench/index.html)



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
## [1]  0.8758017  1.3884222  2.0637862  2.7264405  3.5484296  5.2247580
## [7]  6.6919063  8.5251748 10.2467772
## 
## $na.interp
## [1] 0.7829411 1.1349737 1.4107251 1.6532467 1.8382651 2.0613671 2.2514525
## [8] 2.5821119 3.1625840
## 
## $na.interpolation
## [1]  0.9264386  1.4037472  2.0772274  2.9411888  3.5745095  5.2742354
## [7]  6.8345494  8.6221304 10.3547366
## 
## $na.locf
## [1]  1.678392  2.711533  3.756034  4.781117  6.367100  7.958009  9.274554
## [8] 10.077474 11.891015
## 
## $na.mean
## [1] 2.755701 3.807212 4.694296 5.493993 6.073467 6.710091 7.168344 7.770900
## [9] 8.331260
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
