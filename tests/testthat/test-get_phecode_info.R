test_that("Gets descriptions", {
  expect_equal(
    get_phecode_info(
      c("795.82", "540.10", "634.00", "350.30", "557.10"),
      "description"
    ),
    c("Elevated cancer antigen 125 [CA 125]", "Appendicitis",
      "Miscarriage; stillbirth",              "Lack of coordination",
      "Celiac disease")
  )
})

test_that("Gets categories", {
  expect_equal(
    get_phecode_info(
      c("795.82", "540.10", "634.00", "350.30", "557.10"),
      "category"
    ),
    c("symptoms",     "digestive", "pregnancy complications",
      "neurological", "digestive")
  )
})

test_that("Gets all info", {
  expect_equal(
    get_phecode_info(
      c("795.82", "540.10", "634.00", "350.30", "557.10"),
      "all"
    ),
    dplyr::tribble(
      ~phecode,  ~description,                           ~category,
      "795.82",  "Elevated cancer antigen 125 [CA 125]", "symptoms",
      "540.10",  "Appendicitis",                         "digestive",
      "634.00",  "Miscarriage; stillbirth",              "pregnancy complications",
      "350.30",  "Lack of coordination",                 "neurological",
      "557.10",  "Celiac disease",                       "digestive",
    )
  )
})
