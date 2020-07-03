#' Onehot
#'
#' Returns 1 if condition is met, else zero
#'
#' It does the opposite of what is.na
#' @param condition A condition, expressed as var {something} value
#' @param treat_na_as a value to turn NA values into - zeros, 1s or NA
#' @export
#' @import dplyr
#' @examples
#' df <- data.frame(x = 1:100)
#' df %>% dplyr::mutate(greater_50_flag = onehot(x > 50))
#' @return
#' This function returns if x is not na
#' @author Matt Simmons mattsimmons@email.com
#'

onehot <- function(condition, treat_na_as = c(NA, 1, 0)) {
  treat_na_as <- match.arg(treat_na_as, c(NA, 1, 0))
  out <- dplyr::if_else({condition}, 1, 0)
  out <- dplyr::if_else(is.na(out), treat_na_as, out)
  return(out)
}

