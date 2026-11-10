# Least-squares means

Least-squares means (estimated marginal means) of a classification
effect of a fitted model, with their standard errors, degrees of freedom
and confidence limits, and optionally all pairwise differences with a
multiple comparison adjustment: the LSMEANS statement of SAS PROC MIXED.

## Usage

``` r
vlm_lsmeans(
  fit,
  specs,
  at = NULL,
  diff = FALSE,
  adjust = c("none", "tukey", "bonferroni", "sidak"),
  level = 0.95
)

# Default S3 method
vlm_lsmeans(
  fit,
  specs,
  at = NULL,
  diff = FALSE,
  adjust = c("none", "tukey", "bonferroni", "sidak"),
  level = 0.95
)
```

## Arguments

- fit:

  a result of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md).

- specs:

  the effect: a character string such as `"Drug:dose"` or a one-sided
  formula such as `~ Drug:dose` (all its variables must be
  classification variables of the fixed part).

- at:

  optional named list of covariate values (default: the means of the
  covariates).

- diff:

  logical; also give all pairwise differences (default `FALSE`).

- adjust:

  multiple comparison adjustment of the differences: `"none"`,
  `"tukey"`, `"bonferroni"` or `"sidak"`.

- level:

  confidence level (default 0.95).

## Value

A list of class `c("vlm_lsmeans", "vlm_result", "list")` with `lsmeans`,
`diffs` (`NULL` unless `diff = TRUE`) and `L` (the coefficient rows).

## Details

The least-squares mean of a level combination is
\\\mathbf{l}^{\top}\widehat{\boldsymbol{\beta}}\\, where \\\mathbf{l}\\
has 1 for the intercept and the matching levels, equal weights \\1/m\\
over the \\m\\ levels (or cells) of the other factors of each effect,
and the mean of each covariate (or the value in `at`) for covariate
columns. Its variance is \\\mathbf{l}^{\top}(\mathbf{X}^{\top}
\widehat{\mathbf{V}}^{-1}\mathbf{X})^{-}\mathbf{l}\\, the
broad-inference-space variance. Non-estimable means are returned as
`NA`. With `adjust = "tukey"`, p-values of the differences come from the
studentised range distribution (Tukey-Kramer), \\P(Q\_{k,\nu} \>
\sqrt{2}\|t\|)\\, and the confidence limits use
\\q\_{k,\nu}(1-\alpha)/\sqrt{2}\\.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Sections 2.5.2 and
3.3.

Searle, S. R., Speed, F. M. and Milliken, G. A. (1980). Population
marginal means in the linear model: an alternative to least squares
means. *The American Statistician*, 34, 216-221.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_estimate`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md)

Other VetResearchLMM inference:
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md),
[`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
fm <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
# Example 2.5.2.1: LSMEANS drug*dose
lm1 <-
  vlm_lsmeans(
      fit    = fm
    , specs  = ~ Drug:dose
    , at     = NULL
    , diff   = TRUE
    , adjust = "tukey"
    , level  = 0.95
    )
lm1
#> Least-squares means (denominator df: satterth; 95% limits)
#> 
#> Least squares means
#>     Drug dose estimate    se    df     t      p lower upper
#>  BERENIL    h    25.45 1.128 8.208 22.56 <1e-04 22.86 28.04
#>  BERENIL    l    24.28 1.128 8.208 21.53 <1e-04 21.69 26.87
#>  samorin    h    21.48 1.128 8.208 19.05 <1e-04 18.89 24.07
#>  samorin    l    17.13 1.128 8.208 15.19 <1e-04 14.54 19.72
#> 
#> Differences of least squares means (adjustment: tukey)
#>    level_1   level_2 estimate     se    df     t        p p_adjusted   lower
#>  BERENIL h BERENIL l    1.167 0.8359 10.00 1.396 0.193041    0.52926  -1.391
#>  BERENIL h samorin h    3.967 0.9098 11.82 4.360 0.000962    0.00459   1.259
#>  BERENIL h samorin l    8.317 0.9098 11.82 9.141  < 1e-04    < 1e-04   5.609
#>  BERENIL l samorin h    2.800 0.9098 11.82 3.077 0.009738    0.04197 0.09258
#>  BERENIL l samorin l    7.150 0.9098 11.82 7.859  < 1e-04    < 1e-04   4.443
#>  samorin h samorin l    4.350 0.8359 10.00 5.204 0.000399    0.00188   1.793
#>  upper
#>  3.724
#>  6.674
#>  11.02
#>  5.507
#>  9.857
#>  6.907
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980); Kramer (1956); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai
#> and Cornelius (1996). Full references: vlm_cite(x).
```
