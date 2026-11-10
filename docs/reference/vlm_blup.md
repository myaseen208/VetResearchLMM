# Best linear unbiased predictions of the random effects

The predictions \\\widehat{\mathbf{u}} =
\widehat{\mathbf{G}}\mathbf{Z}^{\top}\widehat{\mathbf{V}}^{-1}
(\mathbf{y} - \mathbf{X}\widehat{\boldsymbol{\beta}})\\ of the random
effects of a fitted model, with the standard errors of prediction
\\\sqrt{\mathrm{diag}(\mathbf{C}\_{22})}\\, t tests and prediction
limits: the solution for random effects of SAS PROC MIXED.

## Usage

``` r
vlm_blup(fit, level = 0.95)

# Default S3 method
vlm_blup(fit, level = 0.95)
```

## Arguments

- fit:

  a result of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md).

- level:

  confidence level of the prediction limits (default 0.95).

## Value

A list of class `c("vlm_blup", "vlm_result", "list")` with `blup`
(effect, subject, level, prediction, standard error of prediction, df,
t, p and limits).

## Details

For a single random factor with \\n_i\\ observations on level \\i\\, the
prediction reduces to \$\$\widehat{s}\_i =
\frac{n_i\widehat{\sigma}\_s^2}{n_i\widehat{\sigma}\_s^2 +
\widehat{\sigma}^2} (\bar{y}\_{i\cdot} - \widehat{\mu}),\$\$ a shrinkage
of the level mean towards the overall mean (Example 2.4.3.1 of the
book). The degrees of freedom are the residual ones, or Satterthwaite
ones (numerical derivatives of the prediction-error variance) with
`ddfm = "satterth"` or `"kr"`.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Section 2.4.3.

Henderson, C. R. (1975). Best linear unbiased estimation and prediction
under a selection model. *Biometrics*, 31, 423-447.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

Other VetResearchLMM inference:
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md),
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# Example 2.4.3.1: PROC MIXED; CLASS sire; MODEL ww = ; RANDOM sire / SOLUTION;
fs <-
  vlm_fit(
      fixed    = Ww ~ 1
    , data     = ex127
    , random   = ~ sire
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
bl <-
  vlm_blup(
      fit   = fs
    , level = 0.95
    )
bl
#> Best linear unbiased predictions of the random effects
#> 
#> Solution for random effects
#>  effect level estimate     se df        t       p   lower   upper
#>    sire     1   -2.198  1.101 35   -1.997 0.05364  -4.432 0.03641
#>    sire     2 -0.03189 0.8983 35 -0.03550 0.97188  -1.855   1.792
#>    sire     3   -1.743  1.101 35   -1.584 0.12216  -3.978  0.4908
#>    sire     4    3.159 0.9589 35    3.294 0.00227   1.212   5.106
#>    sire     5   0.8692 0.9340 35   0.9306 0.35842  -1.027   2.765
#>    sire     6  -0.8628 0.9915 35  -0.8702 0.39013  -2.876   1.150
#>    sire     7    1.356  1.036 35    1.309 0.19922 -0.7475   3.459
#>    sire     8  -0.5476 0.9589 35  -0.5710 0.57162  -2.494   1.399
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Henderson (1975). Full
#> references: vlm_cite(x).
```
