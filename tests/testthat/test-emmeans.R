test_that("emmeans_mixed_model validates required arguments", {
  expect_error(
    emmeans_mixed_model(NULL, ~ dose),
    "`model` must be a fitted model object.",
    fixed = TRUE
  )

  fit <- stats::lm(mpg ~ factor(cyl), data = mtcars)
  expect_error(
    emmeans_mixed_model(fit, NULL),
    "`specs` must be supplied.",
    fixed = TRUE
  )

  expect_error(
    emmeans_mixed_model(fit, ~ cyl, pairwise = NA),
    "`pairwise` must be a single TRUE or FALSE value.",
    fixed = TRUE
  )
})

test_that("emmeans_mixed_model reports a clear optional dependency error", {
  if (requireNamespace("emmeans", quietly = TRUE)) {
    skip("emmeans is installed; optional dependency error path is not applicable")
  }

  fit <- stats::lm(mpg ~ factor(cyl), data = mtcars)
  expect_error(
    emmeans_mixed_model(fit, ~ cyl),
    "The optional package `emmeans` is required.",
    fixed = TRUE
  )
})

test_that("emmeans_mixed_model returns marginal means for supported mixed models", {
  skip_if_not_installed("emmeans")
  skip_if_not_installed("lme4")

  data(ex125, package = "VetResearchLMM")
  fit <- lme4::lmer(
    Pcv ~ dose * Drug + (1 | Region / Drug),
    data = ex125,
    REML = TRUE
  )

  result <- emmeans_mixed_model(fit, ~ dose | Drug, lmer.df = "asymptotic")

  expect_true(inherits(result, "emmGrid"))
  result_df <- as.data.frame(result)
  expect_true(all(c("dose", "Drug", "emmean", "SE") %in% names(result_df)))
  expect_equal(nrow(result_df), 4L)
})

test_that("emmeans_mixed_model returns pairwise comparisons when requested", {
  skip_if_not_installed("emmeans")
  skip_if_not_installed("lme4")

  data(ex125, package = "VetResearchLMM")
  fit <- lme4::lmer(
    Pcv ~ dose * Drug + (1 | Region / Drug),
    data = ex125,
    REML = TRUE
  )

  result <- emmeans_mixed_model(
    fit,
    ~ dose | Drug,
    pairwise = TRUE,
    lmer.df = "asymptotic"
  )

  expect_true(inherits(result, "emmGrid"))
  result_df <- as.data.frame(result)
  expect_true(all(c("Drug", "contrast", "estimate", "SE") %in% names(result_df)))
  expect_equal(nrow(result_df), 2L)
})
