#' get_fasta
#'
#' @description This function use RSelenium to open NCBI urls and extract the
#' fasta sequence from them. WARNING! It will automatically open the browser
#' chosen to retrieve the information.
#'
#' @param weblist a list of URLs containing the NCBI website of the fasta sequence
#' of genomic regions.
#' @param feature vector same length of the web_list or character string
#' of the html feature/s containing the fasta information in the NCBI html.
#' @inheritParams RSelenium::rsDriver
#' @inheritParams get_coord_website
#'
#'
#'
#' @return list of genomic sequences referent to the urls/coordinates given by
#' the user and can be used to write .fasta files using the function `write_fasta`.
#'
#' @seealso
#' * [write_fasta()] write .fasta files from a character list of sequences.
#' * [get_coord_website()] use genomic coordinates to find the associated NCBI urls.
#' * [tag_fasta()] mark the target region for the off target region.
#' For rhAmpSeq, panel design.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' weblist <- list(
#'   target1 =
#'   "https://www.ncbi.nlm.nih.gov/nuccore/NC_010443.5?report=fasta&from=39157155&to=39157675",
#'   target2 =
#'   "https://www.ncbi.nlm.nih.gov/nuccore/NC_010458.4?report=fasta&from=27277683&to=27278206",
#'   target3 =
#'   "https://www.ncbi.nlm.nih.gov/nuccore/NC_010445.4?report=fasta&from=46206177&to=46206699"
#' )
#' #' get_fasta(weblist = weblist, browser = "chrome", port = 4455L )
#' }
get_fasta <- function(weblist = NULL, coord_table = NULL, flank_n = 250,
                      feature = "//pre", verbose = TRUE, port = netstat::free_port(),
                      chromever = "97.0.4692.71", check = TRUE,
                      browser = c("chrome", "firefox", "phantomjs", "internet explorer"),
                      version = "latest", geckover = "latest") {
  if (!is.null(weblist)) {
    if (!inherits(weblist, "list")) {
      stop("Error get_fasta: `weblist` is not a list!")
    }
  }

  if (is.null(weblist)) {
    if (is.null(coord_table)) {
      stop("Error get_fasta: Neither a list of URLs or a table of genomic coordinates were given!")
    } else {
      if (!inherits(coord_table, "data.frame")) {
        stop(" Error get_fasta: `coord_table` is not a data.frame!")
      } else {
      weblist <- get_coord_website(coord_table = coord_table, flank_n = flank_n)
    }
    }
  }
    if (browser == "firefox") {
      chromever <- NULL
    }
    rd <- RSelenium::rsDriver(
      verbose = TRUE,
      port = port,
      browser = browser,
      chromever = chromever,
      check = TRUE
    )
    remdr <- rd$client
    fasta_list <- lapply(seq_along(weblist), function(i) {
      url_ncbi <- weblist[[i]]
      remdr$navigate(url_ncbi)
      date_time <- Sys.time()
      while ((as.numeric(Sys.time()) - as.numeric(date_time)) < 5) {
        page_source <- remdr$getPageSource()
        if (length(feature) > 1) {
          feature <- feature[i]
        }
        target <- names(weblist)[i]

        fasta <- rvest::read_html(page_source[[1]]) %>%
          rvest::html_nodes("body") %>%
          xml2::xml_find_all(feature) %>%
          rvest::html_text()
        fasta
      }
      fasta_name <- gsub("\n.*", "", fasta)
      fasta_seq <- mgsub::mgsub(fasta, c(fasta_name, "\n"), c("", ""))
      title_fasta <- paste0(fasta_name, " ", target)
      fasta_l <- list(title_fasta, fasta_seq)
      fasta_l
    })
    remdr$close()
    rd$server$stop()
    rm(rd)
    gc()
    return(fasta_list)
}
