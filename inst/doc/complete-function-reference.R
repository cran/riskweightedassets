## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----supporting-factor-example------------------------------------------------
library(riskweightedassets)
factor <- sme_supporting_factor(5000000)
irb_risk_weighted_assets(1000000, 0.08, sme_factor = factor,
                        infrastructure_factor = infrastructure_supporting_factor())

## ----eval=FALSE---------------------------------------------------------------
# library(riskweightedassets)
# 
# tables <- generate_synthetic_tables(bank_profile = "KSA_BANK")
# overrides <- data.frame(
#   parameter_key = "SA_RW",
#   dimension_1 = "CORPORATE",
#   dimension_2 = "UNRATED",
#   parameter_value = 0.40
# )
# 
# adjusted_tables <- override_regulatory_parameters(
#   tables,
#   overrides,
#   reason = "Approved sensitivity scenario SCN-2026-09",
#   approved_by = "Model Risk Committee decision 2026-09-14"
# )
# 
# result <- calculate_tables(adjusted_tables)
# 
# rwa_summary(result)
# failed_controls(result)
# parameter_overrides(result)
# analyze_credit_risk(result)

