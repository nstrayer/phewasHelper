test_that("Rolling up with counts works", {
  patient_data <- dplyr::tribble(
    ~patient,    ~code, ~counts,
    1, "250.23",      7,
    1, "250.25",      4,
    1, "696.40",      1,
    1, "555.21",      4,
    2, "401.22",      6,
    2, "204.00",      5,
    2, "751.11",      2,
    2, "008.00",      1,
    2, "008.50",      2,
    2, "008.51",      3,
  )

  rolled_up_data <- dplyr::tribble(
    ~patient,    ~code, ~counts,
    1, "250.00",      11,
    1, "250.20",      11,
    1, "250.23",      7,
    1, "250.25",      4,
    1, "696.00",      1,
    1, "696.40",      1,
    1, "555.00",      4,
    1, "555.20",      4,
    1, "555.21",      4,
    2, "401.00",      6,
    2, "401.20",      6,
    2, "401.22",      6,
    2, "204.00",      5,
    2, "751.00",      2,
    2, "751.10",      2,
    2, "751.11",      2,
    2, "008.00",      6,
    2, "008.50",      5,
    2, "008.51",      3,
  )

  expect_equal(rollup_phecode_counts(patient_data, phecode_col = code),
               rolled_up_data)

})

test_that("Rolling up with binary pairs works", {
  patient_data <- dplyr::tribble(
    ~patient, ~code,
    1,     "250.23",
    1,     "250.25",
    1,     "696.40",
    1,     "555.21",
    2,     "401.22",
    2,     "204.00",
    2,     "751.11",
    2,     "008.00",
    2,     "008.50",
    2,     "008.51",
  )

  rolled_up_data <- dplyr::tribble(
    ~patient, ~code,
    1,     "250.00",
    1,     "250.20",
    1,     "250.23",
    1,     "250.25",
    1,     "696.00",
    1,     "696.40",
    1,     "555.00",
    1,     "555.20",
    1,     "555.21",
    2,     "401.00",
    2,     "401.20",
    2,     "401.22",
    2,     "204.00",
    2,     "751.00",
    2,     "751.10",
    2,     "751.11",
    2,     "008.00",
    2,     "008.50",
    2,     "008.51",
  )

  expect_equal(rollup_phecode_pairs(patient_data, phecode_col = code),
               rolled_up_data)

})
