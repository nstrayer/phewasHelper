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
#'   passed dataframe. Leave empty if just passing binary patient-code
#'   occurances
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
#'   rollup_phecodes(patient_col = patient,
#'                   phecode_col = code,
#'                   count_col = counts)
#'
#' # Also works with just binary occurance pairs
#' patient_data %>%
#'   rollup_phecodes(patient_col = patient,
#'                   phecode_col = code)
#'
rollup_phecodes <- function(patient_code_counts,
                            patient_col,
                            phecode_col = phecode,
                            count_col = NULL){
  # Did we get data with a counts in addition to patient code pairs? If so, we
  # need to deal with count column.
  count_mode <- !missing(count_col)

  # Make sure we only carry around the columns we need (these data can be big)
  if(count_mode){
    rolled_up <- patient_code_counts %>%
      select({{patient_col}}, {{phecode_col}}, counts = {{count_col}})

    count_col_name <- rlang::quo_text(rlang::enquo(count_col))
  } else {
    rolled_up <- patient_code_counts %>%
      select({{patient_col}}, {{phecode_col}})
  }

  rolled_up <- rolled_up %>%
    dplyr::rename(phecode = {{phecode_col}}) %>%
    dplyr::left_join(phecode_to_levels, by = 'phecode') %>%
    filter(!is.na(code_l1)) %>%
    dplyr::select(-phecode)

  if(nrow(patient_code_counts) > nrow(rolled_up)){
    warning("Some codes in dataset didn't match phecode 1.2 definitions. These codes are being removed.")
  }

  rollup_l3s <- function(phecode_data){
    if(count_mode){
      phecode_data <- phecode_data %>%
        dplyr::group_by({{patient_col}}, code_l1, code_l2) %>%
        dplyr::summarise(counts := sum(counts[code_l3 != 0]))
    } else {
      phecode_data <- phecode_data %>%
        dplyr::distinct({{patient_col}}, code_l1, code_l2)
    }
    dplyr::mutate(phecode_data, code_l3 = 0)
  }

  rollup_l2s <- function(phecode_data){
    if(count_mode){
      phecode_data <- phecode_data %>%
        dplyr::group_by({{patient_col}}, code_l1) %>%
        dplyr::summarise(counts := sum(counts[(code_l2 != 0) & (code_l3 == 0)]))
    } else {
      phecode_data <- phecode_data %>%
        dplyr::distinct({{patient_col}}, code_l1)
    }
    dplyr::mutate(phecode_data,
                  code_l2 = 0,
                  code_l3 = 0)
  }

  # Add the l2 rows for all the l3 rows
  rolled_up %>%
    dplyr::bind_rows(rollup_l3s(.)) %>%
    dplyr::bind_rows(rollup_l2s(.)) %>% {
      if(count_mode){
        # In count mode we need to collapse the counts for repeat obs
        dplyr::group_by(., {{patient_col}}, code_l1, code_l2, code_l3) %>%
          dplyr::summarise({{count_col}} := sum(counts))
      } else {
        # In binary mode we just need to remove repeat rows
        dplyr::distinct(., {{patient_col}}, code_l1, code_l2, code_l3)
      }

    } %>%  # Rebuild the phecode column and return
    dplyr::ungroup() %>%
    dplyr::mutate({{phecode_col}} := glue::glue("{code_l1}.{code_l2}{code_l3}") %>%
                    stringr::str_pad(width = 6, side = "left", pad = "0")) %>%
    dplyr::select(-code_l1, -code_l2, -code_l3)
}

utils::globalVariables(c("phecode", "count"))

