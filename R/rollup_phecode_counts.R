#' Rollup phecode counts
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
#' @param count_col Unquoted name of the column containing counts of phecodes in
#'   passed dataframe.
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
#' # Rolls up counts for codes if they are present
#' patient_data %>%
#'   rollup_phecode_counts(patient_col = patient,
#'                   phecode_col = code,
#'                   count_col = counts)
#'
#'
rollup_phecode_counts <- function(patient_code_counts,
                            patient_col = patient,
                            phecode_col = phecode,
                            count_col = counts){

  # First turn phecodes into level information
  patient_code_counts %>%
    dplyr::select({{patient_col}}, {{phecode_col}}, counts = {{count_col}}) %>%
    add_phecode_levels({{phecode_col}}) %>%
    # Add rolled up l2 rows
    dplyr::bind_rows(dplyr::group_by(., {{patient_col}}, code_l1, code_l2) %>%
        dplyr::summarise(counts := sum(counts[code_l3 != 0])) %>%
        dplyr::mutate(code_l3 = 0) ) %>%
    # Add rolled up l1 rows
    dplyr::bind_rows(dplyr::group_by(., {{patient_col}}, code_l1) %>%
        dplyr::summarise(counts := sum(counts[(code_l2 != 0) & (code_l3 == 0)])) %>%
        dplyr::mutate(code_l2 = 0, code_l3 = 0)  ) %>%
    # Get rid of duplicate rows potentially added
    dplyr::group_by({{patient_col}}, code_l1, code_l2, code_l3) %>%
    dplyr::summarise(counts := sum(counts)) %>%  # Rebuild the phecode column and return
    dplyr::ungroup() %>%
    # Restore dataframe to the format that the user expects it
    dplyr::transmute(
      {{phecode_col}} := sprintf("%03i.%i%i", code_l1, code_l2, code_l3),
      {{patient_col}} := {{patient_col}},
      {{count_col}} := counts
    )
}



utils::globalVariables(c("phecode", "count"))

