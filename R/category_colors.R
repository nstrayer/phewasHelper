#' PheCode category colors
#'
#' Returns a named array of hex colors corresponding to a well-separated color
#' scheme for plotting Phecode Categories.
#'
#' @param return_df Return results as a dataframe with `category`` and `color``
#'   columns? If `FALSE` then named array is returned.
#' @return named array or dataframe of category and color
#' @export
#'
#' @examples
#'
#' category_colors()
#'
#' category_colors(return_df = TRUE)
category_colors <- function(return_df = FALSE){

  categories <- c("neoplasms",               "dermatologic",          "endocrine/metabolic",
                  "mental disorders",        "respiratory",           "circulatory system",
                  "symptoms",                "hematopoietic",         "genitourinary",
                  "infectious diseases",     "sense organs",          "digestive",
                  "pregnancy complications", "injuries & poisonings", "musculoskeletal",
                  "congenital anomalies",    "neurological")

  # Hard coded colors
  colors <- c("#673770", "#C0717C", "#7FDCC0",
              "#38333E", "#AD6F3B", "#D14285",
              "#5E738F", "#8A7C64", "#689030",
              "#DA5724", "#C84248", "#508578",
              "#599861", "#CBD588", "#CE50CA",
              "#D1A33D", "#3F4921")

  if(return_df){
    colors <- dplyr::tibble(
      category = categories,
      color = colors
    )
  } else {
    names(colors) <- categories
  }

  colors
}
