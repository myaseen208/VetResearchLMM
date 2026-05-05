# Estimated Marginal Means for a Fitted Mixed Model

Compute estimated marginal means or pairwise comparisons for a fitted
linear mixed model using the optional emmeans package.

## Usage

``` r
emmeans_mixed_model(
  model,
  specs,
  pairwise = FALSE,
  method = "pairwise",
  adjust = "tukey",
  ...
)
```

## Arguments

- model:

  A fitted model object, typically from
  [`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html),
  [`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html), or
  [`nlme::lme()`](https://rdrr.io/pkg/nlme/man/lme.html).

- specs:

  Specifications for the marginal means, passed to
  [`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html);
  for example, `~ dose` or `~ dose | Drug`.

- pairwise:

  Logical. If `FALSE`, return the estimated marginal means. If `TRUE`,
  return contrasts computed from those marginal means.

- method:

  Contrast method passed to
  [`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
  when `pairwise = TRUE`. The default is `"pairwise"`.

- adjust:

  Multiplicity adjustment passed to
  [`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
  when `pairwise = TRUE`. The default is `"tukey"`. Use `NULL` to leave
  the adjustment unspecified.

- ...:

  Additional arguments passed to
  [`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html).

## Value

An `emmGrid` object from emmeans. With `pairwise = FALSE`, this contains
estimated marginal means. With `pairwise = TRUE`, this contains the
requested contrasts.

## Details

Estimated marginal means, also called least-squares means, summarize
model predictions for factor levels after accounting for the fitted
model structure. They are useful after mixed model fitting because
fixed-effect coefficients are often expressed relative to contrast
coding, while marginal means and their contrasts are closer to the
scientific comparisons shown in the book examples.

This helper complements
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md).
Use
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)
for narrative model interpretation and `emmeans_mixed_model()` for post
hoc inference, estimated marginal means, and pairwise comparisons.

The helper keeps emmeans optional. It does not refit the model or change
the estimates; it delegates marginal-mean calculations to
[`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html)
and, when requested, contrasts to
[`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html).

## References

Lenth, R. V. (2024). emmeans: Estimated Marginal Means, aka
Least-Squares Means. R package. See `utils::citation("emmeans")`.

Duchateau, L., Janssen, P., and Rowlands, G. J. (1998). *Linear Mixed
Models: An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute.

## See also

[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md),
[`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html),
[`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html).

## Examples

``` r
if (requireNamespace("lme4", quietly = TRUE) &&
    requireNamespace("emmeans", quietly = TRUE)) {
  data(ex125, package = "VetResearchLMM")
  fit <- lme4::lmer(
    Pcv ~ dose * Drug + (1 | Region / Drug),
    data = ex125,
    REML = TRUE
  )

  emmeans_mixed_model(fit, ~ dose | Drug, lmer.df = "asymptotic")
  emmeans_mixed_model(
    fit,
    ~ dose | Drug,
    pairwise = TRUE,
    lmer.df = "asymptotic"
  )
}
#> Drug = BERENIL:
#>  contrast estimate    SE  df z.ratio p.value
#>  h - l        1.17 0.836 Inf   1.396  0.1628
#> 
#> Drug = samorin:
#>  contrast estimate    SE  df z.ratio p.value
#>  h - l        4.35 0.836 Inf   5.204 <0.0001
#> 
#> Degrees-of-freedom method: asymptotic 
```
