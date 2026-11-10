# Example 2.5.4.1: broad and narrow inference spaces

The mean of Samorin in
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md): its
variance is 1.0975 when regions and herds are random (broad space) and
0.175 for the six regions and herds of the study (narrow space), as in
the fixed effects model.

## Details

The narrow-space estimate adds the random effects averaged over the
observed levels (the part of an ESTIMATE statement after the vertical
bar in SAS); the fixed effects model with regions and herds fixed gives
the same standard error.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_estimate`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
[`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md),
[`Examp2.5.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.3.1.md),
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
#     estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;
#   run;
#   proc glm data=ex125;
#     class drug dose region;
#     model pcv = region drug drug*region dose drug*dose;
#     estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;
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
          "broad"  = list(Intercept = 1, Drug = c(0, 1),
                          dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
        , "narrow" = list(Intercept = 1, Drug = c(0, 1),
                          dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
        )
  , random = list(
          "narrow" = list(Region = rep(1 / 6, 6), "Region:Drug" = rep(c(0, 1 / 6), 6))
        )
  , level  = 0.95
  )
#> Estimates (denominator df: satterth)
#> 
#> Estimates
#>   label estimate     se    df     t      p lower upper  space
#>   broad    19.31  1.048 6.205 18.43 <1e-04 16.77 21.85  broad
#>  narrow    19.31 0.4180 10.00 46.20 <1e-04 18.38 20.24 narrow
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).

# the fixed effects model: regions and herds fixed
ff <-
  vlm_fit(
      fixed    = Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose
    , data     = ex125
    , random   = NULL
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = "Region"
    , bound    = TRUE
    , control  = list()
    )
vlm_estimate(
    fit    = ff
  , L      = list(
          "Samorin mean" = list(Intercept = 1, Region = rep(1 / 6, 6), Drug = c(0, 1),
                                "Region:Drug" = rep(c(0, 1 / 6), 6), dose = c(0.5, 0.5),
                                "Drug:dose" = c(0, 0, 0.5, 0.5))
        )
  , random = NULL
  , level  = 0.95
  )
#> Estimates (denominator df: residual)
#> 
#> Estimates
#>         label estimate     se df     t      p lower upper space
#>  Samorin mean    19.31 0.4180 10 46.20 <1e-04 18.38 20.24 fixed
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991). Full references: vlm_cite(x).
```
