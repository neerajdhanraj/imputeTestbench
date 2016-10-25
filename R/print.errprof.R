#' Print method for errprof
#'
#' Print method for errprof class
#'
#' @param x input errprof object
#' @param ... arguments passed to or from other methods
#'
#' @export
#'
#' @return list output for the errprof object
#'
#' @method print errprof
print.errprof <- function(x, ...){

  nms <- names(x)
  attributes(x) <- NULL
  names(x) <- nms
  print(x)

}
