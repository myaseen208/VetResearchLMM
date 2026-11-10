# Compare fitted models

Compares several fits of
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
by their (restricted) log-likelihoods and information criteria, and
tests each model against the one before it by a likelihood ratio test:
the comparison of covariance structures of Example 3.3 of the book
(compound symmetry, first-order autoregressive, random coefficients).

## Usage

``` r
vlm_compare(..., test = TRUE)

# Default S3 method
vlm_compare(..., test = TRUE)
```

## Arguments

- ...:

  two or more results of
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
  optionally named.

- test:

  logical; add likelihood ratio tests of each model against the previous
  one (default `TRUE`).

## Value

A list of class `c("vlm_compare", "vlm_result", "list")` with `models`
(one row per model: method, number of covariance parameters, -2
log-likelihood, AIC, AICC, BIC and the test against the previous model).

## Details

With \\\ell\\ the maximised (restricted) log-likelihood and \\d\\ the
number of covariance parameters (plus the rank of \\\mathbf{X}\\ for
ML), \\AIC = -2\ell + 2d\\, \\AICC = -2\ell + 2dn^\*/(n^\* - d - 1)\\
and \\BIC = -2\ell + d\log s\\, where \\n^\* = N -
\mathrm{rank}(\mathbf{X})\\ for REML (\\N\\ for ML) and \\s\\ is the
number of subjects. The likelihood ratio statistic of two nested models
is \\-2(\ell_0 - \ell_1)\\, referred to \\\chi^2\_{d_1 - d_0}\\; when
the larger model adds one variance component, the null value lies on the
boundary and `p_boundary` gives the p-value of the 50:50 mixture of
\\\chi^2_0\\ and \\\chi^2_1\\ (Self and Liang 1987). REML likelihoods
are comparable only between models with the same fixed effects; the test
is then left out.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Section 3.4.

Self, S. G. and Liang, K.-Y. (1987). Asymptotic properties of maximum
likelihood estimators and likelihood ratio tests under nonstandard
conditions. *Journal of the American Statistical Association*, 82,
605-610.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

Other VetResearchLMM models:
[`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
cs <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[2]
        , subject = ~ animal_id:breed
        , order   = NULL
        )
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
ar <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
        , subject = ~ animal_id:breed
        , order   = NULL
        )
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
rc <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = vlm_random(
          effects = ~ 1 + time
        , subject = ~ animal_id:breed
        , type    = c("vc", "un")[2]
        )
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
vlm_compare(
    CS   = cs
  , AR1  = ar
  , RC   = rc
  , test = TRUE
  )
#> Comparison of 3 models; smallest AIC: RC
#> 
#> Models
#>  model method cov_parms   m2ll    AIC   AICC    BIC  chisq df      p p_boundary
#>     CS   REML         2 783.45 787.45 787.53 788.42         .      .          .
#>    AR1   REML         2 793.14 797.14 797.21 798.11         .      .          .
#>     RC   REML         4 767.56 775.56 775.81 777.50 25.583  2 <1e-04          .
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Akaike (1974); Schwarz (1978).
#> Full references: vlm_cite(x).
```
