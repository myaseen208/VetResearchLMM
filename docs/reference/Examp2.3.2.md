# Example 2.3.2: the mixed model descriptions of Chapter 2

The models of Section 2.3.2 for the examples of Chapter 1: a randomised
block design with random herds
([`ex122`](https://myaseen208.com/VetResearchLMM/reference/ex122.md)),
herds nested in drug
([`ex123`](https://myaseen208.com/VetResearchLMM/reference/ex123.md)),
two sizes of experimental units
([`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md))
and the random effects model of the ELISA data
([`ex126`](https://myaseen208.com/VetResearchLMM/reference/ex126.md)),
in which animals and times are random and the overall mean is the only
fixed effect. New in version 2.0.0.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`ex122`](https://myaseen208.com/VetResearchLMM/reference/ex122.md),
[`ex123`](https://myaseen208.com/VetResearchLMM/reference/ex123.md),
[`ex126`](https://myaseen208.com/VetResearchLMM/reference/ex126.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
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
#   proc mixed data=ex126;
#     class anim_id time;
#     model OD = ;
#     random anim_id time;
#   run;

f122 <-
  vlm_fit(
      fixed    = PCVdif ~ dose
    , data     = ex122
    , random   = ~ herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
f122$covariance
#>    parameter subject  estimate         se         z            p
#>       <char>  <char>     <num>      <num>     <num>        <num>
#> 1:      herd         0.4300102 0.45247601 0.9503492 0.1709674168
#> 2:  Residual         0.2242308 0.06219042 3.6055513 0.0001557455
f123 <-
  vlm_fit(
      fixed    = PCVdif ~ drug
    , data     = ex123
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
f123$tests
#>    effect num_df den_df        F         p
#>    <char>  <int>  <num>    <num>     <num>
#> 1:   drug      1      2 1.747156 0.3171663
f126 <-
  vlm_fit(
      fixed    = OD ~ 1
    , data     = ex126
    , random   = ~ anim_id + time
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = "time"
    , bound    = TRUE
    , control  = list()
    )
f126$covariance
#>    parameter subject     estimate           se        z            p
#>       <char>  <char>        <num>        <num>    <num>        <num>
#> 1:   anim_id         0.0193086158 1.578702e-02 1.223069 1.106517e-01
#> 2:      time         0.0001238079 8.874540e-05 1.395090 8.149429e-02
#> 3:  Residual         0.0005826121 9.578042e-05 6.082789 5.905472e-10
vlm_interpret(
    x     = f126
  , alpha = 0.05
  , top   = 3
  )
#> Linear mixed model
#> 
#> OD ~ 1, fitted by REML with 3 covariance parameters.
#> 
#> Findings:
#> - Of the total variance 0.02, 96.5% is due to anim_id, 0.6% is due to time,
#>   2.9% is due to the residual (within) variation.
#> 
#> Recommendations:
#> - Report means with standard errors in the broad inference space
#>   (vlm_lsmeans()); use vlm_estimate() with `random` for the narrow space of
#>   the observed levels.
#> 
#> Cautions:
#> - anim_id has only 4 levels: its variance is estimated with few degrees of
#>   freedom and is imprecise.
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
