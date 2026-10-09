# Test-only reuse. Production code and shipped reference datasets are unchanged.
# R's copy-on-modify semantics keep caller changes out of these cached inputs.
credit_test_tables <- local({
  cache <- new.env(parent = emptyenv())
  function(profile = "MID_SIZE_UNIVERSAL") {
    if (!exists(profile, envir = cache, inherits = FALSE)) {
      tables <- official_snapshot(generate_synthetic_tables(
        bank_profile = profile, seed = 5752026),
        as_of_date = as.Date("2026-08-31"),
        knowledge_time = as.POSIXct("2026-08-31 23:59:59", tz = "UTC"))
      # These regressions concern EXP-000001. Keep its linked credit records,
      # while retaining the real public validation, engines and capital chain.
      for (name in names(tables)) {
        frame <- tables[[name]]
        if ("exposure_id" %in% names(frame)) {
          tables[[name]] <- frame[!is.na(frame$exposure_id) &
            frame$exposure_id == "EXP-000001", , drop = FALSE]
        }
      }
      # All currency/scenario paths still execute, with one cashflow per currency.
      # Full-size IRRBB/ICAAP numerical references remain in test-e2e.R.
      tables$cashflow <- tables$cashflow[
        !duplicated(tables$cashflow$currency), , drop = FALSE]
      assign(profile, tables, envir = cache)
    }
    get(profile, envir = cache, inherits = FALSE)
  }
})

full_reference_result <- local({
  cache <- new.env(parent = emptyenv())
  function(profile) {
    if (!exists(profile, envir = cache, inherits = FALSE)) {
      result <- calculate_tables(generate_synthetic_tables(bank_profile = profile),
        run_id = paste0("TEST-", profile))
      assign(profile, result, envir = cache)
    }
    get(profile, envir = cache, inherits = FALSE)
  }
})
