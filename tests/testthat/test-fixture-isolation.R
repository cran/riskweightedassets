test_that("targeted credit inputs remain independent and preserve scenario coverage", {
  original <- credit_test_tables()
  changed <- credit_test_tables()
  changed$exposure_lot$default_flag <- TRUE
  changed$cashflow$principal_amount <- 0
  expect_identical(credit_test_tables(), original)
  expect_identical(unique(as.character(original$exposure_lot$exposure_id)),
                   "EXP-000001")
  expect_equal(nrow(original$cashflow), length(unique(original$cashflow$currency)))
  expect_true(all(original$irrbb_scenario$currency %in% original$cashflow$currency))
})
