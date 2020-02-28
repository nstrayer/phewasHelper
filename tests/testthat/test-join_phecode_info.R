test_that("Information joining", {
  patient_data <- dplyr::tribble(
    ~patient,    ~code, ~counts,
    1,        "250.23",      7,
    1,        "250.25",      4,
    1,        "008.00",      3,
    2,        "008.00",      1,
    2,        "008.50",      2,
    2,        "008.51",      3,
  )

  expect_equal(
    join_phecode_info(patient_data, phecode_column = code),
    dplyr::tibble(
      patient = c(1,1,1,2,2,2),
      code = c("250.23","250.25","008.00","008.00","008.50","008.51"),
      counts = c(7,4,3,1,2,3),
      description = c(
        "Type 2 diabetes with ophthalmic manifestations",
        "Diabetes type 2 with peripheral circulatory disorders",
        "Intestinal infection",
        "Intestinal infection",
        "Bacterial enteritis",
        "Intestinal e.coli"
      ),
      category = c(
        "endocrine/metabolic",
        "endocrine/metabolic",
        "infectious diseases",
        "infectious diseases",
        "infectious diseases",
        "infectious diseases"
      ),
      category_number = as.integer(c(3,3,1,1,1,1)),
      phecode_index = as.integer(c(244, 246, 1, 1, 2, 3))
    )
  )
})
