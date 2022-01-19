#' GetCoordWebsite
#' @description
#' This function uses a dataframe of genomic coordinates such as:
#' NC_010443.5 39157405 39157428 to get the NCBI URL of the fasta of the region plus
#' 250nt upstream and downstream of the coordinates.
#'
#' @import tibble
#'
#' @param coord_table a dataframe or a .csv file of genomics coordinates
#' containing the columns:
#'  "Name" - a reference name or tag for each of the coordinates,
#'  'NCBI_ID' - the NCBI reference sequence ID (e.g. NC_010443.5),
#'  "start" - the coordinate for the start position ,
#'  "end" - the coordinate for the end position.
#' @param flank_n the number of nucleotides flanking upstream and downstream the
#' coordinates given (default = 250).
#'
#' @return listweb a list of URLs containing the fasta sequence of the coordinates.
#' @export
#'
#' @examples
#' library("tibble")
#' dt <- tibble::tribble(
#'   ~Name, ~Chr, ~NCBI_ID, ~start, ~end,
#'   "target1", "chr1", "NC_010443.5", 39157405, 39157425,
#'   "target2", "chr16", "NC_010458.4", 27277933, 27277956,
#'   "target3", "chr3", "NC_010445.4", 46206427, 46206449
#' )
#' get_coord_website(coord_table = dt, flank_n = 250)
#'
get_coord_website <- function(coord_table = coord_table, flank_n = 250) {
  if (!is.data.frame(coord_table)) {
    if (utils::file_test("-f", coord_table)) {
      coord_table <- utils::read.csv(coord_table)
    } else {
      stop("coord_table is not a file or a dataframe!")
    }
  }
  weblist <- lapply(seq_along(coord_table$Name), function(i) {
    id <- coord_table$NCBI_ID[i]
    start <- as.numeric(coord_table$start[i]) - 250
    end <- as.numeric(coord_table$end[i]) + 250
    website <- paste0(
      "https://www.ncbi.nlm.nih.gov/nuccore/",
      id,
      "?report=fasta&from=",
      start,
      "&to=",
      end
    )
    website
  })
  names(weblist) <- coord_table$Name
  return(weblist)
}
