# Linear Mixed Model Methodology

## 1 Model Form

The book presents linear mixed models in the form

\\ Y = X\beta + Zb + e, \\

where \\Y\\ is the response vector, \\X\\ is the fixed effect design
matrix, \\\beta\\ is the vector of fixed effect parameters, \\Z\\ is the
random effect design matrix, \\b\\ is the random effect vector, and
\\e\\ is the residual error. The usual assumptions are

\\ b \sim N(0, G), \quad e \sim N(0, R), \quad \operatorname{Cov}(b, e)
= 0. \\

The marginal variance is therefore

\\ V = ZGZ^T + R. \\

## 2 Fixed Effects

When variance components are known or estimated, generalized least
squares estimates the fixed effects as

\\ \hat{\beta} = (X^T V^{-1} X)^{-} X^T V^{-1}Y. \\

The generalized inverse is needed for overparameterized model
descriptions, which are common in the book because the SAS examples use
reference-level constraints.

## 3 Variance Components

Example 2.4.2.2 uses the `ex125` split-plot data. The book reports
maximum likelihood and restricted maximum likelihood variance component
estimates for region, herd within region and drug, and residual error.

``` r

if (requireNamespace("lme4", quietly = TRUE)) {
  fit_ml <- lme4::lmer(
    Pcv ~ dose * Drug + (1 | Region / Drug),
    data = ex125,
    REML = FALSE
  )
  if (requireNamespace("report", quietly = TRUE)) {
    report::report(fit_ml)
  }

  fit_reml <- lme4::lmer(
    Pcv ~ dose * Drug + (1 | Region / Drug),
    data = ex125,
    REML = TRUE
  )
  if (requireNamespace("report", quietly = TRUE)) {
    report::report(fit_reml)
  }

  data.frame(
    component = as.data.frame(lme4::VarCorr(fit_ml))$grp,
    ml = round(as.data.frame(lme4::VarCorr(fit_ml))$vcov, 3),
    reml = round(as.data.frame(lme4::VarCorr(fit_reml))$vcov, 3)
  )
}
```

        component    ml  reml
    1 Drug:Region 0.322 0.387
    2      Region 4.292 5.151
    3    Residual 1.747 2.096

These estimates match the readable printed table in the book to
rounding: `4.292`, `0.322`, and `1.747` for ML, and `5.151`, `0.387`,
and `2.096` for REML.

## 4 Reporting Fitted Models

The package keeps `report` optional, but fitted mixed models can be
interpreted with
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)
when the easystats reporting package is available. This reporting step
does not refit the model or change the estimates; it only turns the
fitted model object into a narrative summary. The helper wraps the same
guarded call to
[`report::report()`](https://easystats.github.io/report/reference/report.html).

``` r

if (requireNamespace("report", quietly = TRUE) && exists("fit_reml")) {
  report::report(fit_reml)
} else {
  data.frame(
    workflow = "Optional model report",
    requirement = "Install report to generate easystats-style summaries"
  )
}
```

    We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
    to predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model
    included Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)).
    The model's total explanatory power is substantial (conditional R2 = 0.89) and
    the part related to the fixed effects alone (marginal R2) is of 0.58. The
    model's intercept, corresponding to dose = h and Drug = BERENIL, is at 25.45
    (95% CI [23.07, 27.83], t(17) = 22.56, p < .001). Within this model:

      - The effect of dose [l] is statistically non-significant and negative (beta =
    -1.17, 95% CI [-2.93, 0.60], t(17) = -1.40, p = 0.181; Std. beta = -0.28, 95%
    CI [-0.70, 0.14])
      - The effect of Drug [samorin] is statistically significant and negative (beta
    = -3.97, 95% CI [-5.89, -2.05], t(17) = -4.36, p < .001; Std. beta = -0.95, 95%
    CI [-1.41, -0.49])
      - The effect of dose [l] × Drug [samorin] is statistically significant and
    negative (beta = -3.18, 95% CI [-5.68, -0.69], t(17) = -2.69, p = 0.015; Std.
    beta = -0.76, 95% CI [-1.36, -0.17])

    Standardized parameters were obtained by fitting the model on a standardized
    version of the dataset. 95% Confidence Intervals (CIs) and p-values were
    computed using a Wald t-distribution approximation.

## 5 Post Hoc Inference with emmeans

Model reports and marginal means answer different questions. A report
gives a narrative summary of the fitted model, while `emmeans` focuses
on model-based means and comparisons among scientifically meaningful
factor levels. The package helper
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md)
wraps this same guarded `emmeans` workflow for users who want a
package-level entry point.

``` r

if (requireNamespace("emmeans", quietly = TRUE) && exists("fit_reml")) {
  dose_emm <- emmeans::emmeans(
    fit_reml,
    ~ dose | Drug,
    lmer.df = "asymptotic"
  )
  dose_pairs <- emmeans::contrast(dose_emm, method = "pairwise")

  as.data.frame(dose_emm)
} else {
  data.frame(
    workflow = "Optional marginal means",
    requirement = "Install emmeans to compute post hoc model summaries"
  )
}
```

    Drug = BERENIL:
     dose   emmean       SE  df asymp.LCL asymp.UCL
     h    25.45000 1.127996 Inf  23.23917  27.66083
     l    24.28333 1.127996 Inf  22.07250  26.49416

    Drug = samorin:
     dose   emmean       SE  df asymp.LCL asymp.UCL
     h    21.48333 1.127996 Inf  19.27250  23.69417
     l    17.13333 1.127996 Inf  14.92250  19.34417

    Degrees-of-freedom method: asymptotic
    Confidence level used: 0.95 

``` r

if (exists("dose_pairs")) {
  as.data.frame(dose_pairs)
}
```

    Drug = BERENIL:
     contrast estimate       SE  df z.ratio p.value
     h - l    1.166667 0.835946 Inf   1.396  0.1628

    Drug = samorin:
     contrast estimate       SE  df z.ratio p.value
     h - l    4.350000 0.835946 Inf   5.204 <0.0001

    Degrees-of-freedom method: asymptotic 

The marginal means summarize model-predicted packed cell volume by dose
within drug. The pairwise contrasts then test the high-versus-low dose
difference within each drug group, which is a post hoc interpretation
layer rather than a replacement for the fitted mixed model.

## 6 Inference

Inference for fixed effects in mixed models depends on variance
component estimation and denominator degrees of freedom. The package
examples use `lmerTest` for Satterthwaite-style tests where the book
uses SAS `PROC MIXED`. Small numerical differences are expected across
software versions and methods, especially for degrees of freedom and
p-values.
