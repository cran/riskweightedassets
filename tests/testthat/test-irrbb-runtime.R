irrbb_runtime_fixture <- function() {
  t <- credit_test_tables("KSA_BANK")
  cf <- t$cashflow[rep(1L, 10L), , drop = FALSE]
  cf$currency <- rep(c("EUR", "USD"), 5L)
  # Repeated and distinct maturities; expired flows; past/future repricing;
  # both signs, a missing sign and missing amount components.
  cf$payment_date <- as.Date("2026-08-31") + c(180, 180, 180, 730, 730, 1095, 365, 365, 0, -10)
  cf$repricing_date <- as.Date("2026-08-31") + c(-10, 0, 100, 400, 365, 180, 730, 1, 0, 0)
  cf$principal_amount <- c(1e6, 2e6, 3e6, 1.5e6, NA, 2.5e6, 4e6, 1e6, 1e9, 1e9)
  cf$interest_amount <- c(100, 200, NA, 400, 500, 600, 700, 800, 0, 0)
  cf$fee_margin_amount <- c(0, NA, 30, 40, 50, 60, 70, 80, 0, 0)
  cf$sign <- c(1, -1, -1, 1, 1, NA, -1, 1, 1, 1)
  rownames(cf) <- NULL
  t$cashflow <- cf
  curve <- t$yield_curve[rep(1L, 6L), , drop = FALSE]
  curve$currency <- rep(c("EUR", "USD"), each = 3L)
  curve$tenor_years <- rep(c(5, .25, 1), 2L) # deliberately unsorted
  curve$zero_rate <- c(.01, -.03, -.01, .04, .02, .03)
  t$yield_curve <- curve
  scenarios <- t$irrbb_scenario
  t$irrbb_scenario <- do.call(rbind, lapply(c("EUR", "USD", "GBP"), function(currency) {
    rows <- scenarios; rows$currency <- currency; rows
  }))
  t
}

run_irrbb_runtime_case <- function(t, scalar = FALSE) {
  p <- rwa_internal("new_parameter_store")(t$regulatory_parameter)
  ctx <- rwa_internal("new_calculation_context")(
    as.Date("2026-08-31"), as.POSIXct("2026-08-31 23:59:59", tz = "UTC"),
    "CRR3-EU-2026", p, "EUR", "LEGACY", .55)
  out <- rwa_internal("new_calculation_bundle")()
  out$metrics$TIER1 <- 1e6
  evaluator <- if (scalar) irrbb_scalar_reference else rwa_internal("calculate_irrbb")
  evaluator(t, ctx, out)
  list(results = out$results, metrics = out$metrics, controls = out$controls)
}

test_that("prepared IRRBB curves preserve scalar results and parameter overrides", {
  t <- irrbb_runtime_fixture()
  before <- t
  expected <- run_irrbb_runtime_case(t, scalar = TRUE)
  actual <- run_irrbb_runtime_case(t)
  expect_equal(actual, expected, tolerance = 1e-12)
  expect_identical(t, before)
  expect_equal(nrow(actual$results$IRRBB_Currency_Scenarios), 12L)
  expect_setequal(actual$results$IRRBB_Currency_Scenarios$currency, c("EUR", "USD"))
  # No cross-run cache: changed curve and governed parameters must take effect.
  changed <- t
  changed$yield_curve$zero_rate <- changed$yield_curve$zero_rate + .004
  mask <- changed$regulatory_parameter$parameter_key == "IRRBB_SHOCK" &
    changed$regulatory_parameter$dimension_1 == "DECAY_YEARS"
  changed$regulatory_parameter$parameter_value[mask] <- 2
  mask <- changed$regulatory_parameter$parameter_key == "IRRBB_FLOOR" &
    changed$regulatory_parameter$dimension_1 == "BASE"
  changed$regulatory_parameter$parameter_value[mask] <- -.02
  revised <- run_irrbb_runtime_case(changed)
  expect_equal(revised, run_irrbb_runtime_case(changed, scalar = TRUE), tolerance = 1e-12)
  expect_false(isTRUE(all.equal(revised, actual)))
  expect_equal(run_irrbb_runtime_case(t), actual, tolerance = 1e-12)
})

test_that("IRRBB preparation preserves missing-curve and missing-parameter errors", {
  t <- irrbb_runtime_fixture()
  missing_curve <- t
  missing_curve$yield_curve <- t$yield_curve[t$yield_curve$currency != "USD", , drop = FALSE]
  expect_error(run_irrbb_runtime_case(missing_curve), "yield curve missing for USD")
  expect_error(run_irrbb_runtime_case(missing_curve, scalar = TRUE), "yield curve missing for USD")
  missing_parameter <- t
  keep <- !(t$regulatory_parameter$parameter_key == "IRRBB_FLOOR" &
    t$regulatory_parameter$dimension_1 == "BASE")
  missing_parameter$regulatory_parameter <- t$regulatory_parameter[keep, , drop = FALSE]
  expect_error(run_irrbb_runtime_case(missing_parameter), "Required regulatory parameter is missing")
  expect_error(run_irrbb_runtime_case(missing_parameter, scalar = TRUE), "Required regulatory parameter is missing")
})
