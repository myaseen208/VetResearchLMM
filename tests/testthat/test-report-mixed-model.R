test_that("report_mixed_model validates its model argument", {
  expect_error(
    report_mixed_model(NULL),
    "`model` must be a fitted model object.",
    fixed = TRUE
  )
})

test_that("report_mixed_model reports a clear optional dependency error", {
  if (requireNamespace("report", quietly = TRUE)) {
    skip("report is installed; optional dependency error path is not applicable")
  }

  fit <- stats::lm(mpg ~ wt, data = mtcars)
  expect_error(
    report_mixed_model(fit),
    "The optional package `report` is required.",
    fixed = TRUE
  )
})

test_that("report_mixed_model delegates to report when available", {
  skip_if_not_installed("report")
  skip_if_not_installed("lme4")

  data(ex127, package = "VetResearchLMM")
  fit <- lme4::lmer(Ww ~ 1 + (1 | sire), data = ex127, REML = TRUE)
  model_report <- report_mixed_model(fit)

  expect_true(inherits(model_report, "report"))
})
