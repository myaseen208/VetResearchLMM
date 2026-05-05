# Report a Fitted Mixed Model

Create an easystats-style narrative report for a fitted linear mixed
model.

## Usage

``` r
report_mixed_model(model, ...)
```

## Arguments

- model:

  A fitted model object, typically from
  [`lme4::lmer()`](https://rdrr.io/pkg/lme4/man/lmer.html),
  [`lmerTest::lmer()`](https://rdrr.io/pkg/lmerTest/man/lmer.html), or
  [`nlme::lme()`](https://rdrr.io/pkg/nlme/man/lme.html).

- ...:

  Additional arguments passed to
  [`report::report()`](https://easystats.github.io/report/reference/report.html).

## Value

A report object returned by
[`report::report()`](https://easystats.github.io/report/reference/report.html).

## Details

This helper keeps the report package optional. It checks that a fitted
model was supplied, verifies that report is installed, and then
delegates the model interpretation to
[`report::report()`](https://easystats.github.io/report/reference/report.html).
This provides a stable package-level entry point for readers who want
easystats-style interpretation of the fitted mixed models used
throughout the book examples.

The helper does not change the fitted model, refit the model, or alter
any estimates. It only formats and interprets the model object produced
by the modelling package.

## References

Duchateau, L., Janssen, P., and Rowlands, G. J. (1998). *Linear Mixed
Models: An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute.

See `utils::citation("report")` for the citation for the optional
easystats reporting package.

## See also

[`lme4::lmer`](https://rdrr.io/pkg/lme4/man/lmer.html),
[`nlme::lme`](https://rdrr.io/pkg/nlme/man/lme.html).

## Examples

``` r
if (requireNamespace("lme4", quietly = TRUE) &&
    requireNamespace("report", quietly = TRUE)) {
  data(ex127, package = "VetResearchLMM")
  fit <- lme4::lmer(Ww ~ 1 + (1 | sire), data = ex127, REML = TRUE)
  report_mixed_model(fit)
}
#>  We fitted a constant (intercept-only) linear mixed model (estimated using REML
#> and nloptwrap optimizer) to predict Ww (formula: Ww ~ 1). The model included
#> sire as random effect (formula: ~1 | sire). The model's intercept is at 13.97
#> (95% CI [12.47, 15.47], t(40) = 18.79, p < .001).
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
```
