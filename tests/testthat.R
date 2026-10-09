library(testthat)
library(riskweightedassets)

# Emit per-file progress, so a stopped process leaves actionable diagnostics.
# Failures still propagate through test_check(); no tests are filtered or skipped.
test_check("riskweightedassets", reporter = "summary")

