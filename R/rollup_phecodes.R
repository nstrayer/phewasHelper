#' Rollup phecode counts
#'
#' Takes phecodes that have been coded without rollup - E.g. existance of code
#' 008.10 does not imply the existance of 008.00 - and produces a rolledud
#' version of the dataset.
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
#'   ~patient,    ~code, ~count,
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
#' patient_data %>%
#'   rollup_phecode_counts(patient_col = patient,
#'                         phecode_col = code,
#'                         count_col = count)
#'
rollup_phecode_counts <- function(patient_code_counts,
                                  patient_col,
                                  phecode_col = phecode,
                                  count_col = count){

  with_hierarchy <- patient_code_counts %>%
    dplyr::rename(count = {{count_col}},
           phecode = {{phecode_col}}) %>%
    dplyr::left_join(phecode_to_levels, by = 'phecode') %>%
    filter(!is.na(code_l1))

  if(nrow(patient_code_counts) > nrow(with_hierarchy)){
    warning("Some codes in dataset didn't match phecode 1.2 definitions. These codes are being removed.")
  }

  rollup_l3 <- function(l3_data){
    rolledup_count <- sum(l3_data$count[l3_data$code_l3 != 0L])
    dplyr::tibble(count = rolledup_count, code_l3 = 0L) %>%
      dplyr::bind_rows(l3_data)
  }

  rollup_l2 <- function(l2_data){
    rolledup_count <- sum(dplyr::filter(l2_data, code_l2 != 0, code_l3 == 0)$count)
    dplyr::tibble(count = rolledup_count, code_l2 = 0L, code_l3 = 0L) %>%
      dplyr::bind_rows(l2_data)
  }
  with_hierarchy %>%
    dplyr::select(-phecode) %>%
    dplyr::group_by({{patient_col}}, code_l1, code_l2) %>%
    tidyr::nest() %>%
    dplyr::mutate(data = purrr::map(data, rollup_l3)) %>%
    tidyr::unnest(data) %>%
    dplyr::group_by({{patient_col}}, code_l1) %>%
    tidyr::nest() %>%
    dplyr::mutate(data = purrr::map(data, rollup_l2)) %>%
    tidyr::unnest(data) %>%
    dplyr::group_by({{patient_col}}, code_l1, code_l2, code_l3) %>%
    dplyr::summarise(count = sum(count)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate({{phecode_col}} := glue::glue("{code_l1}.{code_l2}{code_l3}") %>%
                    stringr::str_pad(width = 6, side = "left", pad = "0")) %>%
    dplyr::select(-code_l1, -code_l2, -code_l3)
}

utils::globalVariables(c("phecode", "count"))

