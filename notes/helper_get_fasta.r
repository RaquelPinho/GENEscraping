# helper_tag_fasta.R
coord_dataframe <- readRDS(file.path(testdata_dir, "coord_dataframe.RDS"))
fasta_list <- readRDS(file.path(testdata_dir,"fasta_list.RDS"))
target_vec <- c("ACACCTCAAAAGGTCTGGAGGGT","GCACCTCACAGGGTCTTGGAAGG", "GCACCTC-AGAGATCTTGGAGGG")
target_dt <- coord_dataframe %>%
               dplyr::mutate(target = c("ACACCTCAAAAGGTCTGGAGGGT","GCACCTCACAGGGTCTTGGAAGG", "GCACCTC-AGAGATCTTGGAGGG"))
write.table(coord_dataframe, file = "./inst/extdata/testdata/coord_frame.csv", quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")
write.table(target_vec, file = "./inst/extdata/testdata/target_vec.csv", quote = FALSE, row.names = FALSE, sep = ",", col.names = FALSE)
write.table(target_dt,  file = "./inst/extdata/testdata/target_dt.csv", quote = FALSE, row.names = FALSE, sep = ",", col.names = TRUE)
fasta_list_tagged <- tag_fasta(
      fasta_list = fasta_list,
      csv = "./inst/extdata/testdata/target_vec.csv",
      target = NULL
    )

saveRDS(fasta_list_tagged, file = "./inst/extdata/testdata/fasta_list_tagged.RDS")



