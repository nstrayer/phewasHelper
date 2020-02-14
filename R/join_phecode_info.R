#' Join data with phecode information
#'
#' Takes a dataframe with a phecode column in it and desired new phecode
#' information columns to it: `description`, `category`, `category_number`, and
#' `phecode_index` (the relative position in ordered phenome of phecode).
#'
#' @param data_w_phecode Dataframe with a phecode column.
#' @param phecode_column Name of column that contains phecodes
#' @param cols_to_join Which columns of phecode info do you want appended to
#'   dataframe?
#'
#' @return input dataframe with three columns added to it.
#'
#' @seealso get_phecode_info
#'
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
#' # Can choose which columns are added
#' data_w_phecode %>%
#'   join_phecode_info(cols_to_join = c("description", "phecode_index"))
#'
join_phecode_info <- function(data_w_phecode,
                              phecode_column = 'phecode',
                              cols_to_join = c("description", "category", "category_number", "phecode_index")){

  phecode_col_missing <- !(phecode_column %in% colnames(data_w_phecode))

  if(phecode_col_missing){
    stop("Missing phecode column in data. Make sure phecode_column argument is correct.")
  }

  has_any_appended_cols <- cols_to_join %in% colnames(data_w_phecode)
  if(any(has_any_appended_cols)){
    warning("Existing info columns in input. Joined info columns will be suffixed with '_info'.")
  }


  dplyr::left_join(dplyr::rename(data_w_phecode, phecode = !!rlang::sym(phecode_column)),
                   dplyr::select(phecode_descriptions, phecode, one_of(cols_to_join)),
                   suffix = c("", "_info"),
                   by = 'phecode')
}
