# Example 2.6.1: F tests of general linear hypotheses

The drug difference of
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)
(estimate -5.56, variance 0.478, F on 1 and 5 df) and the joint test
that the four cell means are equal: F = 31.2 on 3 and 7.14 df, p =
0.0002.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_contrast`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
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
[`Examp2.5.4.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.4.1.md),
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
#     contrast 'drug dif' drug -1 1 drug*dose -0.5 -0.5 0.5 0.5;
#     contrast 'all' drug 1 -1 dose 0 0 drug*dose 0.5 0.5 -0.5 -0.5,
#                    drug 0 0 dose 1 -1 drug*dose 0.5 -0.5 0.5 -0.5,
#                    drug 0 0 dose 0 0 drug*dose 0.5 -0.5 -0.5 0.5;
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
vlm_contrast(
    fit = fm
  , L   = list(
          "drug dif" = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
        , "all"      = list(
              list(Drug = c(1, -1), "Drug:dose" = c(0.5, 0.5, -0.5, -0.5))
            , list(dose = c(1, -1), "Drug:dose" = c(0.5, -0.5, 0.5, -0.5))
            , list("Drug:dose" = c(0.5, -0.5, -0.5, 0.5))
            )
        )
  )
#> Contrasts (denominator df: satterth)
#> 
#> Contrasts
#>     label num_df den_df     F        p
#>  drug dif      1  5.000 64.58 0.000483
#>       all      3  7.143 31.20 0.000179
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
```
