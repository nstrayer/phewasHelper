test_that("Warns if some codes didn't match known phecodes", {
  patient_data <- dplyr::tribble(
    ~patient, ~code,
    1,     "250.23",
    2,     "008.50",
    2,     "008.53", # bad code
  )

  expect_warning(
    add_phecode_levels(patient_data, phecode_column = code),
    "Some codes in dataset didn't match phecode 1.2 definitions. These codes are being removed.",
    fixed = TRUE
  )
})

test_that("Works as expected with well formed codes", {
  patient_data <- dplyr::tribble(
    ~patient, ~code,
    1,     "250.23",
    2,     "008.50",
    2,     "008.60",
  )

  expect_equal(
    add_phecode_levels(patient_data, phecode_column = code),
    dplyr::tribble(
      ~patient, ~code_l1, ~code_l2, ~code_l3,
             1,     250L,       2L,       3L,
             2,       8L,       5L,       0L,
             2,       8L,       6L,       0L,
    )
  )

  # Leave phecode column options
  expect_equal(
    add_phecode_levels(patient_data,
                       phecode_column = code,
                       remove_phecode_column = FALSE),
    dplyr::tribble(
      ~patient,   ~code, ~code_l1, ~code_l2, ~code_l3,
      1,       "250.23",     250L,       2L,       3L,
      2,       "008.50",       8L,       5L,       0L,
      2,       "008.60",       8L,       6L,       0L,
    )
  )
})
