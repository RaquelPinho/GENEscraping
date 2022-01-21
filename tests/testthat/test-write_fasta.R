test_that("The errors and warnings are working.", {
  expect_error(write_fasta(fasta_list = "AAACCATTCTTGGTGTAATGT",
                           path_to_file = "./output/demo_fasta.R"),
               "Error write_fasta: `fasta_list` is not a list!"
               )
  expect_error(write_fasta(fasta_list = list(list("target1", "aaatattttggt"),
                                             list("target2", "ggtgtaatgat")),
                           path_to_file = 1),
               "Error write_fasta: `path_to_file` is not a character vector!"
               )
  expect_warning(write_fasta(fasta_list = list(list("target1", "aaatattttggt"),
                                               list("target2", "ggtgtaatgat")),
                             path_to_file = c("./taget1.fasta", "./target2.fasta")),
                 "WARNING: the `path_to_file` has length greater than 1 and the `combined`
                 option was selected. The first element of `path_to_file' will be used."
                 )
  expect_error(write_fasta(fasta_list = list(list("target1", "aaatattttggt", "aaatat[tt]tggt"),
                                             list("target2", "ggtgtaatgat")),
                           path_to_file = c("./taget1.fasta"), tagged = TRUE),
               "Error write_fasta: at least one element of `fasta_list` has length less than 3!"
               )

})
