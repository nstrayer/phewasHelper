
<!-- README.md is generated from README.Rmd. Please edit that file -->

# phewasHelper

<!-- badges: start -->

<!-- badges: end -->

The goal of phewasHelper is to provide a set of simple lightweight
helper functions for working with Phecode and Phewas data.

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("nstrayer/phewas_helper")
```

## Usage

We will use a sample set of simulated PheWas data with phecodes to
demonstrate the functions.

``` r
library(phewasHelper)

head(phewas_data)
#> # A tibble: 6 x 2
#>    code    val
#>   <dbl>  <dbl>
#> 1  516.  2.70 
#> 2  694  -0.753
#> 3  620. -0.357
#> 4  947   0.201
#> 5  165  -0.323
#> 6  798. -2.63
```

### Normalizing phecodes

Phecodes show up in about a million different formats. In our demo data
the phecodes have been converted to a numeric value. This would be an
issue if we tried to harmonize with data that stored the phecodes in a
string. The function `normalize_phecodes` is designed to fix this
problem. It takes any phecode array and coerces it to a standard
zero-padded string.

``` r
phewas_data %>% 
  mutate(fixed_code = normalize_phecode(code)) %>% 
  head()
#> # A tibble: 6 x 3
#>    code    val fixed_code
#>   <dbl>  <dbl> <chr>     
#> 1  516.  2.70  516.10    
#> 2  694  -0.753 694.00    
#> 3  620. -0.357 620.10    
#> 4  947   0.201 947.00    
#> 5  165  -0.323 165.00    
#> 6  798. -2.63  798.10


# Update our original data with normalized phecodes
phewas_data <- phewas_data %>% 
  mutate(code = normalize_phecode(code))
```

### Getting phecode information

Another issue that is commonly encountered in PheWas results is wanting
to know what exactly a code is. The functions `get_phecode_info()` and
`join_phecode_info()` help with that.

`get_phecode_info()` is the simpler of the two. It takes as input an
array of phecodes and returns an array of the desired information,
either description or category. This is useful for adding individual
columns to a dataframe.

``` r
phewas_data %>% 
  mutate(descript = get_phecode_info(code, 'description'),
         category = get_phecode_info(code, 'category')) %>% 
  head()
#> # A tibble: 6 x 4
#>   code      val descript                             category     
#>   <chr>   <dbl> <chr>                                <chr>        
#> 1 516.10  2.70  Hemoptysis                           respiratory  
#> 2 694.00 -0.753 Dyschromia and Vitiligo              dermatologic 
#> 3 620.10 -0.357 Dysplasia of cervix                  genitourinary
#> 4 947.00  0.201 Urticaria                            dermatologic 
#> 5 165.00 -0.323 Cancer within the respiratory system neoplasms    
#> 6 798.10 -2.63  Chronic fatigue syndrome             symptoms
```

For more a more complete labeling of phecode information the function
`join_phecode_info()` modifies a passsed dataframe by appending a
desired subset of description, category, category number, and phecode
index columns.

``` r
# We can append all info available
phewas_data %>% 
  join_phecode_info(phecode_column = 'code') %>% 
  head()
#> # A tibble: 6 x 6
#>   phecode    val description            category   category_number phecode_index
#>   <chr>    <dbl> <chr>                  <chr>                <dbl>         <int>
#> 1 516.10   2.70  Hemoptysis             respirato…               9           982
#> 2 694.00  -0.753 Dyschromia and Vitili… dermatolo…              13          1411
#> 3 620.10  -0.357 Dysplasia of cervix    genitouri…              11          1294
#> 4 947.00   0.201 Urticaria              dermatolo…              13          1482
#> 5 165.00  -0.323 Cancer within the res… neoplasms                2            97
#> 6 798.10  -2.63  Chronic fatigue syndr… symptoms                17          1719


# Or we can just extract what we need
phewas_data <- phewas_data %>% 
  join_phecode_info(phecode_column = 'code',
                    cols_to_join = c("description", "category", "phecode_index"))

head(phewas_data)
#> # A tibble: 6 x 5
#>   phecode    val description                          category     phecode_index
#>   <chr>    <dbl> <chr>                                <chr>                <int>
#> 1 516.10   2.70  Hemoptysis                           respiratory            982
#> 2 694.00  -0.753 Dyschromia and Vitiligo              dermatologic          1411
#> 3 620.10  -0.357 Dysplasia of cervix                  genitourina…          1294
#> 4 947.00   0.201 Urticaria                            dermatologic          1482
#> 5 165.00  -0.323 Cancer within the respiratory system neoplasms               97
#> 6 798.10  -2.63  Chronic fatigue syndrome             symptoms              1719
```

### Coloring PheWas plots

Manhattan plots are commonly made of phewas results. Frequently the
colors of the plots points are encoded by the categories. The default
color palletes in ggplot2 and base-plot are not great and custom
palletes like R color-brewer don’t give you enough colors to work with
all the categories. To deal with this `category_colors()` returns a
mapping of phecode category to colors that can be used easily in your
plots.

``` r
library(ggplot2)

phewas_data %>% 
  ggplot(aes(x = reorder(phecode, phecode_index), y = val, color = category)) +
  geom_point() +
  scale_color_manual(values = category_colors()) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())
```

<img src="man/figures/README-plot-w-category_colors-1.png" width="100%" />

If just the color pallete is needed for `ggplot` then the function
`scale_color_phecode()` makes this even easier.

``` r
phewas_data %>% 
  ggplot(aes(x = reorder(phecode, phecode_index), y = val, color = category)) +
  geom_point() +
  scale_color_phecode() +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())
```

<img src="man/figures/README-plot-w-scale_color_phecode-1.png" width="100%" />
