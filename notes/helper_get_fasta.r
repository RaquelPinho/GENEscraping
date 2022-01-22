# helper_tag_fasta.R
target_vec <- c("ACACCTCAAAAGGTCTGGAGGGT","GCACCTCACAGGGTCTTGGAAGG", "GCACCTC-AGAGATCTTGGAGGG")
target_dt <- coord_dataframe %>%
               dplyr::mutate(target = c("ACACCTCAAAAGGTCTGGAGGGT","GCACCTCACAGGGTCTTGGAAGG", "GCACCTC-AGAGATCTTGGAGGG"))
write.table(coord_dataframe, file = "./inst/extdata/testdata/coord_frame.csv", quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")
write.table(target_vec, file = "./inst/extdata/testdata/target_vec.csv", quote = FALSE, row.names = FALSE, sep = ",", col.names = FALSE)
write.table(target_dt,  file = "./inst/extdata/testdata/target_dt.csv", quote = FALSE, row.names = FALSE, sep = ",", col.names = FALSE)
