# Phecode 1.2 descriptions were downloaded from https://phewascatalog.org/files/phecode_definitions1.2.csv.zip
# on 02-14-2020.

library(dplyr)

phecode_descriptions <- readr::read_csv('data-raw/phecode_definitions1.2.csv') %>%
  select(phecode,
         description = phenotype,
         category,
         category_number) %>%
   mutate(phecode = normalize_phecode(phecode),
          category_number = as.integer(category_number),
          category_number = ifelse(category_number == 0, 19, category_number),
          category = ifelse(category == "NULL", 'other', category)) %>%
    arrange(category_number,
            as.numeric(phecode)) %>%
    mutate(phecode_index = row_number())


usethis::use_data(phecode_descriptions, overwrite = TRUE)
