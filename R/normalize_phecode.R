#' Normalize a phecode vector to padded character
#'
#' Depending on if a phecode was ever converted to a number or not it can show
#' up in a million different formats. This standardizes everything to a 6 digits
#' number.
#'
#'
#' @param codes A vector of phecodes in whatever format your heart desires. E.g.
#'   `8.00`, `8`, `0008.0`, ...
#'
#' @return A vector of 0-padded phecodes.
#' @export
#'
#' @examples
#' normalize_phecode(c(8, 8.1, 9.2))
normalize_phecode <- function(codes){

  stringr::str_pad(
    sprintf('%3.2f', as.numeric(codes)),
    width = 6,
    side = "left",
    pad = "0"
  )

}
