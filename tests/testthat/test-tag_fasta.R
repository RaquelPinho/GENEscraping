test_that("The errors and warnings are working.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"),
    package = "GENEscraping"
  ))
  wrong_file <- file.path(testdata_dir, "coord_frame.csv")
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
      csv = wrong_file
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
    "Error tag_fasta: the target aaggtt is not present in sequence 1."
  )
})


test_that("the function works when given a target vector.", {
  expect_equal(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = c("aaatatt", "gtaatg")
    ),
    list(
      list("target1", "aaatattttggt", "aaat[at/at]tttggt"),
      list("target2", "ggtgtaatgat", "ggtgta[at/at]gat")
    )
  )
})

test_that("The function works when given a target dataframe.", {
  expect_equal(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = data.frame(target = c("aaatatt", "gtaatg"), cut = c(3, 5))
    ),
    list(
      list("target1", "aaatattttggt", "aaat[at/at]tttggt"),
      list("target2", "ggtgtaatgat", "ggtgta[at/at]gat")
    )
  )
})

test_that("The function works when given a valid tag_site.", {
  expect_equal(
    tag_fasta(
      fasta_list = list(
        list("target1", "aaatattttggt"),
        list("target2", "ggtgtaatgat")
      ),
      target = data.frame(target = c("aaatatt", "gtaatg"), cut = c(3, 5)),
      tag_site = 4
    ),
    list(
      list("target1", "aaatattttggt", "aaat[at/at]tttggt"),
      list("target2", "ggtgtaatgat", "ggtgtaa[tg/tg]at")
    )
  )
})

test_that("The function works when given .csv file containing a valid vector.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"),
    package = "GENEscraping"
  ))
  valid_vec_file <- file.path(testdata_dir, "target_vec.csv")
  fasta_list <- readRDS(file.path(testdata_dir, "fasta_list.RDS"))
  fasta_list_tagged <- readRDS(file.path(testdata_dir, "fasta_list_tagged.RDS"))
  expect_equal(
    tag_fasta(
      fasta_list = fasta_list,
      csv = valid_vec_file,
      target = NULL
    ),
    fasta_list_tagged
  )
})

test_that("The function works when given .csv file containing a valid dataframe.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"),
    package = "GENEscraping"
  ))
  valid_dt_file <- file.path(testdata_dir, "target_dt.csv")
  fasta_list <- readRDS(file.path(testdata_dir, "fasta_list.RDS"))
  fasta_list_tagged <- readRDS(file.path(testdata_dir, "fasta_list_tagged.RDS"))
  expect_equal(
    tag_fasta(
      fasta_list = fasta_list,
      csv = valid_dt_file,
      target = NULL
    ),
    fasta_list_tagged
  )
})
