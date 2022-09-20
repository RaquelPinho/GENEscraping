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
        list("target2", "ggtgtaatgat")
      ),
      path_to_file = 1
    ),
    "Error write_fasta: `path_to_file` is not a character vector!"
  )
  expect_error(
    write_fasta(
      fasta_list = list(
        list(">target1", "aaatattttggt"),
        list(">target2", "ggtgtaatgat")
      ),
      path_to_file = c("./target1.fasta", "./target2.fasta"), append = TRUE
    ), "Error write_fasta: the `path_to_file` has length greater than 1 and the
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
  test_fasta_list <- file.path(testdata_dir, "fasta_list.RDS")
  fasta_list <- readRDS(test_fasta_list)
  test_fasta_file <- file.path(testdata_dir, "fasta_list.fasta")
  file = tempfile(pattern = "fasta_list", tempdir(), fileext = ".fasta" )
  expect_false(file.exists(file))
  write_fasta(fasta_list = fasta_list, path_to_file = file  )
  expect_true(file.exists(file))
  expect_equal(file.info(file)$size, file.info(test_fasta_file)$size)
  on.exit(unlink(file))
  })

test_that("the function works with unamed and unttaged, writing in separate files.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"),
                                        package = "GENEscraping"))
  test_fasta_list <- file.path(testdata_dir, "fasta_list.RDS")
  fasta_list <- readRDS(test_fasta_list)

  files <- sapply(c("fasta1", "fasta2", "fasta3"), function(name_f) {
    file <- tempfile(pattern = name_f, tempdir(), fileext = ".fasta" )
    expect_false(file.exists(file))
    file
  })
  test_files <- sapply(c("fasta1", "fasta2", "fasta3"), function(name_f) {
    test_file <- file.path(testdata_dir, paste0(name_f, ".fasta"))
    test_file
  })
  write_fasta(fasta_list = fasta_list, combined = FALSE, path_to_file = files)
  for (i in seq_along(files)) {
    expect_true(file.exists(files[i]))
    expect_equal(file.info(files[i])$size, file.info(test_files[i])$size)
    on.exit(unlink(files[i]))
  }
  })

test_that("the function works with named but untagged list in combined fasta.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_fasta_list <- file.path(testdata_dir, "fasta_list.RDS")
  fasta_list <- readRDS(test_fasta_list)
  names(fasta_list) <- paste0('target', c(1:3))
  test_fasta_file <- file.path(testdata_dir, "fasta_list_named.fasta")
  file = tempfile(pattern = "fasta_list_named", tempdir(), fileext = ".fasta" )
  expect_false(file.exists(file))
  write_fasta(fasta_list = fasta_list, path_to_file = file , named = TRUE )
  expect_true(file.exists(file))
  expect_equal(file.info(file)$size, file.info(test_fasta_file)$size)
  on.exit(unlink(file))
  })
