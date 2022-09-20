test_that("The function gives errors with wrong inputs", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_dataframe <- file.path(testdata_dir, "coord_dataframe.RDS")
  dt <- readRDS(test_dataframe)
  expect_error(
    get_fasta(weblist = dt, coord_table = NULL, browser = "chrome"),
    "Error get_fasta: `weblist` is not a list!"
    )
  expect_error(
    get_fasta(browser = "chrome", port = 4789L),
    "Error get_fasta: Neither a list of URLs or a table of genomic coordinates were given!"
  )
  expect_error(
  get_fasta(weblist = NULL, coord_table = 1, browser = "chrome"),
  " Error get_fasta: `coord_table` is not a data.frame!"
  )
})



test_that("The function works with a dataframe of genomic coordinates.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_dataframe <- file.path(testdata_dir, "coord_dataframe.RDS")
  test_fastalist <- file.path(testdata_dir, "fasta_list.RDS")
  dt <- readRDS(test_dataframe)
  f_list <- readRDS(test_fastalist)
  expect_equal(
    get_fasta(weblist = NULL, coord_table = dt, browser = "chrome"), f_list)
    })

test_that("The function works with a list of URL.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_urlslist <- file.path(testdata_dir, "urls_list.RDS")
  test_fastalist <- file.path(testdata_dir, "fasta_list.RDS")
  u_list <- readRDS(test_urlslist)
  f_list <- readRDS(test_fastalist)
  expect_equal(
    get_fasta(weblist = u_list, coord_table = NULL, browser = "chrome"), f_list)
})

test_that("It works with firefox.", {
  testdata_dir <- file.path(system.file(paste0("extdata/testdata/"), package = "GENEscraping"))
  test_urlslist <- file.path(testdata_dir, "urls_list.RDS")
  test_fastalist <- file.path(testdata_dir, "fasta_list.RDS")
  u_list <- readRDS(test_urlslist)
  f_list <- readRDS(test_fastalist)
  expect_equal(
  get_fasta(weblist = u_list, coord_table = NULL, browser = "firefox"), f_list)

})
