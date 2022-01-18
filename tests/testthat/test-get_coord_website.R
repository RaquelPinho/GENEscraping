test_that("list of urls are created.", {
  expect_equal(
    get_coord_website(coord_table = tibble::tribble(
      ~Name, ~Chr, ~NCBI_ID, ~start, ~end,
      "target1", "chr1", "NC_010443.5", 39157405, 39157425,
      "target2", "chr16", "NC_010458.4", 27277933, 27277956,
      "target3", "chr3", "NC_010445.4", 46206427, 46206449
    ), flank_n = 250),
    list(
      target1 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010443.5?report=fasta&from=39157155&to=39157675",
      target2 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010458.4?report=fasta&from=27277683&to=27278206",
      target3 = "https://www.ncbi.nlm.nih.gov/nuccore/NC_010445.4?report=fasta&from=46206177&to=46206699"
    )
  )
})
