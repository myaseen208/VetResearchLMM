# Estimated marginal means for a fitted mixed model

Computes estimated marginal means, or pairwise comparisons of them, for
a fitted linear mixed model. For a model fitted by
[`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html),
[`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html) or
[`nlme::lme()`](https://rdrr.io/pkg/nlme/man/lme.html) the optional
package emmeans does the work, as in version 1.1.0; for a result of
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
the least-squares means of
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md)
are returned.

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

# Default S3 method
emmeans_mixed_model(
  model,
  specs,
  pairwise = FALSE,
  method = "pairwise",
  adjust = "tukey",
  ...
)

# S3 method for class 'vlm_fit'
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

  a fitted model: a result of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
  or a model from
  [`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html),
  [`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html) or
  [`nlme::lme()`](https://rdrr.io/pkg/nlme/man/lme.html).

- specs:

  specifications of the marginal means, such as `~ dose` or
  `~ dose | Drug`.

- pairwise:

  logical; `FALSE` returns the means, `TRUE` the contrasts (pairwise
  differences).

- method:

  contrast method passed to
  [`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
  (default `"pairwise"`); a `vlm_fit` result always uses pairwise
  differences.

- adjust:

  multiplicity adjustment (default `"tukey"`; `NULL` leaves it to
  emmeans).

- ...:

  further arguments passed to
  [`emmeans::emmeans()`](https://rvlenth.github.io/emmeans/reference/emmeans.html).

## Value

For a `vlm_fit` result, a `vlm_lsmeans` result (see
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md));
otherwise an `emmGrid` object of emmeans.

## Details

Estimated marginal means (least-squares means) average the model
predictions over the levels of the other factors with equal weights. For
a `vlm_fit` result, `specs` gives the effect (for example
`~ dose | Drug` or `~ Drug:dose`); `pairwise = TRUE` adds all pairwise
differences with the adjustment `adjust` (`"tukey"`, `"bonferroni"`,
`"sidak"` or `"none"`).

## References

Lenth, R. V. (2024). *emmeans: Estimated Marginal Means, aka
Least-Squares Means*. R package.

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`report_mixed_model`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)

Other VetResearchLMM inference:
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md),
[`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
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
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
emmeans_mixed_model(
    model    = fm
  , specs    = ~ dose | Drug
  , pairwise = TRUE
  , method   = "pairwise"
  , adjust   = "tukey"
  )
#> Least-squares means (denominator df: contain; 95% limits)
#> 
#> Least squares means
#>     Drug dose estimate    se df     t      p lower upper
#>  BERENIL    h    25.45 1.128 10 22.56 <1e-04 22.94 27.96
#>  BERENIL    l    24.28 1.128 10 21.53 <1e-04 21.77 26.80
#>  samorin    h    21.48 1.128 10 19.05 <1e-04 18.97 24.00
#>  samorin    l    17.13 1.128 10 15.19 <1e-04 14.62 19.65
#> 
#> Differences of least squares means (adjustment: tukey)
#>    level_1   level_2 estimate     se df     t        p p_adjusted   lower upper
#>  BERENIL h BERENIL l    1.167 0.8359 10 1.396 0.193041    0.52926  -1.391 3.724
#>  BERENIL h samorin h    3.967 0.9098 10 4.360 0.001422    0.00650   1.183 6.750
#>  BERENIL h samorin l    8.317 0.9098 10 9.141  < 1e-04    < 1e-04   5.533 11.10
#>  BERENIL l samorin h    2.800 0.9098 10 3.077 0.011691    0.04858 0.01648 5.584
#>  BERENIL l samorin l    7.150 0.9098 10 7.859  < 1e-04    < 1e-04   4.366 9.934
#>  samorin h samorin l    4.350 0.8359 10 5.204 0.000399    0.00188   1.793 6.907
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980); Kramer (1956). Full references: vlm_cite(x).
```
