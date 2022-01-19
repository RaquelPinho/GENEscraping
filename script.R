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
devtools::document()
devtools::load_all()
devtools::check()
lintr::lint_package()
styler::style_file("R/get_fasta.R")
usethis::use_git()
devtools::document()
devtools::check()
