#' write_fasta
#'
#' @description A function to write .fasta files from a list of sequences.
#'
#' @param fasta_list a list of lists, each list containing at least two elements
#' the name, first element, and a sequence referring to a genomic regions, second
#' element. there could be a third element that would be the sequence including (tagging)
#' a target region in the sequence. The list can be named, and the name can be used to
#' create the header of the .fasta instead of the name contained in the first element.
#' the list can be created by the `get_fasta` function.
#' @param named logical if TRUE the header of the region in the .fasta file will be created
#' using the names of the list. When FALSE, the header will be creating from the first
#' element of each internal list.
#' @param tagged logical if TRUE the sequence written in the .fasta file will be taken
#' from the third element of each internal list. If FALSE, the sequence will be taken
#' from second element. The `tag_fasta` file can create a tagged sequence.
#' @param combined logical if TRUE will create one file containing all sequences in the
#' list. If false will create one file for each sequence. The files names and location will
#' be given by the `path_to_file` that should be a character vector with the same length as
#' the `fasta_list`.
#' @param path_to_file a character vector of length one, if `combined` = TRUE, or length
#' equal to the length of `fasta_list` if `combined` = FALSE.
#' @inheritParams tigger::writeFasta
#'
#' @seealso get_fasta tag_fasta tigger::writeFasta
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
  if (!inherits(path_to_file, c("character", "vector"))) {
    stop("Error write_fasta: `path_to_file` is not a character vector!")
  }
  if (any(sapply(fasta_list,length) < 2)) {
    stop("Error write_fasta: at least one element of `fasta_list` has length less than 2!")
  }
  if (combined == TRUE & length(path_to_file) > 1) {
    warning("WARNING: the `path_to_file` has length greater than 1 and the `combined` option was selected.
  		The first element of `path_to_file' will be used.")
  }
  if (combined == FALSE & length(path_to_file) != length(fasta_list)) {
    stop("Error write_fasta: the length of `path_to_file` is different the length of `fasta_list`.")
  }
  if (tagged == TRUE & any(sapply(fasta_list,length) < 3)) {
    stop("Error write_fasta: at least one element of `fasta_list` has length less than 3!")
  }

   fasta_file <- sapply(seq_along(fasta_list), function(i) {
     if (tagged == TRUE) {
       seq <- unlist(fasta_list[i][3])
     } else {
       seq <- unlist(fasta_list[i][2])
     }
     if (named == TRUE) {
       names(seq) <- names(fasta_list)
     } else {
       names(seq) <- unlist(fasta_list[i][1])
     }
     return(seq)

    })

  if (combined == FALSE) {
     for(i in seq_along(seq)) {
       tigger::writeFasta(named_sequences = seq[i], file = path_to_file[i], append = FALSE, width = 60)
     }
   } else {
     tigger::writeFasta(named_sequences = seq, file = path_to_file, append = FALSE, width = 60)
   }

   return(invisible(NULL))

}


