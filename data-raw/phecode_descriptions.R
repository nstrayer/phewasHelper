# Phecode 1.2 descriptions were downloaded from https://phewascatalog.org/files/phecode_definitions1.2.csv.zip
# on 02-14-2020.

phecodes <- dplyr::select(readr::read_csv('data-raw/phecode_definitions1.2.csv'),
                          phecode,
                          description = phenotype,
                          category,
                          category_number)

phecode_descriptions <- dplyr::mutate(phecodes,
                                      phecode = normalize_phecode(phecode),
                                      category_number = as.integer(category_number))

usethis::use_data(phecode_descriptions)
