#' Not In
#'
#' This is the opposite of in
#'
#' It does the opposite of what \code{in} does.
#' @param x a value
#' @param table a vector or table of values
#' @export
#' @import purrr
#' @examples
#' x <- 1
#' y <- c(2,3,4)
#' x %not in% y
#' @return
#' This function true if x is not in y
#' @author Matt Simmons mattsimmons@email.com
#'
#'

`%not in%` <- purrr:::negate(`%in%`)
