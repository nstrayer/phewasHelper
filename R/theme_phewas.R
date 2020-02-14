#' Phewas friendly theming for ggplot2
#'
#' Turns off the plots attempt to write out each individual phecode name and
#' ticks so plot renders faster and cleaner.
#'
#' @param phecode_on_x_axis Is the phecode in the plot on the x axis?
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#'
#' data <- sample_n(phecode_descriptions, 300) %>%
#'   left_join(category_colors(return_df = TRUE) %>%
#'               mutate(bias = rnorm(n(), sd = 3)),
#'             by = 'category') %>%
#'   mutate(val = rnorm(n(), mean = bias))
#'
#' ggplot(data, aes(x = phecode, y = val, color = category)) +
#'   geom_point() +
#'   scale_color_phecode() +
#'   theme_phewas()
#'
#'
#' ggplot(data, aes(y = phecode, x = val, color = category)) +
#'   geom_point() +
#'   scale_color_phecode() +
#'   theme_phewas(phecode_on_x_axis = FALSE)
#'
theme_phewas <- function(phecode_on_x_axis = TRUE){

  if(phecode_on_x_axis){
    t <- ggplot2::theme(axis.ticks.x = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_blank(),
                   panel.grid.major.x = ggplot2::element_blank(),
                   panel.grid.minor.x = ggplot2::element_blank())
  } else {
    t <- ggplot2::theme(axis.ticks.y = ggplot2::element_blank(),
                        axis.text.y = ggplot2::element_blank(),
                        panel.grid.major.y = ggplot2::element_blank(),
                        panel.grid.minor.y = ggplot2::element_blank())
  }

}
