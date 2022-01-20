#' write_fasta
#'
#' @description A function to write .fasta files from a list of sequences.
#'
#' @param fasta_list a list of lists, each list containing at least two elements
#' the name, first element, and a sequence referring to a genomic regions, second
#' element. there could be a third element that would be the sequence including (tagging)
#' a target region in the sequence. The list can be named, and the name can be used to
#' create the header of the .fasta instead of the name contained in the first element.
#' @param named logical if TRUE the header of the region in the .fasta file will be created
#' using the names of the list. When FALSE, the header will be creating from the first
#' element of each internal list.
#' @param tagged logical if TRUE the sequence written in the .fasta file will be taken
#' from the third element of each internal list. If FALSE, the sequence will be taken
#' from second element.
#' @param combined logical if TRUE will create one file containing all sequences in the
#' list. If false will create one file for each sequence. The files names and location will
#' be given by the `path_to_file` that should be a character vector with the same length as
#' the `fasta_list`.
#' @param path_to_file a character vector of length one, if `combined` = TRUE, or length
#' equal to the length of `fasta_list` if `combined` = FALSE.
#' @inheritParams tigger::writeFasta
#'
#'
#' @return .fasta files.
#' @export
#'
#' @examples
write_fasta <- function(fasta_list = fasta_list, named = FALSE,
                        tagged = FALSE, combined = TRUE, path_to_file = path_to_file,
                        width = 60, append = FALSE) {
  if (!inherits(fasta_list, "list")) {
    stop("Error write_fasta: `fasta_list` is not a list!")
  }
}
  sapply(seq_along(fasta_list_G2),function(i) {
  seq<- unlist(fasta_list_G2[[i]][3])
  names(seq) <-  paste0(names(fasta_list_G2)[i],"_AR_G2")
  seq
})
tigger::writeFasta(seq_vector, file = "D:/Raquel/Desktop/AR_project/Androgen_receptor/Results/CHANGE_seq/MiniSeq/seq_panel_G2_red_name.fasta" )

