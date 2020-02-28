
#' Add phecode levels to dataframe
#'
#' Takes a dataframe with a phecode column and replaces it with the
#' hierarchichal levels of the phecodes as columns `code_l1, code_l2` and
#' `code_l3`.
#'
#' @param phecode_data Dataframe with a column encoding phecodes (make sure
#'   codes are normalized via \code{\link{normalize_phecodes}}).
#' @param phecode_column Unquoted name of the column containing phecodes
#' @param remove_phecode_column Should the original phecode column be kept in the data?
#'
#' @return Dataframe with phecode levels added as three integer columns
#' @export
#'
#' @examples
#'
#' patient_data <- dplyr::tribble(
#'   ~patient,    ~code, ~counts,
#'   1, "250.23",      7,
#'   1, "250.25",      4,
#'   1, "696.42",      1,
#'   1, "555.21",      4,
#'   2, "401.22",      6,
#'   2, "204.21",      5,
#'   2, "735.22",      4,
#'   2, "751.11",      2,
#' )
#'
#' # Default removes original phecode column
#' add_phecode_levels(patient_data, code)
#'
#' # Can keep original column as well
#' add_phecode_levels(patient_data, code, remove_phecode_column = FALSE)
#'
add_phecode_levels <- function(phecode_data,
                               phecode_column = phecode,
                               remove_phecode_column = TRUE){
  # Get original number of rows for checking of unjoined data
  original_n_rows <- nrow(phecode_data)

  join_matching <- rlang::set_names("phecode",
                                    rlang::quo_name(rlang::enquo(phecode_column)))

  phecode_data <- dplyr::left_join(phecode_data,
                                   phecode_to_levels,
                                   by = join_matching)

  if(remove_phecode_column) {
    phecode_data <- dplyr::select(phecode_data,
                                  -{{phecode_column}})
  }

  phecode_data <- dplyr::filter(phecode_data,
                                !is.na(code_l1))

  if(original_n_rows > nrow(phecode_data)){
    warning("Some codes in dataset didn't match phecode 1.2 definitions. These codes are being removed.")
  }

  phecode_data
}


