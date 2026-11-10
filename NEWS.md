

# VetResearchLMM 2.0.0

## Changes visible to users

- The data sets `ex121`, `ex124`, `ex125`, `ex127`, `ex31`, `ex32` and
  `ex33`, the help topics `Examp1.3.2` to `Examp3.3`, and
  `emmeans_mixed_model()` and `report_mixed_model()` keep their names,
  columns and arguments.
- `emmeans_mixed_model()` and `report_mixed_model()` are S3 generics:
  their `.default` methods behave as in version 1.1.0 (models of
  **lme4** and **nlme**, through **emmeans** and **report**), and new
  methods accept results of `vlm_fit()`.
- The help topics `Examp*` now show the SAS program of the book next to
  the same analysis with the functions of the package, which reproduces
  the numbers the book prints; **lme4** remains as an optional
  comparison.
- The four vignettes of version 1.1.0 are replaced by six (getting
  started, theory, the examples of Chapters 1-2 and of Chapter 3,
  validation, application), each also as PDF.

## Corrections

- `ex33`: the 11th measurement of BO322 is on day 25 (not a second day
  23), that of ND66 on day 25 (not 26), and the identifier `"BO326 "`
  lost its trailing space, as in Appendix A of the book. With the
  corrected data the variance components of Example 3.3 are the printed
  5.478 and 4.965 (5.522 and 4.943 before), and the first-order
  autoregressive model gives the printed rho = 0.621.

## New

- `vlm_fit()`: an engine for linear mixed models that gives the results
  of SAS PROC MIXED: REML, ML or Type 3 (moment) estimation by
  average-information Newton steps with bounds; random variance
  components, random coefficients (`vlm_random()`, VC or UN) and
  residual structures (`vlm_repeated()`: CS, AR(1), SP(POW), UN); the
  solution for the fixed effects in the overparameterised coding; Type 3
  and Type 1 tests; containment, residual, between-within, Satterthwaite
  and Kenward-Roger degrees of freedom; standard errors of the
  covariance parameters; AIC, AICC, BIC, the SAS 6 criteria of the book
  and the null-model likelihood ratio test.
- `vlm_lsmeans()`: least-squares means at chosen covariate values, with
  Tukey-Kramer, Bonferroni and Sidak comparisons.
- `vlm_estimate()` and `vlm_contrast()`: ESTIMATE and CONTRAST
  statements with coefficients given per effect as in SAS, estimability
  checks, and the narrow inference space through random-effect
  coefficients.
- `vlm_blup()`: best linear unbiased predictions with standard errors of
  prediction.
- `vlm_ems()`: the analysis of variance of PROC GLM with a RANDOM
  statement: expected mean squares, synthesised error terms with
  Satterthwaite degrees of freedom and Type 3 estimates of the variance
  components.
- `vlm_compare()`: information criteria and likelihood ratio tests of
  several fits.
- `vlm_interpret()`, `vlm_cite()`, `vlm_notation()`, `vlm_reference()`,
  `plot()` and `autoplot()` methods, and `vlm_app()`, a shiny
  application in which every example of the book loads with one click.
- Data sets `ex122` (Example 1.2.2), `ex123` (Example 1.2.3) and `ex126`
  (Example 1.2.6) from Appendix A, and the help topic `Examp2.3.2` for
  the models of Section 2.3.2.
- 116 numbers printed in the book are recomputed by the tests
  (`inst/extdata/reference.csv`); 115 agree and the other is printed
  truncated. The engine is also checked against **lme4**, **lmerTest**,
  **pbkrtest**, **nlme** and **emmeans**.

## Package

- Imports **data.table**, **ggplot2** and **scales**; the packages used
  for comparisons are suggested.

# VetResearchLMM 1.1.0

- Package-level documentation, `report_mixed_model()` and
  `emmeans_mixed_model()`, Quarto vignettes and tests of the book
  examples.
