# Report a fitted mixed model

Gives a narrative report of a fitted model. For a result of
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
it is the plain-language interpretation of
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md);
for other models the optional package report writes the report, as in
version 1.1.0.

## Usage

``` r
report_mixed_model(model, ...)

# Default S3 method
report_mixed_model(model, ...)

# S3 method for class 'vlm_fit'
report_mixed_model(model, ...)
```

## Arguments

- model:

  a fitted model: a result of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
  or a model supported by report.

- ...:

  further arguments passed to
  [`report::report()`](https://easystats.github.io/report/reference/report.html)
  or to
  [`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md).

## Value

A `vlm_interpretation` object for a `vlm_fit` result; otherwise the
object returned by
[`report::report()`](https://easystats.github.io/report/reference/report.html).

## References

Makowski, D., Ben-Shachar, M. S., Patil, I. and Luedecke, D. (2023).
Automated results reporting as a practical tool to improve
reproducibility and methodological best practices adoption. R package
report.

## See also

[`vlm_interpret`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`emmeans_mixed_model`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md)

Other VetResearchLMM inference:
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
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
report_mixed_model(
    model = fm
  )
#> Linear mixed model
#> 
#> Pcv ~ Drug + dose + Drug:dose, fitted by REML with 3 covariance parameters.
#> 
#> Findings:
#> - Of the total variance 7.63, 67.5% is due to Region, 5.1% is due to
#>   Region:Drug, 27.5% is due to the residual (within) variation.
#> - Significant at the 0.05 level: Drug (F = 64.6 on 1 and 5 df, p = 0.00048);
#>   dose (F = 21.8 on 1 and 10 df, p = 0.00089); Drug:dose (F = 7.25 on 1 and
#>   10 df, p = 0.023).
#> 
#> Recommendations:
#> - The interaction Drug:dose is significant: compare the levels of one factor
#>   within each level of the other (vlm_lsmeans() of the interaction, or
#>   vlm_estimate()) rather than main-effect means.
#> - Report means with standard errors in the broad inference space
#>   (vlm_lsmeans()); use vlm_estimate() with `random` for the narrow space of
#>   the observed levels.
#> 
#> Cautions:
#> - Denominator df by the contain method; with unbalanced data prefer ddfm =
#>   "satterth" or "kr".
#> 
#> Sources:
#> - Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). Linear Mixed Models.
#>   An Introduction with Applications in Veterinary Research. International
#>   Livestock Research Institute, Nairobi. ISBN 92-9146-038-9.
#> - Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block
#>   information when block sizes are unequal. Biometrika, 58(3), 545-554.
#>   doi:10.1093/biomet/58.3.545
#> - Gilmour, A. R., Thompson, R. and Cullis, B. R. (1995). Average information
#>   REML: an efficient algorithm for variance parameter estimation in linear
#>   mixed models. Biometrics, 51(4), 1440-1450. doi:10.2307/2533274
#> - Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D. (1996).
#>   SAS System for Mixed Models. SAS Institute, Cary, NC.
```
