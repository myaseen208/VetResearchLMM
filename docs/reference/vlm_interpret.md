# Plain-language interpretation of a result

`vlm_interpret()` turns a result of the package into a short report: a
headline, findings, recommendations and cautions, computed from its
numbers, with the sources of the method. It covers
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_contrast()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md)
and
[`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md).

## Usage

``` r
vlm_interpret(x, alpha = 0.05, top = 3L, ...)

# Default S3 method
vlm_interpret(x, alpha = 0.05, top = 3L, ...)

# S3 method for class 'vlm_interpretation'
print(x, ...)

# S3 method for class 'vlm_interpretation'
format(x, style = c("text", "markdown"), width = getOption("width", 80L), ...)
```

## Arguments

- x:

  a result of a function of the package.

- alpha:

  significance level used in the sentences (default 0.05).

- top:

  number of levels named in the findings (default 3).

- ...:

  unused.

- style:

  `"text"` (default) or `"markdown"`.

- width:

  line width of the text (default `getOption("width")`).

## Value

An object of class `"vlm_interpretation"`: a list with `analysis`,
`title`, `headline`, `findings`, `recommendations`, `cautions`, `facts`
(the numbers behind the sentences), `guide` (how to read the method) and
`sources`. [`format()`](https://rdrr.io/r/base/format.html) gives it as
text or Markdown.

## See also

[`vlm_cite`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_app`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md)

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md),
[`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md),
[`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)

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
vlm_interpret(
    x     = fm
  , alpha = 0.05
  , top   = 3
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
#> - Satterthwaite, F. E. (1946). An approximate distribution of estimates of
#>   variance components. Biometrics Bulletin, 2(6), 110-114.
#>   doi:10.2307/3002019
#> - Giesbrecht, F. G. and Burns, J. C. (1985). Two-stage analysis based on a
#>   mixed model: large-sample asymptotic theory and small-sample simulation
#>   results. Biometrics, 41(2), 477-486. doi:10.2307/2530872
#> - Fai, A. H.-T. and Cornelius, P. L. (1996). Approximate F-tests of multiple
#>   degree of freedom hypotheses in generalized least squares analyses of
#>   unbalanced split-plot experiments. Journal of Statistical Computation and
#>   Simulation, 54(4), 363-378. doi:10.1080/00949659608811740
```
