#' tag_fasta
#'
#' @description this function marks (inserts []) a specific position
#' based on a target sequence on genomic sequences in a list. the [] are going to
#' be inserted at position `tag_site` and `tag_site`+ 1.
#'
#' @param fasta_list a list of lists, each list containing two elements
#' the name, first element, and a sequence referring to a genomic regions, second
#' element. This list can be created using `get_fasta`.
#' @param target a character vector or dataframe containing the target region for each of the
#' sequences in the `fasta_list`. The length should be the same of `fasta_list`.
#' if target is a dataframe, it should have a column named "target".
#' @param csv a path to the csv file containing the list of target region or
#' table containing the target sequence. It will only be
#' considered if target is NULL.
#' @param tag_site a integer or a numerical vector, representing the localization of the
#' tag site in the targets. If it is one number, the tags will be inserted at position
#' tag_site from the first nucleotide of target. if it is a numerical vector,
#' it should be the same length as the `fasta_list`. default = `round(nchar(target)/2)`.
#'
#' @return a list containing the fasta_list plus a sequence containing the tag for
#' each of the elements of the fasta_list.
#' @export
#'
#' @seealso get_fasta
#' @examples
tag_fasta <- function(fasta_list = fasta_list,
                      target = NULL,
                      csv = NULL,
                      tag_site = NULL) {

  # check parameters
  target_info <- NULL


  if (is.null(target)) {
    if (is.null(csv)) {
      stop("Error tag_fasta: targets sequences were not supplied!")
    } else {
      if (!file.exists(csv)) {
        stop("Error tag_fasta: csv file doesn't exist!")
      } else {
        target_info <- utils::read.csv(csv)
      }
    }
  }

  if (!is.null(target_info)) {
    if (ncol(target_info) == 1) {
      target <- readLines(csv)
    } else {
      if (inherits(target_info, "data.frame")) {
        if ("target" %in% colnames(target_info)) {
          target <- target_info$target
        } else {
          stop("Error tag_fasta: imported file doesn't contain 'target' column.")
        }
      }
    }
  }

  if (is.null(target_info)) {
    if (inherits(target, "data.frame")) {
      target <- as.vector(target$target)
    }
  }

  if (is.null(tag_site)) {
    tag_site <- round(nchar(target) / 2)
  }

  check <- check_error_tag_fasta(
    fasta_list = fasta_list, tag_site = tag_site,
    target_info = target_info, target = target,
    csv = csv
  )

  loc_list <- lapply(seq_along(fasta_list), function(i) {
    # making sure there are no gaps in the target region
    if ("-" %in% unlist(strsplit(target, ""))) {
      target <- gsub("-", "", target)
    }
    # making sure to use the right tag_site
    tag <- ifelse(length(tag_site) == 1, tag_site, tag_site[i])

    # make sure the targets are present in the sequence
    if (stringr::str_detect(unlist(fasta_list[[i]][[2]]), target[i])) {
      location <- stringr::str_locate(unlist(fasta_list[[i]][[2]]), target[i])
    } else {
      xstring <- Biostrings::DNAString(target[i])
      if (stringr::str_detect(
        unlist(fasta_list[[i]][[2]]),
        as.character(Biostrings::reverseComplement(xstring))
      )) {
        location <- stringr::str_locate(
          unlist(fasta_list[[i]][[2]]),
          as.character(Biostrings::reverseComplement(xstring))
        )

        tag <- nchar(target[i]) - tag
      } else {
        stop(
          paste0(
            "Error tag_fasta: the target ",
            target[i], " is not present in sequence ", i, "."
          )
        )
      }
    }
    # Gettin the location where to put the tag
    location_tag <- data.frame(
      start = as.numeric(location[1, 1]) + tag,
      end = as.numeric(location[1, 1] + tag + 1)
    )
    return(location_tag)
  })

  # Getting the sequence that should be in the tags
  tag_seq_list <- get_tag_seq(fasta_list = fasta_list, loc_list = loc_list)

  # Adding the tags to the sequence from the fasta_list
  fasta_list_comp <- insert_tag(
    fasta_list = fasta_list, loc_list = loc_list,
    tag_seq_list = tag_seq_list
  )


  return(fasta_list_comp)
}



#' check_error_tag_fasta
#'
#'
#' @inheritParams tag_fasta
#' @param target_info target info should be NULL if target is not given by a csv file.
#'
#' @return no value
#'
check_error_tag_fasta <- function(fasta_list = fasta_list, tag_site = tag_site,
                                  target_info = target_info, target = target,
                                  csv = csv) {
  if (!inherits(fasta_list, "list")) {
    stop("Error tag_fasta: `fasta_list` is not a list!", call. = FALSE)
  }
  if (length(target) != length(fasta_list)) {
    stop("Error tag_fasta: `target` and `fasta_list` have different lengths!", call. = FALSE)
  }
  if (!is.numeric(tag_site)) {
    stop("Error tag_fasta: tag_site is not numeric!", call. = FALSE)
  }
  if (!(length(tag_site) == 1 | length(tag_site) == length(fasta_list))) {
    stop("Error tag_fasta: `tag_site` length is not compatible!", call. = FALSE)
  }
  if (any(tag_site > nchar(target))) {
    stop("Error tag_fasta: at least one `tag_site` larger than target length!", call. = FALSE)
  }
}


#' get_tag_seq
#'
#' function used to extract the sequence of the position tag_site in the target on the
#' complete sequence
#'
#' @param fasta_list
#' @param loc_list
#'
#' @return a list of dinucleotide sequences
get_tag_seq <- function(fasta_list = fasta_list, loc_list = loc_list) {
  tag_seq_list <- list()
  for (i in seq_along(fasta_list)) {
    tag_seq <- substr(unlist(fasta_list[[i]][[2]]), loc_list[[i]][1, 1], loc_list[[i]][1, 2])
    tag_seq <- paste0("[", tag_seq, "/", tag_seq, "]")
    tag_seq_list[[i]] <- tag_seq
  }
  return(tag_seq_list)
}

#' insert_tag
#'
#' @param fasta_list
#' @param loc_list
#' @param tag_seq_list
#'
#' @return the fasta list containing the sequence with and without the tag
insert_tag <- function(fasta_list = fasta_list, loc_list = loc_list,
                       tag_seq_list = tag_seq_list) {
  for (i in seq_along(fasta_list)) {
    seq <- paste0(
      substring(fasta_list[[i]][[2]], 1, (loc_list[[i]][1, 1] - 1)),
      tag_seq_list[[i]],
      substring(fasta_list[[i]][[2]], (loc_list[[i]][1, 2] + 1), nchar(fasta_list[[i]][[2]]))
    )
    fasta_list[[i]][[3]] <- seq
  }
  return(fasta_list)
}
