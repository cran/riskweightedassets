## -----------------------------------------------------------------------------
library(riskweightedassets)
irb_capital_requirement(1, .4, .2, 2.5, defaulted = TRUE, elbe = .1,
                       lgd_treatment = "SUPERVISORY")
irb_capital_requirement(1, .4, .2, 2.5, defaulted = TRUE, elbe = .1,
                       lgd_treatment = "OWN_ESTIMATES")

