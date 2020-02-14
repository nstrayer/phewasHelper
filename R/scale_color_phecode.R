#' Phecode color scale for ggplot2
#'
#' @return ggplot2 color scale using `category_colors()` colors for each category.
#' @export
#'
#' @examples
#'
#' library(dplyr)
#' library(ggplot2)
#'
#' sample_n(phecode_descriptions, 300) %>%
#'   left_join(category_colors(return_df = TRUE) %>%
#'               mutate(bias = rnorm(n(), sd = 3)),
#'             by = 'category') %>%
#'   mutate(val = rnorm(n(), mean = bias)) %>%
#'   ggplot(aes(x = phecode, y = val, color = category)) +
#'   geom_point() +
#'   scale_color_phecode() +
#'   theme(axis.ticks.x = element_blank(),
#'         axis.text.x = element_blank(),
#'         panel.grid.major.x = element_blank(),
#'         panel.grid.minor.x = element_blank())
#'
scale_color_phecode <- function(){

  ggplot2::scale_color_manual(values = category_colors())

}
