#' Phewas friendly theming for ggplot2
#'
#' Turns off the plots attempt to write out each individual phecode name and
#' ticks so plot renders faster and cleaner.
#'
#' @return
#' @export
#'
#' @examples
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
#'   theme_phewas()
#'
theme_phewas <- function(){

  ggplot2::theme(axis.ticks.x = ggplot2::element_blank(),
                 axis.text.x = ggplot2::element_blank(),
                 panel.grid.major.x = ggplot2::element_blank(),
                 panel.grid.minor.x = ggplot2::element_blank())
}
