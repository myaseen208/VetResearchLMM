test_that("Example 2.2.1.7 reproduces the book ANOVA targets", {
  data(ex121, package = "VetResearchLMM")

  model <- stats::aov(PCVdiff ~ dose, data = ex121)
  anova_table <- stats::anova(model)

  expect_equal(anova_table[["Sum Sq"]][1L], 80.73, tolerance = 0.01)
  expect_equal(anova_table[["Sum Sq"]][2L], 30.91, tolerance = 0.01)
  expect_equal(anova_table[["Mean Sq"]][1L], 40.36, tolerance = 0.01)
  expect_equal(anova_table[["Mean Sq"]][2L], 2.81, tolerance = 0.01)
  expect_equal(anova_table[["F value"]][1L], 14.36, tolerance = 0.01)
})

test_that("Example 2.4.2.2 reproduces readable variance components", {
  testthat::skip_if_not_installed("lme4")
  data(ex125, package = "VetResearchLMM")

  ml_model <- lme4::lmer(
    Pcv ~ dose * Drug + (1L | Region / Drug),
    data = ex125,
    REML = FALSE
  )
  reml_model <- lme4::lmer(
    Pcv ~ dose * Drug + (1L | Region / Drug),
    data = ex125,
    REML = TRUE
  )

  ml_vc <- stats::setNames(
    as.data.frame(lme4::VarCorr(ml_model))[["vcov"]],
    as.data.frame(lme4::VarCorr(ml_model))[["grp"]]
  )
  reml_vc <- stats::setNames(
    as.data.frame(lme4::VarCorr(reml_model))[["vcov"]],
    as.data.frame(lme4::VarCorr(reml_model))[["grp"]]
  )

  expect_equal(unname(ml_vc["Region"]), 4.292, tolerance = 0.001)
  expect_equal(unname(ml_vc["Drug:Region"]), 0.322, tolerance = 0.002)
  expect_equal(unname(ml_vc["Residual"]), 1.747, tolerance = 0.001)
  expect_equal(unname(reml_vc["Region"]), 5.151, tolerance = 0.001)
  expect_equal(unname(reml_vc["Drug:Region"]), 0.387, tolerance = 0.001)
  expect_equal(unname(reml_vc["Residual"]), 2.096, tolerance = 0.001)
})

test_that("Example 2.4.3.1 reproduces readable BLUP targets", {
  testthat::skip_if_not_installed("lme4")
  data(ex127, package = "VetResearchLMM")

  model <- lme4::lmer(Ww ~ 1L + (1L | sire), data = ex127, REML = TRUE)
  vc <- stats::setNames(
    as.data.frame(lme4::VarCorr(model))[["vcov"]],
    as.data.frame(lme4::VarCorr(model))[["grp"]]
  )
  sire_blups <- lme4::ranef(model)[["sire"]][["(Intercept)"]]

  expect_equal(unname(lme4::fixef(model)[["(Intercept)"]]), 13.97, tolerance = 0.01)
  expect_equal(unname(vc["sire"]), 3.685, tolerance = 0.001)
  expect_equal(unname(vc["Residual"]), 3.542, tolerance = 0.001)
  expect_equal(sire_blups[4L], 3.16, tolerance = 0.01)
})

test_that("Example 2.5.1.1 reproduces readable fixed-effect estimates", {
  testthat::skip_if_not_installed("lme4")
  data(ex125, package = "VetResearchLMM")

  model <- lme4::lmer(
    Pcv ~ dose * Drug + (1L | Region / Drug),
    data = ex125,
    REML = TRUE,
    contrasts = list(dose = "contr.SAS", Drug = "contr.SAS")
  )
  fixed_effects <- lme4::fixef(model)

  expect_equal(unname(fixed_effects["(Intercept)"]), 17.13, tolerance = 0.01)
  expect_equal(unname(fixed_effects["DrugBERENIL"]), 7.15, tolerance = 0.01)
  expect_equal(unname(fixed_effects["doseh"]), 4.35, tolerance = 0.01)
  expect_equal(unname(fixed_effects["doseh:DrugBERENIL"]), -3.18, tolerance = 0.01)
})

test_that("Example 2.6.1 reproduces the readable contrast estimate", {
  testthat::skip_if_not_installed("lmerTest")
  data(ex125, package = "VetResearchLMM")

  model <- lmerTest::lmer(
    Pcv ~ dose * Drug + (1L | Region / Drug),
    data = ex125,
    REML = TRUE,
    contrasts = list(dose = "contr.SAS", Drug = "contr.SAS")
  )
  contrast <- matrix(
    c(0, 0, -1, -0.5),
    ncol = 4L,
    dimnames = list("drug_difference", rownames(summary(model)$coef))
  )
  result <- lmerTest::contest(model, contrast, joint = FALSE)

  expect_equal(result[["Estimate"]][1L], -5.55, tolerance = 0.01)
  expect_equal(result[["Std. Error"]][1L]^2, 0.478, tolerance = 0.001)
})
