test_that("The errors and warnings are working.", {
  expect_error(
    write_fasta(
      fasta_list = "AAACCATTCTTGGTGTAATGT",
      path_to_file = "./output/demo_fasta.R"
    ),
    "Error write_fasta: `fasta_list` is not a list!"
  )
  expect_error(
    write_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")),
      path_to_file = 1),
    "Error write_fasta: `path_to_file` is not a character vector!"
  )
  expect_error(
    write_fasta(
      fasta_list = list(
        list(">target1", "aaatattttggt"),
        list(">target2", "ggtgtaatgat")),
      path_to_file = c("./target1.fasta", "./target2.fasta"), append = TRUE
    ),
    "Error write_fasta: the `path_to_file` has length greater than 1 and the
    `combined` option was selected."
  )
  expect_error(
    write_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt", "aaatat[tt]tggt"),
        list("target2", "ggtgtaatgat")
      ),
      path_to_file = c("./taget1.fasta"), tagged = TRUE
    ),
    "Error write_fasta: at least one element of `fasta_list` has length less than 3!"
  )
})

test_that("the function works with unamed and untagged list in combined fasta.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_fastalist <- file.path(testdata_dir, "fasta_list.RDS")
  fasta_list <- readRDS(test_fastalist)
  path_to_file <- "./inst/extdata/testdata/fasta_list.fasta"
  expect_snapshot_file(write_fasta(fasta_list = fasta_list, path_to_file = path_to_file), path_to_file)
})
