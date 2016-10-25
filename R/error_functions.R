#' Root Mean Square Error Calculation
#'
#' takes difference between Original data and Predicted data as input
#' @param obs numeric vector of original data
#' @param pred numeric vector of predicted data
#' @return rmseVal as Root Mean Square Error
#' @export
#' @examples
#' ## Generate 100 random numbers within some limits
#' x <- sample(1:7, 100, replace = TRUE)
#' y <- sample(1:4, 100, replace = TRUE)
#' z <- rmse(x, y)
#' z
### RSME/MAE errors ============================================================================
# Function that returns Root Mean Squared Error
rmse <- function(obs, pred)
{
  rmseVal <- sqrt(mean((obs - pred)^2, na.rm = T))
  return(rmseVal)
}


#' Mean Absolute Error Calculation
#'
#' takes difference between Original data and Predicted data as input
#' @param obs numeric vector of original data
#' @param pred numeric vector of predicted data
#' @return maeVal as Mean Absolute Error
#' @export
#' @examples
#' ## Generate 100 random numbers within some limits
#' x <- sample(1:7, 100, replace = TRUE)
#' y <- sample(1:4, 100, replace = TRUE)
#' z <- mae(x, y)
#' z
# Function that returns Mean Absolute Error
mae <- function(obs, pred)
{
  maeVal <- mean(abs(obs - pred), na.rm = TRUE)
  return(maeVal)
}


#' Mean Absolute Percent Error Calculation
#'
#' takes difference between Original data and Predicted data as input
#' @param obs numeric vector of original data
#' @param pred numeric vector of predicted data
#' @return mapeVal as Mean Absolute Error
#' @export
#' @examples
#' ## Generate 100 random numbers within some limits
#' x <- sample(1:7, 100, replace = TRUE)
#' y <- sample(1:4, 100, replace = TRUE)
#' z <- mape(x, y)
#' z
# Function that returns Mean Absolute Error
mape <- function(obs, pred)
{
  mapeVal <- mean(abs(obs - pred)* 100/obs, na.rm = TRUE)
  return(mapeVal)
}

#==============================================================================================
