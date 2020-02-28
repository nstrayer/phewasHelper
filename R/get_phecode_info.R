#' Get phecode information
#'
#' Either grabs a vector of descriptions for passed vector of phecodes, or
#' vector of categories, or a dataframe with both.
#'
#' @param codes Vector of phecodes
#' @param what What info should be returned. Options: `'description'`,
#'   `'category'`, `'all'`.
#'
#' @return Vector of `what` is description or category, dataframe with phecode,
#'   description, and category if `what = 'all'`.
#'
#' @seealso get_phecode_info
#'
#' @export
#'
#' @examples
#'
#' library(dplyr)
#'
#' # Simulate some random data associated with phecodes
#' data_w_phecodes <- sample_n(phecode_descriptions, 100) %>%
#'   select(code = phecode) %>%
#'   mutate(random = rnorm(n()))
#'
#' # Use function to add a column with description
#' data_w_phecodes %>%
#'   mutate(descrip = get_phecode_info(code, 'description'))
#'
#' # Use function to add column with category
#' data_w_phecodes %>%
#'   mutate(category = get_phecode_info(code, 'category'))
#'
#' # Use function to get dataframe of category and description that can be to join
#' # with data
#' bind_cols(
#'   data_w_phecodes,
#'   get_phecode_info(data_w_phecodes$code, 'all')
#' )
#'
get_phecode_info <- function(codes, what = 'description'){

  joined <- dplyr::left_join(dplyr::tibble(phecode = codes),
                   phecode_descriptions,
                   by = 'phecode')

  if(what == 'description'){
    return(joined$description)
  } else
  if(what == 'category'){
    return(joined$category)
  } else
  if(what == 'all') {
    return(dplyr::select(joined, phecode, description, category))
  } else {
    stop("what argument must be either 'description', 'category', or 'all'.")
  }
}


utils::globalVariables(c("phecode_descriptions", "phecode", "description",
                         "category", "category_number", "phecode_index"))


