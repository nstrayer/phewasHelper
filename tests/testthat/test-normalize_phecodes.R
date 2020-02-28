test_that("Converts from numeric to proper values", {
  codes <- c(3.42, 192, 159.3, 8, 42.3)

  expect_equal(
    normalize_phecodes(codes),
    c("003.42", "192.00", "159.30", "008.00", "042.30")
  )
})

test_that("Converts from already strings to proper values", {
  codes <- c("03.42", "192", "159.3", "8.0", "42.3")

  expect_equal(
    normalize_phecodes(codes),
    c("003.42", "192.00", "159.30", "008.00", "042.30")
  )
})

test_that("Converts from overpadded strings to proper values", {
  codes <- c("00003.4200", "00192", "159.3000", "08.00000", "0042.300")

  expect_equal(
    normalize_phecodes(codes),
    c("003.42", "192.00", "159.30", "008.00", "042.30")
  )
})
