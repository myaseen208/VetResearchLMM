# Example 2.5.3.1: confidence intervals with Satterthwaite degrees of freedom

Four linear combinations of the fixed effects of
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md):
their variances 0.478, 1.0975, 0.698 and 1.272 combine the variance
components, and their Satterthwaite degrees of freedom (5, 6.2, 10 and
8.2) the degrees of freedom of the mean squares of Table 2.5.3.1.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_estimate`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_ems`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
[`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md),
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
#   proc mixed data=ex125;
#     class drug dose region;
#     model pcv = drug dose drug*dose / ddfm=satterth;
#     random region drug*region;
#     estimate 'drug dif' drug -1 1 drug*dose -0.5 -0.5 0.5 0.5;
#     estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;
#     estimate 'Samorin HvsL' dose 1 -1 drug*dose 0 0 1 -1;
#     estimate 'Samorin high' intercept 1 drug 0 1 dose 1 0 drug*dose 0 0 1 0;
#   run;

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

# the mean squares and their expectations (Table 2.5.3.1)
em <-
  vlm_ems(
      fixed  = Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose
    , data   = ex125
    , random = ~ Region + Region:Drug
    , type   = 3
    , class  = NULL
    )
em
#> Type 3 analysis of variance of Pcv
#> 
#> Analysis of variance
#>       source df    ss    ms                                                ems
#>       Region  5 117.4 23.47 Var(Residual) + 4 Var(Region) + 2 Var(Region:Drug)
#>         Drug  1 185.4 185.4       Var(Residual) + 2 Var(Region:Drug) + Q(Drug)
#>  Region:Drug  5 14.35 2.870                 Var(Residual) + 2 Var(Region:Drug)
#>         dose  1 45.65 45.65                            Var(Residual) + Q(dose)
#>    Drug:dose  1 15.20 15.20                       Var(Residual) + Q(Drug:dose)
#>     Residual 10 20.96 2.096                                      Var(Residual)
#>      F den_df        p
#>  8.178      5 0.018857
#>  64.58      5 0.000483
#>  1.369     10 0.313691
#>  21.78     10 0.000886
#>  7.251     10 0.022594
#>             .        .
#> 
#> Error terms of the tests
#>       source             error
#>       Region 1 MS(Region:Drug)
#>         Drug 1 MS(Region:Drug)
#>  Region:Drug    1 MS(Residual)
#>         dose    1 MS(Residual)
#>    Drug:dose    1 MS(Residual)
#> 
#> Type 3 estimates of the variance components
#>    component estimate
#>       Region    5.151
#>  Region:Drug   0.3870
#>     Residual    2.096
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Casella and McCulloch
#> (1992); Satterthwaite (1946). Full references: vlm_cite(x).
```
