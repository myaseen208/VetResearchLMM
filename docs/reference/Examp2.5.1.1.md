# Example 2.5.1.1: generalised least-squares estimates of the fixed effects

The solution for the fixed effects of
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md) with
the last level of each effect set to zero: 17.13, 7.15, 4.35 and -3.18,
with the variances 1.27, 0.83, 0.70 and 1.40 of their estimates (the
COVB matrix).

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
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
#   proc mixed data=ex125;
#     class drug dose region;
#     model pcv = drug dose drug*dose / solution covb;
#     random region drug*region;
#   run;

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
fm$fixed
#>         effect     level  estimate        se    df         t            p
#>         <char>    <char>     <num>     <num> <num>     <num>        <num>
#> 1: (Intercept)           17.133333 1.1279960     5 15.189179 2.242189e-05
#> 2:        Drug   BERENIL  7.150000 0.9098382     5  7.858540 5.358618e-04
#> 3:        Drug   samorin  0.000000        NA    NA        NA           NA
#> 4:        dose         h  4.350000 0.8359459    10  5.203686 3.991648e-04
#> 5:        dose         l  0.000000        NA    NA        NA           NA
#> 6:   Drug:dose BERENIL h -3.183333 1.1822060    10 -2.692706 2.259450e-02
#> 7:   Drug:dose BERENIL l  0.000000        NA    NA        NA           NA
#> 8:   Drug:dose samorin h  0.000000        NA    NA        NA           NA
#> 9:   Drug:dose samorin l  0.000000        NA    NA        NA           NA
fm$fixed$se^2
#> [1] 1.2723750 0.8278056        NA 0.6988056        NA 1.3976111        NA
#> [8]        NA        NA
```
