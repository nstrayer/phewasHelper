#' Join data with phecode information
#'
#' Takes a dataframe with a phecode column in it and adds three new columns
#' about the phecode to it: `description`, `category`, and `category_number`.
#'
#' @param data_w_phecode Dataframe with a phecode column.
#' @param phecode_column Name of column that contains phecodes
#'
#' @return input dataframe with three columns added to it.
#' @export
#'
#' @examples
#'
#' library(dplyr)
#'
#' data_w_phecode <- sample_n(phecode_descriptions, 100) %>%
#'   select(phecode) %>%
#'   mutate(random = rnorm(n()))
#'
#' # Default values
#' data_w_phecode %>%
#'   join_phecode_info()
#'
#' # Can change name of phecode column
#' data_w_phecode %>%
#'   rename(jd_code = phecode) %>%
#'   join_phecode_info('jd_code')
#'
join_phecode_info <- function(data_w_phecode, phecode_column = 'phecode'){

  phecode_col_missing <- !(phecode_column %in% colnames(data_w_phecode))

  if(phecode_col_missing){
    stop("Missing phecode column in data. Make sure phecode_column argument is correct.")
  }

  has_any_appended_cols <- c('description', 'category', 'category_number') %in% colnames(data_w_phecode)
  if(any(has_any_appended_cols)){
    warning("Existing info columns in input. Joined info columns will be suffixed with '_info'.")
  }

  dplyr::left_join(dplyr::rename(data_w_phecode,
                                 phecode = !!rlang::sym(phecode_column)),
                   phecode_descriptions,
                   suffix = c("", "_info"),
                   by = 'phecode')
}
