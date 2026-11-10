# Estimates and contrasts of fixed (and random) effects

`vlm_estimate()` gives estimates of linear combinations
\\\mathbf{l}^{\top}\boldsymbol{\beta}\\ (the ESTIMATE statement of SAS
PROC MIXED), optionally including random effects
\\\mathbf{k}^{\top}\mathbf{u}\\ (the narrow or intermediate inference
space). `vlm_contrast()` gives F tests of sets of linear combinations
\\\mathbf{L}\boldsymbol{\beta} = \mathbf{0}\\ (the CONTRAST statement).

## Usage

``` r
vlm_estimate(fit, L, random = NULL, level = 0.95)

# Default S3 method
vlm_estimate(fit, L, random = NULL, level = 0.95)

vlm_contrast(fit, L)

# Default S3 method
vlm_contrast(fit, L)
```

## Arguments

- fit:

  a result of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md).

- L:

  for `vlm_estimate()`: a named list of estimates, each a named list of
  effect coefficients (such as
  `list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))`) or a
  numeric vector over all columns of the solution. For `vlm_contrast()`:
  a named list of contrasts, each one such row or a list of rows.

- random:

  optional named list (names as in `L`) of random-effect coefficients
  for the narrow inference space: each a named list of random effects
  (as in the `effect` column of
  [`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md))
  with coefficients over their levels.

- level:

  confidence level (default 0.95).

## Value

A list of class `c("vlm_estimate", "vlm_result", "list")` with
`estimates` (label, estimate, standard error, df, t, p, confidence
limits and inference space) and `L`; or of class
`c("vlm_contrast", "vlm_result", "list")` with `contrasts` (label,
numerator and denominator df, F and p).

## Details

Coefficients are given per effect as in SAS, in the order of the levels
in the solution table (`fit$fixed`); missing trailing coefficients are
zero. The variance of an estimate is
\\\mathbf{l}^{\top}\mathbf{C}\_{11}\mathbf{l} +
2\mathbf{l}^{\top}\mathbf{C}\_{12}\mathbf{k} +
\mathbf{k}^{\top}\mathbf{C}\_{22}\mathbf{k}\\, where \\\mathbf{C}\_{11}
= (\mathbf{X}^{\top}\mathbf{V}^{-1} \mathbf{X})^{-}\\,
\\\mathbf{C}\_{12} =
-\mathbf{C}\_{11}\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{Z}\mathbf{G}\\
and \\\mathbf{C}\_{22} = \mathbf{G} -
\mathbf{G}\mathbf{Z}^{\top}\mathbf{P}\mathbf{Z}\mathbf{G}\\ (Henderson's
mixed model equations). The F statistic of a contrast is \$\$F =
\frac{(\mathbf{L}\widehat{\boldsymbol{\beta}})^{\top}(\mathbf{L}\mathbf{C}\_{11}\mathbf{L}^{\top})^{-1}
(\mathbf{L}\widehat{\boldsymbol{\beta}})}{\mathrm{rank}(\mathbf{L})},\$\$
with the denominator degrees of freedom of the fit. Rows that are not
estimable give `NA`.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Sections 2.5 and
2.6.

McLean, R. A., Sanders, W. L. and Stroup, W. W. (1991). A unified
approach to mixed linear models. *The American Statistician*, 45, 54-64.

## See also

[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

Other VetResearchLMM inference:
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md),
[`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md)

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
# Example 2.5.3.1: ESTIMATE statements (levels: Drug BERENIL samorin, dose h l)
es <-
  vlm_estimate(
      fit    = fm
    , L      = list(
          "drug dif"     = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
        , "Samorin mean" = list(Intercept = 1, Drug = c(0, 1),
                                dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
        , "Samorin HvsL" = list(dose = c(1, -1), "Drug:dose" = c(0, 0, 1, -1))
        , "Samorin high" = list(Intercept = 1, Drug = c(0, 1),
                                dose = c(1, 0), "Drug:dose" = c(0, 0, 1, 0))
        )
    , random = NULL
    , level  = 0.95
    )
es
#> Estimates (denominator df: satterth)
#> 
#> Estimates
#>         label estimate     se    df      t        p  lower  upper space
#>      drug dif   -5.558 0.6917 5.000 -8.036 0.000483 -7.336 -3.780 broad
#>  Samorin mean    19.31  1.048 6.205  18.43  < 1e-04  16.77  21.85 broad
#>  Samorin HvsL    4.350 0.8359 10.00  5.204 0.000399  2.487  6.213 broad
#>  Samorin high    21.48  1.128 8.208  19.05  < 1e-04  18.89  24.07 broad
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).

# Example 2.6.1: CONTRAST statements
ct <-
  vlm_contrast(
      fit = fm
    , L   = list(
          "drug dif" = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
        , "all"      = list(
              list(Drug = c(1, -1), "Drug:dose" = c(0.5, 0.5, -0.5, -0.5))
            , list(dose = c(1, -1), "Drug:dose" = c(0.5, -0.5, 0.5, -0.5))
            , list("Drug:dose" = c(0.5, -0.5, -0.5, 0.5))
            )
        )
    )
ct
#> Contrasts (denominator df: satterth)
#> 
#> Contrasts
#>     label num_df den_df     F        p
#>  drug dif      1  5.000 64.58 0.000483
#>       all      3  7.143 31.20 0.000179
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
```
