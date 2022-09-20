## Creating the GENEscraping package
create_package("D:/Raquel/Desktop/GENEscraping/")
## conventions:
# variables and functions will be snake_case
# lines will have up to 90 character
# I will use lintr::lint_package() and styler::style_file() to check the
# formatting.

### first function
# The first function will use genomic coordinates to get the NCBI website from
#the region.

## Create a function file
usethis::use_r("GetCoordWebsite")

## Create domumentation
devtools::document()
library(roxygen2)

## import package that will be used. Remeber to add it to the DESCRIPTION file
use_this::use_package("tibble")

## update documents
devtools::document()
usethis::use_mit_license()
usethis::use_pipe()
# this will add the %>%  to the imported functions

## load, check
devtools::load_all()
devtools::check()

## rename files because I changed convension
rename_files("GetCoordWebsite", "get_coord_website")
devtools::document()
usethis::use_r("get_coord_website")
usethis::use_package("utils")
usethis::use_git(message = "changed convetion and renamed function.")

## check formating
lintr::lint_package()
styler::style_file("R/get_coord_website.R")

## Make test
usethis::use_testthat()
usethis::use_test("get_coord_website")
devtools::document()
devtools::test()
lintr::lint_package()
styler::style_file("tests/testthat/test-get_coord_website.R")
devtools::load_all()
devtools::check()
usethis::use_git()

## Second function
# This function will get the fasta sequence from a list of URLs containing fasta
# information of genomic locus. For example the list resulting from a call of
# the get_coord_website function.
usethis::use_r("get_fasta")
usethis::use_package("RSelenium")
usethis::use_package("rvest")
usethis::use_package("xml2")
usethis::use_package("mgsub")
usethis::use_package("netstat")
devtools::document()
devtools::load_all()
devtools::check()
lintr::lint_package()
styler::style_file("R/get_fasta.R")
usethis::use_git()
devtools::document()
devtools::check()
## Making test
usethis::use_test("get_fasta")
testthat::test_file("./tests/testthat/test-get_fasta.R")
testthat::test_file("./tests/testthat/test-get_coord_website.R")


## Making the write_fasta function
# this function uses the `write.fasta` function of the tigger package
# an use a list of fasta sequences where each element of the list contain 2 elements.
# the first element is the tittle of the fasta sequence and the second is the sequence.
usethis::use_r("write_fasta")
usethis::use_package("tigger")
usethis::use_git("Added the get_fasta test and started the write_fasta function and test")
usethis::use_test("write_fasta")
usethis::use_git("make documents to write_fasta and test-write_fasta files")
devtools::document()
lintr::lint_package()
styler::style_file("./tests/testthat/test-write_fasta.R")
testthat::test_file("./tests/testthat/test-write_fasta.R")
usethis::use_git("added some tests for the write_fasta, some test data and the helper_snap function")
devtools::load_all()
devtools::check()


# making tag_fasta  function
# this will use a data.frame, .csv file or character vector  containig the target
# sequences in the sequence in the .fasta list to mark the middle of the target
# region in the sequence as well as check if the target region is in the sequence.
usethis::use_r("tag_fasta")
usethis::use_git("finished the write_fasta function and the tests.")
devtools::document()
usethis::use_package("stringr")
usethis::use_package("Biostrings")
usethis::use_test("tag_fasta")
lintr::lint_package()
styler::style_file("R/tag_fasta.R")
styler::style_file("tests/testthat/test-tag_fasta.R")
devtools::load_all()
testthat::test_file("tests/testthat/test-tag_fasta.R")
testthat::test_file("R/tag_fasta.R")
usethis::use_git("finished the tag_fasta function and its tests")


## Try to make a README file with usethis
usethis::use_readme_rmd()
devtools::build_readme()
