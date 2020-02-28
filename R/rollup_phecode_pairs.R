#' Rollup binary phecode pairs
#'
#' Takes phecodes that have been coded without rollup - E.g. existance of code
#' 008.10 does not imply the existance of 008.00 - and produces a rolledup
#' version of the dataset. Works with plain patient-phecode pairs and also with
#' patient-code-count triplets.
#'
#' @param patient_code_counts Data containing patient ids, phecodes, and counts
#'   of those phecodes.
#' @param patient_col Unquoted name of the column containing patient ids in
#'   passed `patient_code_counts`'s dataframe.
#' @param phecode_col Unquoted name of the column containing phecodes in passed
#'   dataframe.
#'
#' @return Dataframe in same format as passed `patient_code_counts` with code
#'   counts rolled up. This will most likely be longer than the original dataset
#'   because of the addition of potentially previously ommitted codes.
#' @export
#'
#' @examples
#'
#' library(dplyr)
#'
#' patient_data <- tribble(
#'   ~patient,    ~code,
#'          1, "250.23",
#'          1, "250.25",
#'          1, "696.42",
#'          1, "555.21",
#'          2, "401.22",
#'          2, "204.21",
#'          2, "735.22",
#'          2, "751.11",
#' )
#'
#'
#' # Also works with just binary occurance pairs
#' patient_data %>%
#'   rollup_phecode_pairs(patient_col = patient,
#'                   phecode_col = code)
#'
rollup_phecode_pairs <- function(patient_code_counts,
                                 patient_col = patient,
                                 phecode_col = phecode){

  # First turn phecodes into level information
  patient_code_counts %>%
    dplyr::select({{patient_col}}, {{phecode_col}}) %>%
    add_phecode_levels({{phecode_col}}) %>%
    # Add rolled up l2 rows
    dplyr::bind_rows(
      dplyr::distinct(., {{patient_col}}, code_l1, code_l2) %>%
        dplyr::mutate(code_l3 = 0)
    ) %>%
    # Add rolled up l1 rows
    dplyr::bind_rows(
      dplyr::distinct(., {{patient_col}}, code_l1) %>%
        dplyr::mutate(code_l2 = 0, code_l3 = 0)
    ) %>%
    # Remove repeat rows
    dplyr::distinct({{patient_col}}, code_l1, code_l2, code_l3) %>%
    # Rebuild the phecode column and return
    dplyr::transmute(
      {{patient_col}} := {{patient_col}},
      {{phecode_col}} := sprintf("%03i.%i%i", code_l1, code_l2, code_l3),
    )
}

utils::globalVariables(c("phecode", "count"))

