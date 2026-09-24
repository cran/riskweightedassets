## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
library(riskweightedassets)
tables <- generate_synthetic_tables()
head(tables$run_config[c("config_key", "config_value")])
head(tables$exposure_lot[c("record_id", "business_key", "valid_from",
                           "known_from", "is_official")])

## ----eval=FALSE---------------------------------------------------------------
#  report <- validate_dataset("path/to/dataset")
#  issues <- as.data.frame(report)
#  subset(issues, severity == "ERROR")

