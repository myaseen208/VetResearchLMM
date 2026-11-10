# Example 3.1: a designed experiment with doses nested in drug and a covariate

Berenil at two doses and Samorin at one dose, given to animals in herds
nested in drug
([`ex31`](https://myaseen208.com/VetResearchLMM/reference/ex31.md)).
Model 1 compares the three treatments; Model 2 adds the PCV at treatment
as a covariate with a common slope; Model 3 allows a slope per treatment
and compares the treatments at PCV1 = 18. The book prints only part of
the data, so the numbers differ from those of the book.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`ex31`](https://myaseen208.com/VetResearchLMM/reference/ex31.md)

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
[`Examp2.6.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.6.1.md),
[`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md),
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc mixed data=ex31;
#     class drug dose herd;
#     model PCV2 = drug dose(drug) / solution ddfm=satterth;
#     random herd(drug);
#     estimate 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;
#     estimate 'Berenil 2 doses' dose(drug) 1 -1 0;
#     estimate 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -1;
#     contrast 'some difference' drug 1 -1 dose(drug) 0.5 0.5 -1, drug 0 0 dose(drug) 1 -1 0;
#     lsmeans dose(drug);
#   run;
#   * Model 3: model PCV2 = drug dose(drug) PCV1*dose(drug); lsmeans dose(drug) / at PCV1=18;

m1 <-
  vlm_fit(
      fixed    = PCV2 ~ drug + drug:dose
    , data     = ex31
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = c("herd", "dose")
    , bound    = TRUE
    , control  = list()
    )
m1$tests
#>       effect num_df   den_df           F         p
#>       <char>  <int>    <num>       <num>     <num>
#> 1:      drug      1 10.08194 0.001544608 0.9694174
#> 2: drug:dose      1 31.51959 2.600111652 0.1168256
vlm_estimate(
    fit    = m1
  , L      = list(
          "Mean Samorin"         = list(Intercept = 1, drug = c(0, 1), "drug:dose" = c(0, 0, 1))
        , "Berenil 2 doses"      = list("drug:dose" = c(1, -1, 0))
        , "Ber vs Sam at dose 1" = list(drug = c(1, -1), "drug:dose" = c(1, 0, -1))
        )
  , random = NULL
  , level  = 0.95
  )
#> Estimates (denominator df: satterth)
#> 
#> Estimates
#>                 label estimate    se    df       t      p  lower  upper space
#>          Mean Samorin    24.17 1.038 15.36   23.28 <1e-04  21.96  26.38 broad
#>       Berenil 2 doses   -2.102 1.303 31.52  -1.612  0.117 -4.758 0.5548 broad
#>  Ber vs Sam at dose 1   -1.000 1.468 15.36 -0.6811  0.506 -4.123  2.123 broad
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
vlm_contrast(
    fit = m1
  , L   = list(
          "some difference" = list(
              list(drug = c(1, -1), "drug:dose" = c(0.5, 0.5, -1))
            , list("drug:dose" = c(1, -1, 0))
            )
        )
  )
#> Contrasts (denominator df: satterth)
#> 
#> Contrasts
#>            label num_df den_df     F    p
#>  some difference      2  23.89 1.305 0.29
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
#> (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
vlm_lsmeans(
    fit    = m1
  , specs  = ~ drug:dose
  , at     = NULL
  , diff   = FALSE
  , adjust = "none"
  , level  = 0.95
  )
#> Least-squares means (denominator df: satterth; 95% limits)
#> 
#> Least squares means
#>     drug dose estimate     se    df     t      p lower upper
#>  BERENIL    1    23.17  1.038 15.36 22.31 <1e-04 20.96 25.38
#>  BERENIL    2    25.27 0.9772 12.14 25.86 <1e-04 23.14 27.39
#>  SAMORIN    1    24.17  1.038 15.36 23.28 <1e-04 21.96 26.38
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
m2 <-
  vlm_fit(
      fixed    = PCV2 ~ PCV1 + drug + drug:dose
    , data     = ex31
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = c("herd", "dose")
    , bound    = TRUE
    , control  = list()
    )
m2$fixed
#>         effect     level    estimate        se       df           t
#>         <char>    <char>       <num>     <num>    <num>       <num>
#> 1: (Intercept)           23.64038374 6.0688883 33.91516  3.89534006
#> 2:        PCV1            0.02567234 0.2915898 33.74677  0.08804263
#> 3:        drug   BERENIL  1.13037053 1.4655128 13.70391  0.77131400
#> 4:        drug   SAMORIN  0.00000000        NA       NA          NA
#> 5:   drug:dose BERENIL 1 -2.13250989 1.3572496 30.87598 -1.57119948
#> 6:   drug:dose BERENIL 2  0.00000000        NA       NA          NA
#> 7:   drug:dose SAMORIN 1  0.00000000        NA       NA          NA
#>               p
#>           <num>
#> 1: 0.0004379325
#> 2: 0.9303631850
#> 3: 0.4536158104
#> 4:           NA
#> 5: 0.1263290123
#> 6:           NA
#> 7:           NA
m3 <-
  vlm_fit(
      fixed    = PCV2 ~ drug + drug:dose + PCV1:drug:dose
    , data     = ex31
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = c("herd", "dose")
    , bound    = TRUE
    , control  = list()
    )
vlm_lsmeans(
    fit    = m3
  , specs  = ~ drug:dose
  , at     = list(PCV1 = 18)
  , diff   = FALSE
  , adjust = "none"
  , level  = 0.95
  )
#> Least-squares means (denominator df: satterth; 95% limits)
#> 
#> Least squares means
#>     drug dose estimate    se    df     t      p lower upper
#>  BERENIL    1    24.20 1.916 30.01 12.63 <1e-04 20.29 28.12
#>  BERENIL    2    24.79 1.154 16.70 21.47 <1e-04 22.35 27.23
#>  SAMORIN    1    25.26 2.099 28.03 12.03 <1e-04 20.96 29.56
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
```
