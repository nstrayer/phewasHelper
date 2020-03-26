#' Tidy a sparse matrix
#'
#' @param sparse_mat Sparse matrix of class `dgCMatrix` or its variants
#' @param rows_id What is stored in the rows of matrix
#' @param cols_id What is stored in the columns on matrix
#' @param values_id What the values in the cells are
#' @param keep_values Do you want to keep the values of the cells or is the matrix a binary one where just existance matters?
#'
#' @return Tidy df with a row for each non-empty entry in the sparse matrix. If `keep_values == TRUE` then there will be a third column containing the value of cell in matrix at pairing.
#' @export
#'
#' @examples
sparse_matrix_to_tidy <- function(sparse_mat, rows_id = "x", cols_id = "y", values_id = "value", keep_values = TRUE){

  row_ids <- sparse_mat@Dimnames[[1]]
  col_ids <- sparse_mat@Dimnames[[2]]

  row_indices <- as.integer(sparse_mat@i + 1)

  col_start_indices <- head(sparse_mat@p + 1, -1) # last entry is redundant
  col_indices <- rep(NA, length(sparse_mat@x))
  col_indices[col_start_indices] <- 1:length(col_ids)

  row_col_pairs <- dplyr::tibble(!!rlang::sym(rows_id) := row_ids[row_indices],
                                 !!rlang::sym(cols_id) := col_ids[col_indices]) %>%
    tidyr::fill(!!rlang::sym(cols_id), .direction = "down")

  if (keep_values) {
    row_col_pairs[values_id] = sparse_mat@x
  }

  row_col_pairs
}
