## code to prepare `phecode_to_levels` dataset goes here
library(phewasHelper)

# Utility data provided by package
phecode_to_levels <- phecode_descriptions %>%
  dplyr::select(phecode) %>%
  tidyr::separate(phecode, into = c("code_l1", "sub"), sep = "\\.", remove = FALSE) %>%
  dplyr::mutate(
    code_l1 = as.integer(code_l1),
    code_l2 = as.integer(substr(sub, 1, 1)),
    code_l3 = as.integer(substr(sub, 2, 2))
  ) %>%
  dplyr::select(-sub)

usethis::use_data(phecode_to_levels, overwrite = TRUE)
