testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
test_fastalist <- file.path(testdata_dir, "fasta_list.RDS")
fasta_list <- readRDS(test_fastalist)
path_to_file <- "./inst/extdata/testdata/fasta_list.fasta"
## Helper function to create the path to the snapshot file for testing
write_fasta <- function(fasta_list = fasta_list, named = FALSE, contain_flag = TRUE,
                        tagged = FALSE, combined = TRUE, path_to_file = path_to_file,
                        width = 60, append = FALSE) {
  if (!inherits(fasta_list, "list")) {
    stop("Error write_fasta: `fasta_list` is not a list!")
  }
  if (!inherits(path_to_file, c("character", "vector"))) {
    stop("Error write_fasta: `path_to_file` is not a character vector!")
  }
  if (any(sapply(fasta_list, length) < 2)) {
    stop("Error write_fasta: at least one element of `fasta_list` has length less than 2!")
  }
  if (combined == TRUE & length(path_to_file) > 1) {
    warning("WARNING: the `path_to_file` has length greater than 1 and the `combined` option was selected.
  		The first element of `path_to_file' will be used.")
  }
  if (combined == FALSE & length(path_to_file) != length(fasta_list)) {
    stop("Error write_fasta: the length of `path_to_file` is different the length of `fasta_list`.")
  }
  if (tagged == TRUE & any(sapply(fasta_list, length) < 3)) {
    stop("Error write_fasta: at least one element of `fasta_list` has length less than 3!")
  }

  fasta_file <- sapply(seq_along(fasta_list), function(i) {
    if (tagged == TRUE) {
      seq <- unlist(fasta_list[[i]][[3]])
    } else {
      seq <- unlist(fasta_list[[i]][[2]])
    }
    if (named == TRUE) {
      names(seq) <- names(fasta_list)[i]
    } else {
      if (contain_flag == TRUE) {
        name_f <- unlist(fasta_list[[i]][[1]])
        name_f <- sub(".", "", name_f)
        names(seq) <- name_f
      } else {
        names(seq) <- unlist(fasta_list[[i]][[1]])
      }
    }
    return(seq)
  })

  if (combined == FALSE) {
    for (i in seq_along(seq)) {
      tigger::writeFasta(named_sequences = fasta_file[i], file = path_to_file[i], append = FALSE, width = 60)
    }
  } else {
    tigger::writeFasta(named_sequences = fasta_file, file = path_to_file, append = FALSE, width = 60)
  }

  return(invisible(NULL))
}

write_fasta(fasta_list = fasta_list, path_to_file = path_to_file)
save_path <- path_to_file
save_path
experc
