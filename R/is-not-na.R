#' Is not NA
#'
#' This is the opposite of is.na
#'
#' It does the opposite of what is.na
#' @param x a value or vector of values
#' @export
#' @import purrr
#' @examples
#' x <- NA
#' y <- is.not.na(x)
#' z <- 1
#' q <- is.not.na(z)
#' @return
#' This function returns if x is not na
#' @author Matt Simmons mattsimmons@email.com
#' @seealso \link[base]{is.na}
#'
#'

is.not.na <- purrr:::negate(is.na)
