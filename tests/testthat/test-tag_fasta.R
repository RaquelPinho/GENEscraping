test_that("The errors and warnings are working.", {
  wrong_file <- "./inst/extdata/testdata/coord_frame.csv"
  expect_error(
    tag_fasta(
      fasta_list = "AAACCATTCTTGGTGTAATGT",
      target = "ACACCTCAAAAGGTCTGGAGGGT"
    ),
    "Error tag_fasta: `fasta_list` is not a list!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      )
    ),
    "Error tag_fasta: targets sequences were not supplied!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list(">target1", "aaatattttggt"),
        list(">target2", "ggtgtaatgat")
      ),
      csv = c("./fake.csv")
    ), "Error tag_fasta: csv file doesn't exist!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      csv = "./inst/extdata/testdata/coord_frame.csv"
    ),
    "Error tag_fasta: imported file doesn't contain 'target' column."
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = "aaatatt"
    ),
    "Error tag_fasta: `target` and `fasta_list` have different lengths!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = c("aaatatt", "gtaatg"),
      tag_site = "three"
    ),
    "Error tag_fasta: tag_site is not numeric!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = c("aaatatt", "gtaatg"),
      tag_site = c(5, 3, 3)
    ),
    "Error tag_fasta: `tag_site` length is not compatible!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = c("aaatatt", "gtaatg"),
      tag_site = 8
    ),
    "Error tag_fasta: at least one `tag_site` larger than target length!"
  )
  expect_error(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = c("aaggtt", "gtaatg"),
      tag_site = 3
    ),
    "Error tag_fasta: the target ",
    target[i], " is not present in sequence ", i, "."
  )
})
