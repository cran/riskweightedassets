## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
library(riskweightedassets)
list_reference_profiles()

## -----------------------------------------------------------------------------
tables <- generate_synthetic_tables(bank_profile = "KSA_BANK")
length(tables)
names(tables)[1:12]

## ----eval=FALSE---------------------------------------------------------------
#  result <- calculate_tables(tables)
#  print(result)
#  unlist(result$metrics[c("RWEA_KSA", "TREA", "CET1_RATIO")])

## ----eval=FALSE---------------------------------------------------------------
#  dataset <- generate_synthetic_dataset(
#    file.path(tempdir(), "rwa-runs"), bank_profile = "KSA_BANK"
#  )
#  validate_dataset(dataset)
#  result <- calculate_dataset(dataset)

