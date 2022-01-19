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
#' @return
#' @export
#'
#' @examples
#' weblist <- list(
#' target1 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010443.5?report=fasta&from=39157155&to=39157675",
#' target2 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010458.4?report=fasta&from=27277683&to=27278206",
#' target3 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010445.4?report=fasta&from=46206177&to=46206699"
#' )
#' get_fasta(weblist = weblist, feature = feature)
#'
#'
get_fasta <- function(weblist = weblist, coord_table = NULL, flank_n = 250,
                      feature = "feature", verbose = TRUE, port = 4552L,
                      chromever = '94.0.4606.113', check = TRUE, browser = "chrome" ) {
  if (is.null(weblist)) {
    if (is.null(coord_table)) {
      stop("Neither a list of URLs or a table of genomic coordinates were given!")
    } else {
      weblist <- get_coord_website(coord_table = coord_table, flank_n = flank_n)
    }
  } else {
    rD <-RSelenium::rsDriver(verbose = TRUE,
                   port = 5557L,
                   chromever = '94.0.4606.113',
                   check = TRUE)
    remDr <- rD$client
    fasta_list<- lapply(seq_along(weblist),function(i) {
    urlNCBI <- weblist[[i]]
    remDr$navigate(urlNCBI)
    date_time <- Sys.time()
    while((as.numeric(Sys.time()) - as.numeric(date_time)) < 5){
      page_source <- remDr$getPageSource()
      if (length(feature) > 1) {
        feature = feature[i]
      }
      Target <- names(weblist)[i]

      fasta <- rvest::read_html(page_source[[1]]) %>%
        rvest::html_nodes("body") %>%
        xml2::xml_find_all(feature) %>%
        rvest::html_text()
    }
    fasta_name <- gsub("\n.*", "",fasta)
    fasta_seq <- mgsub::mgsub(fasta, c(fasta_name, "\n"), c("", ""))
    title_fasta <- paste0(fasta_name," ", Target)
    fasta_l <- list(title_fasta, fasta_seq)
    fasta_l

  })
  remDr$close()
  return(fasta_list)
  }

}
