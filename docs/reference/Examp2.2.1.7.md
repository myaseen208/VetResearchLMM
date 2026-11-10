# Example 2.2.1.7: one-way analysis of variance, an estimate and a contrast

The three doses of
[`ex121`](https://myaseen208.com/VetResearchLMM/reference/ex121.md)
compared by the fixed effects model: F = 14.36 on 2 and 11 df, and the
low dose against the mean of the medium and high doses, -3.68 with
standard error 0.937 (F = 15.44).

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_ems`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`vlm_estimate`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`ex121`](https://myaseen208.com/VetResearchLMM/reference/ex121.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
[`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md),
[`Examp2.5.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.3.1.md),
[`Examp2.5.4.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.4.1.md),
[`Examp2.6.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.6.1.md),
[`Examp3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp3.1.md),
[`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md),
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc glm data=ex121;
#     class dose;
#     model PCVdif = dose;
#     estimate 'l vs mh' dose -0.5 1 -0.5;
#     contrast 'l vs mh' dose -0.5 1 -0.5;
#   run;

em <-
  vlm_ems(
      fixed  = PCVdiff ~ dose
    , data   = ex121
    , random = NULL
    , type   = 3
    , class  = NULL
    )
em
#> Type 3 analysis of variance of PCVdiff
#> 
#> Analysis of variance
#>    source df    ss    ms                     ems     F den_df        p
#>      dose  2 80.73 40.36 Var(Residual) + Q(dose) 14.37     11 0.000856
#>  Residual 11 30.91 2.810           Var(Residual)            .        .
#> 
#> Error terms of the tests
#>  source          error
#>    dose 1 MS(Residual)
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Casella and McCulloch
#> (1992); Satterthwaite (1946). Full references: vlm_cite(x).

fm <-
  vlm_fit(
      fixed    = PCVdiff ~ dose
    , data     = ex121
    , random   = NULL
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
# dose levels: H, L, M
vlm_estimate(
    fit    = fm
  , L      = list("l vs mh" = list(dose = c(-0.5, 1, -0.5)))
  , random = NULL
  , level  = 0.95
  )
#> Estimates (denominator df: residual)
#> 
#> Estimates
#>    label estimate     se df      t       p  lower  upper space
#>  l vs mh   -3.683 0.9370 11 -3.930 0.00235 -5.745 -1.620 fixed
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991). Full references: vlm_cite(x).
vlm_contrast(
    fit = fm
  , L   = list("l vs mh" = list(dose = c(-0.5, 1, -0.5)))
  )
#> Contrasts (denominator df: residual)
#> 
#> Contrasts
#>    label num_df den_df     F       p
#>  l vs mh      1     11 15.44 0.00235
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991). Full references: vlm_cite(x).
```
