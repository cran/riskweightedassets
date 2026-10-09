# riskweightedassets

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/rds0001/risk-weighted-assets-r/blob/main/LICENSE)
[![R package](https://img.shields.io/badge/R-%3E%3D4.1-blue.svg)](DESCRIPTION)

`riskweightedassets` is the R implementation of the RiskDataScience GmbH
reference engine for CRR III risk-weighted assets, regulatory capital, IRRBB
and ICAAP. It provides a stable R API, canonical Excel contracts, realistic
synthetic portfolios, bitemporal snapshots, deterministic lineage and
reconciliation controls. No Python runtime is required.

The package is intended for research, education, prototyping and independent
model validation. It is not legal, supervisory, accounting or investment
advice and is not a certified regulatory reporting system.

## Functional scope

- credit risk under the Standardised and IRB Approaches, CRM and output floor;
- counterparty credit risk, SFT, CCP, securitisation, CVA and crypto exposures;
- settlement, large exposures, legacy market risk, parallel FRTB and operational risk;
- own funds, buffers, leverage, MREL/TLAC and capital headroom;
- IRRBB/CSRBB and ICAAP economic and normative perspectives;
- 68 canonical input tables in 16 workbooks and 34 structured result tables;
- applied and fully-loaded views from the same official snapshot;
- two complete synthetic bank profiles and Python 1.0.0 golden-master parity.

## Credit supporting factors

The IRB path now applies explicitly eligible SME and infrastructure supporting
factors without changing K or expected loss. SA and IRB attestations are
independent; factors feed each output-floor path exactly once. Four new public
formula functions expose the arithmetic. Historical SA reductions without
eligibility evidence remain reproducible but produce an explicit warning.

After installation, see `vignette("supporting-factors", package = "riskweightedassets")`
and [the supporting-factor guide](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/SUPPORTING_FACTORS.md).
The complete-function-reference vignette covers all 77 exports.

## Installation

To test the 1.2.4 update candidate before CRAN publication, install its source package:

```r
install.packages("riskweightedassets_1.2.4.tar.gz", repos = NULL, type = "source")
```

Install the currently published CRAN version with the following command. It installs
1.2.4 only after CRAN has accepted and published this update:

```r
install.packages("riskweightedassets")
```

## First in-memory calculation

```r
library(riskweightedassets)

tables <- generate_synthetic_tables(bank_profile = "MID_SIZE_UNIVERSAL")
result <- calculate_tables(tables)
print(result)
result$metrics[c("RWEA_KSA", "RWEA_IRB", "TREA", "CET1_RATIO")]
```

## Granular analyst API

The package exposes 77 documented public functions. Analysts can calculate an
individual formula, inspect or override a regulatory weight, extract one
result table, compare applied and fully-loaded metrics, or obtain a focused
risk-domain analysis without using private package internals.

```r
sa_exposure_value(100, 2, committed_undrawn = 40, annex_i_class = "CLASS_2")
irb_capital_requirement(.01, .45, .20, 2.5)

tables <- generate_synthetic_tables(bank_profile = "KSA_BANK")
override <- data.frame(
  parameter_key = "RWA_MULTIPLIER", dimension_1 = "PILLAR1",
  dimension_2 = "", parameter_value = 13
)
scenario_tables <- override_regulatory_parameters(
  tables, override, reason = "Sensitivity analysis", approved_by = "Model Risk"
)
parameter_overrides(scenario_tables)
```

See the [bank-analyst API map](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/ANALYST_API.md) for the complete functional
inventory and governance rules.

## Excel workflow

All writes go to a destination selected by the caller. Package resources are
immutable.

```r
root <- file.path(tempdir(), "rwa-runs")
dataset <- generate_synthetic_dataset(
  root,
  as_of = as.Date("2026-08-31"),
  version = "v1.0.0",
  bank_profile = "KSA_BANK"
)
validation <- validate_dataset(dataset)
result <- calculate_dataset(dataset)
result$output_files
```

`calculate_dataset()` writes six output workbooks and a machine-readable run
manifest below `outputs/<deterministic-run-id>/`. For integration without
spreadsheets, `calculate_tables()` accepts and returns ordinary R objects.

## Synthetic data and external-source boundary

The package contains synthetic data only. It contains neither customer data
nor downloaded regulations, standards, PDFs or other third-party publications.
`regulatory_sources()` returns official URLs and archival SHA-256 values; the
documents remain outside the distribution.

## Documentation

- [documentation map](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/README.md)
- [complete standalone documentation](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/RISKWEIGHTEDASSETS_COMPLETE_DOCUMENTATION.md)
- [generated R function reference manual](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/riskweightedassets-reference.pdf)
- [public R API](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/API.md)
- [bank-analyst API map](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/ANALYST_API.md)
- complete installed API vignette: `vignette("complete-function-reference",
  package = "riskweightedassets")`
- [architecture](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/ARCHITECTURE.md)
- [data model](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/DATA_MODEL.md)
- [Pillar 1 and capital methodology](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/METHODOLOGY.md)
- [governance, controls and acceptance](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/GOVERNANCE_CONTROLS.md)
- [reference profiles and testing](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/REFERENCE_PROFILES_TESTING.md)
- [regulatory source catalogue](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/REGULATORY_SOURCES.md)
- [installation and CRAN release](https://github.com/rds0001/risk-weighted-assets-r/blob/main/docs/INSTALLATION_CRAN.md)

Online documentation describes the GitHub release. For this installed package's
exact API, use the bundled help pages and complete-function-reference vignette.

Within R, start with `help(package = "riskweightedassets")` and the vignettes:

```r
browseVignettes("riskweightedassets")
```

## License and legal information

Copyright © 2026 RiskDataScience GmbH. Original package content is licensed
under GNU GPL version 3. External publications remain subject to their own
rights and are not redistributed.

- [Legal and usage notice](inst/LEGAL.md)

The installed `LEGAL.md` notice contains the full imprint and privacy-policy
addresses. The package performs no telemetry and no automatic download.
