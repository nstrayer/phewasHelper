#' Phecode to hierarchy levels
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' @format A data frame with 1,866 rows and 4 variables:
#' \describe{
#'   \item{phecode}{Normalized phecode (1.2)}
#'   \item{code_l1}{Level one of hierarchy (aka number before decimal point)}
#'   \item{code_l2}{Level two of hierarchy (aka first number after decimal point)}
#'   \item{code_l3}{Level three of hierarchy (aka second number after decimal point)}
#' }
"phecode_to_levels"


#' Phecode Descriptions
#'
#' A dataset containing the info on phecodes in terms of description, category, and index
#'
#' @format A data frame with 1,866 rows and 4 variables:
#' \describe{
#'   \item{phecode}{Normalized phecode (1.2)}
#'   \item{description}{Description of this specific phecode}
#'   \item{category}{What broader category phecode resides in}
#'   \item{category_number}{Integer mapping for category}
#'   \item{phecode_index}{Integer mapping for all phecodes}
#' }
"phecode_descriptions"
