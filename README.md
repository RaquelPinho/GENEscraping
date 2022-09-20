
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GENEscraping

<!-- badges: start -->
<!-- badges: end -->

The goal of GENEscraping is to use web scraping to retrieve sequences
from genomic regions contained in a table of genomic coordinates in R
and write fasta files of the individual sequences or combine in one
file. There is also an option to write tags at the middle of the genomic
coordinates, on the fasta files to make it suitable for use in the
design of rhAmpSeq panel primer design. The web scraping functions use
[RSelenium](https://github.com/ropensci/RSelenium) to connect to web
drivers and retrive web sites information. **WARNING** It will use and
open automatically the internet browser chosen.

## Installation

You can install the development version of GENEscraping from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("RaquelPinho/GENEscraping")
```

## Example

This is a basic example of a genomic coordinate table that can be used
to retrieve the fasta sequences:

``` r
library(GENEscraping)
coord_table <- tibble::tribble(
                              ~Name, ~Chr, ~NCBI_ID, ~start, ~end,
                              "target1", "chr1", "NC_010443.5", 39157405, 39157425,
                              "target2", "chr16", "NC_010458.4", 27277933, 27277956,
                              "target3", "chr3", "NC_010445.4", 46206427, 46206449
                               )
knitr::kable(coord_table)
```

| Name    | Chr   | NCBI_ID     |    start |      end |
|:--------|:------|:------------|---------:|---------:|
| target1 | chr1  | NC_010443.5 | 39157405 | 39157425 |
| target2 | chr16 | NC_010458.4 | 27277933 | 27277956 |
| target3 | chr3  | NC_010445.4 | 46206427 | 46206449 |

In this example table, I am using regions of the porcine genome. To get
the list of websites containing the regions in the table you can use the
function `get_coord_website`. You can also choose if you want to
retrieve the regions as stated in the table or add n nucleotides
upstream and downstream of the regions present in the table. In the
example, 250 nts were added, flanking the regions on the coordinates.

``` r
weblist <- get_coord_website(coord_table = coord_table, flank_n = 250)
weblist
#> $target1
#> [1] "https://www.ncbi.nlm.nih.gov/nuccore/NC_010443.5?report=fasta&from=39157155&to=39157675"
#> 
#> $target2
#> [1] "https://www.ncbi.nlm.nih.gov/nuccore/NC_010458.4?report=fasta&from=27277683&to=27278206"
#> 
#> $target3
#> [1] "https://www.ncbi.nlm.nih.gov/nuccore/NC_010445.4?report=fasta&from=46206177&to=46206699"
```

After we have the urls for each of the coordinates, we can now collect
the fasta sequences. This function use RSelenium to open NCBI urls and
extract the fasta sequence from them. WARNING! It will automatically
open the browser chosen to retrieve the information. You can use the
code `binman::list_versions("chromedriver")` to know the most updated
version of chrome to use and update the chromever parameter of the
get_fasta function.

    #> [1] "Connecting to remote server"
    #> $acceptInsecureCerts
    #> [1] FALSE
    #> 
    #> $browserName
    #> [1] "chrome"
    #> 
    #> $browserVersion
    #> [1] "105.0.5195.102"
    #> 
    #> $chrome
    #> $chrome$chromedriverVersion
    #> [1] "105.0.5195.52 (412c95e518836d8a7d97250d62b29c2ae6a26a85-refs/branch-heads/5195@{#853})"
    #> 
    #> $chrome$userDataDir
    #> [1] "C:\\Users\\Raque\\AppData\\Local\\Temp\\scoped_dir3424_1071462490"
    #> 
    #> 
    #> $`goog:chromeOptions`
    #> $`goog:chromeOptions`$debuggerAddress
    #> [1] "localhost:61023"
    #> 
    #> 
    #> $networkConnectionEnabled
    #> [1] FALSE
    #> 
    #> $pageLoadStrategy
    #> [1] "normal"
    #> 
    #> $platformName
    #> [1] "windows"
    #> 
    #> $proxy
    #> named list()
    #> 
    #> $setWindowRect
    #> [1] TRUE
    #> 
    #> $strictFileInteractability
    #> [1] FALSE
    #> 
    #> $timeouts
    #> $timeouts$implicit
    #> [1] 0
    #> 
    #> $timeouts$pageLoad
    #> [1] 300000
    #> 
    #> $timeouts$script
    #> [1] 30000
    #> 
    #> 
    #> $unhandledPromptBehavior
    #> [1] "dismiss and notify"
    #> 
    #> $`webauthn:extension:credBlob`
    #> [1] TRUE
    #> 
    #> $`webauthn:extension:largeBlob`
    #> [1] TRUE
    #> 
    #> $`webauthn:virtualAuthenticators`
    #> [1] TRUE
    #> 
    #> $webdriver.remote.sessionid
    #> [1] "384397d835b392a451ac50e0748f52b3"
    #> 
    #> $id
    #> [1] "384397d835b392a451ac50e0748f52b3"
    #> [[1]]
    #> [[1]][[1]]
    #> [1] ">NC_010443.5:39157155-39157675 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 1, Sscrofa11.1, whole genome shotgun sequence target1"
    #> 
    #> [[1]][[2]]
    #> [1] "TGCGTTCATGACTCCAAGAGAAACCTTTGATGAGCACCAAATGTTAGACCTGTCCTTCCTGGATGTTTATAAAAATTTATCCTAGAATGTATGCATAATCTTATTCACTGATAAGATGGTTCAATGGGAAAAACAATATTATCGGAAGCCATCTCTTAAAATGGCTTACCAAGTATGCTAAATTGTTCAGTTTGTCCTAAACATAACCCTGGAAAATCCATCTGAAATTTCACAGGTTATTATTTTTTTTAACCCTCCAGACCTTTTGAGGTGTGGCAAATGGATTTTATTGAGGTGCCATCATCTCAAGGTTGTAAATATTTATTGATAACAATTTGTATGTTCTCTCATTGGTTGAAGGATTTTCCTTGTTACACAGCCATGGCCACAGCGGTACATAAAGTCTTTTTGAGAAAAGTTTTTCCTACTTGAGGAATACCCTCTGAATAATGACAGAGGTTCCCATTTTAGTCAATAAGTAATTTCAATCTGTTTGTAAAATCAGGCTTACTTTATAACAT"
    #> 
    #> 
    #> [[2]]
    #> [[2]][[1]]
    #> [1] ">NC_010458.4:27277683-27278206 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 16, Sscrofa11.1, whole genome shotgun sequence target2"
    #> 
    #> [[2]][[2]]
    #> [1] "AGGATAGTTTTGCTTCCTTGTCCCCCCTTTCTTCTGTCATTTGCCCAAATTCTACCTCTTGTCAAAGATAATGGTTCCTCCCTACCTCTGCTAACCTTTGGATTTTTAAAATGTTGCCAACAATGAAAGTGTATTTATAAAATTAATACATTTTAGAAATTTCCAATCACCAGATTAAAGGGACAGATGTGAACACAGCACTAACAGTGTAAATTATAAAGGACACTTAAACACGTATGCTCACCTTGCATCCTTCCAAGACCCTGTGAGGTGCCTGTGGTGGTCCTCTTTTGCACAGGAGGCATTGAGGTTAAGAGAATTTGAGAAGATTGTGGTATGTCACCCAACAAGGGGCAGAGCTAGAACTAGAACTCAGTCTGGCTGATGGAGAAGCCCCCATGTGTTCCTCTAACATGCTATGCTGCCTCCCAGCGATGGTGTATTCACTCCTTAGTAAGGCGTAAATAAAAACTTCCATAGTAAATAGTGTTCAGTTTTATGGTACTATAGACGTAGTAACATCA"
    #> 
    #> 
    #> [[3]]
    #> [[3]][[1]]
    #> [1] ">NC_010445.4:46206177-46206699 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 3, Sscrofa11.1, whole genome shotgun sequence target3"
    #> 
    #> [[3]][[2]]
    #> [1] "TTGGGGAGAGGGGAAGGGATCAGAGTGGAGAAGGAGGTGTAGATGCAGGAAGCCCCAAAAGCTACCATGCCGTGGGTCAGACTCACAGCCCCAGGACTCGCTCCAGCTTCTTCGCTACCACCTGGCCCAGGCGCCAGCCAACTGGGTCGCTGCCCTTCTCCAGCTACCTGGAGCCCCAAGCTCCCAGCTGGGAGGCCCCCGCAGGTCTTGTGTGTCTTTGGCTCCCTGGCTGTAGGGAAATATTTGTGTTCGCACCTCAGAGATCTTGGAGGGCAAAGCCAGGGCGAGTCTGTGTCTGGGCCACAGTTGATGCTGCTGGGGCCTGGGGAGTGTCCCCCTCCTGCATCAGGGCAGTGGGTCTGCACTCAGCAAGCTAGAAGGAGTCTTTGTTCTTTTTCCAGGCAGCACCCCCCCACACACACACACCACAGTCTGAGCTGCTAGTGATTCAAGGGTTGTTCTCTGAGGATCTGGATGCCCCTCCTGACATGGTGCTTTTGGAGCTGGGAGGGAGCCCAAAGGC"

Now that we have the fasta sequences, we can tag the fasta sequence at
target locations, for that a target sequence contained in the sequences
need to be provided. In this case we will tag the middle point of the
target. The tag is a duplication of the 2 nucleotides at the site:
AAATGGTCT\[TC/TC\]GATTAAT. In this case we will use a data.frame
containing the sequence at the genomic coordinates on coord_table:

``` r
target_table <- tibble::tribble(
                ~Name,~Chr,~NCBI_ID,~start,~end,~target,
                "target1","chr1","NC_010443.5",39157405,39157425,"ACACCTCAAAAGGTCTGGAGGGT",
                "target2","chr16","NC_010458.4",27277933,27277956,"GCACCTCACAGGGTCTTGGAAGG",
                "target3","chr3","NC_010445.4",46206427,46206449,"GCACCTC-AGAGATCTTGGAGGG"
)
target_table
#> # A tibble: 3 × 6
#>   Name    Chr   NCBI_ID        start      end target                 
#>   <chr>   <chr> <chr>          <dbl>    <dbl> <chr>                  
#> 1 target1 chr1  NC_010443.5 39157405 39157425 ACACCTCAAAAGGTCTGGAGGGT
#> 2 target2 chr16 NC_010458.4 27277933 27277956 GCACCTCACAGGGTCTTGGAAGG
#> 3 target3 chr3  NC_010445.4 46206427 46206449 GCACCTC-AGAGATCTTGGAGGG
```

We can use it to tag the lists in the fasta_list:

``` r
fasta_list_tagged <- tag_fasta(
                            fasta_list = fasta_list,
                            target = target_table,
                            tag_site = 4
                            )
fasta_list_tagged
#> [[1]]
#> [[1]][[1]]
#> [1] ">NC_010443.5:39157155-39157675 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 1, Sscrofa11.1, whole genome shotgun sequence target1"
#> 
#> [[1]][[2]]
#> [1] "TGCGTTCATGACTCCAAGAGAAACCTTTGATGAGCACCAAATGTTAGACCTGTCCTTCCTGGATGTTTATAAAAATTTATCCTAGAATGTATGCATAATCTTATTCACTGATAAGATGGTTCAATGGGAAAAACAATATTATCGGAAGCCATCTCTTAAAATGGCTTACCAAGTATGCTAAATTGTTCAGTTTGTCCTAAACATAACCCTGGAAAATCCATCTGAAATTTCACAGGTTATTATTTTTTTTAACCCTCCAGACCTTTTGAGGTGTGGCAAATGGATTTTATTGAGGTGCCATCATCTCAAGGTTGTAAATATTTATTGATAACAATTTGTATGTTCTCTCATTGGTTGAAGGATTTTCCTTGTTACACAGCCATGGCCACAGCGGTACATAAAGTCTTTTTGAGAAAAGTTTTTCCTACTTGAGGAATACCCTCTGAATAATGACAGAGGTTCCCATTTTAGTCAATAAGTAATTTCAATCTGTTTGTAAAATCAGGCTTACTTTATAACAT"
#> 
#> [[1]][[3]]
#> [1] "TGCGTTCATGACTCCAAGAGAAACCTTTGATGAGCACCAAATGTTAGACCTGTCCTTCCTGGATGTTTATAAAAATTTATCCTAGAATGTATGCATAATCTTATTCACTGATAAGATGGTTCAATGGGAAAAACAATATTATCGGAAGCCATCTCTTAAAATGGCTTACCAAGTATGCTAAATTGTTCAGTTTGTCCTAAACATAACCCTGGAAAATCCATCTGAAATTTCACAGGTTATTATTTTTTTTAACCCTCCAGACCTTTTGAG[GT/GT]GTGGCAAATGGATTTTATTGAGGTGCCATCATCTCAAGGTTGTAAATATTTATTGATAACAATTTGTATGTTCTCTCATTGGTTGAAGGATTTTCCTTGTTACACAGCCATGGCCACAGCGGTACATAAAGTCTTTTTGAGAAAAGTTTTTCCTACTTGAGGAATACCCTCTGAATAATGACAGAGGTTCCCATTTTAGTCAATAAGTAATTTCAATCTGTTTGTAAAATCAGGCTTACTTTATAACAT"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] ">NC_010458.4:27277683-27278206 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 16, Sscrofa11.1, whole genome shotgun sequence target2"
#> 
#> [[2]][[2]]
#> [1] "AGGATAGTTTTGCTTCCTTGTCCCCCCTTTCTTCTGTCATTTGCCCAAATTCTACCTCTTGTCAAAGATAATGGTTCCTCCCTACCTCTGCTAACCTTTGGATTTTTAAAATGTTGCCAACAATGAAAGTGTATTTATAAAATTAATACATTTTAGAAATTTCCAATCACCAGATTAAAGGGACAGATGTGAACACAGCACTAACAGTGTAAATTATAAAGGACACTTAAACACGTATGCTCACCTTGCATCCTTCCAAGACCCTGTGAGGTGCCTGTGGTGGTCCTCTTTTGCACAGGAGGCATTGAGGTTAAGAGAATTTGAGAAGATTGTGGTATGTCACCCAACAAGGGGCAGAGCTAGAACTAGAACTCAGTCTGGCTGATGGAGAAGCCCCCATGTGTTCCTCTAACATGCTATGCTGCCTCCCAGCGATGGTGTATTCACTCCTTAGTAAGGCGTAAATAAAAACTTCCATAGTAAATAGTGTTCAGTTTTATGGTACTATAGACGTAGTAACATCA"
#> 
#> [[2]][[3]]
#> [1] "AGGATAGTTTTGCTTCCTTGTCCCCCCTTTCTTCTGTCATTTGCCCAAATTCTACCTCTTGTCAAAGATAATGGTTCCTCCCTACCTCTGCTAACCTTTGGATTTTTAAAATGTTGCCAACAATGAAAGTGTATTTATAAAATTAATACATTTTAGAAATTTCCAATCACCAGATTAAAGGGACAGATGTGAACACAGCACTAACAGTGTAAATTATAAAGGACACTTAAACACGTATGCTCACCTTGCATCCTTCCAAGACCCTGTGAG[GT/GT]GCCTGTGGTGGTCCTCTTTTGCACAGGAGGCATTGAGGTTAAGAGAATTTGAGAAGATTGTGGTATGTCACCCAACAAGGGGCAGAGCTAGAACTAGAACTCAGTCTGGCTGATGGAGAAGCCCCCATGTGTTCCTCTAACATGCTATGCTGCCTCCCAGCGATGGTGTATTCACTCCTTAGTAAGGCGTAAATAAAAACTTCCATAGTAAATAGTGTTCAGTTTTATGGTACTATAGACGTAGTAACATCA"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] ">NC_010445.4:46206177-46206699 Sus scrofa isolate TJ Tabasco breed Duroc chromosome 3, Sscrofa11.1, whole genome shotgun sequence target3"
#> 
#> [[3]][[2]]
#> [1] "TTGGGGAGAGGGGAAGGGATCAGAGTGGAGAAGGAGGTGTAGATGCAGGAAGCCCCAAAAGCTACCATGCCGTGGGTCAGACTCACAGCCCCAGGACTCGCTCCAGCTTCTTCGCTACCACCTGGCCCAGGCGCCAGCCAACTGGGTCGCTGCCCTTCTCCAGCTACCTGGAGCCCCAAGCTCCCAGCTGGGAGGCCCCCGCAGGTCTTGTGTGTCTTTGGCTCCCTGGCTGTAGGGAAATATTTGTGTTCGCACCTCAGAGATCTTGGAGGGCAAAGCCAGGGCGAGTCTGTGTCTGGGCCACAGTTGATGCTGCTGGGGCCTGGGGAGTGTCCCCCTCCTGCATCAGGGCAGTGGGTCTGCACTCAGCAAGCTAGAAGGAGTCTTTGTTCTTTTTCCAGGCAGCACCCCCCCACACACACACACCACAGTCTGAGCTGCTAGTGATTCAAGGGTTGTTCTCTGAGGATCTGGATGCCCCTCCTGACATGGTGCTTTTGGAGCTGGGAGGGAGCCCAAAGGC"
#> 
#> [[3]][[3]]
#> [1] "TTGGGGAGAGGGGAAGGGATCAGAGTGGAGAAGGAGGTGTAGATGCAGGAAGCCCCAAAAGCTACCATGCCGTGGGTCAGACTCACAGCCCCAGGACTCGCTCCAGCTTCTTCGCTACCACCTGGCCCAGGCGCCAGCCAACTGGGTCGCTGCCCTTCTCCAGCTACCTGGAGCCCCAAGCTCCCAGCTGGGAGGCCCCCGCAGGTCTTGTGTGTCTTTGGCTCCCTGGCTGTAGGGAAATATTTGTGTTCGCAC[CT/CT]CAGAGATCTTGGAGGGCAAAGCCAGGGCGAGTCTGTGTCTGGGCCACAGTTGATGCTGCTGGGGCCTGGGGAGTGTCCCCCTCCTGCATCAGGGCAGTGGGTCTGCACTCAGCAAGCTAGAAGGAGTCTTTGTTCTTTTTCCAGGCAGCACCCCCCCACACACACACACCACAGTCTGAGCTGCTAGTGATTCAAGGGTTGTTCTCTGAGGATCTGGATGCCCCTCCTGACATGGTGCTTTTGGAGCTGGGAGGGAGCCCAAAGGC"
```

Independently on if the fasta_list is tagged or not you use it to write
fasta files using the function `write_fasta`.

``` r
# write_fasta(fasta_list = fasta_list, named = TRUE, contain_flag = TRUE,
#                        tagged = FALSE, combined = TRUE, path_to_file = path_to_file,
#                        width = 60, append = FALSE)
```
