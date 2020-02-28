patient_data <- dplyr::tribble(
  ~patient,    ~code, ~counts,
  1, "250.23",      7,
  1, "250.25",      4,
  1, "696.42",      1,
  1, "555.21",      4,
  2, "401.22",      6,
  2, "204.21",      5,
  2, "735.22",      4,
  2, "751.11",      2,
)


benchmark_times <- bench::mark(
  counts = rollup_phecode_counts(patient_data, phecode_col = code),
  pairs = rollup_phecode_pairs(patient_data, phecode_col = code),
  iterations = 100,
  check = FALSE
)

plot(benchmark_times)


