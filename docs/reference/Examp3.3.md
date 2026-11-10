# Example 3.3: covariance structures for repeated measures

PCV of 12 animals of two breeds measured 14 times
([`ex33`](https://myaseen208.com/VetResearchLMM/reference/ex33.md)).
Model 1 has a random animal effect, equivalent to compound symmetry
(variances 5.478 and 4.965; -2 restricted log-likelihood 783.451); Model
2 has first-order autoregressive errors (rho = 0.621, residual 10.191;
793.139); Model 3 has a random intercept and slope per animal with an
unstructured covariance (12.46, -0.2551, 0.005758 and residual 4.353).

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_random`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md),
[`vlm_repeated`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md),
[`vlm_compare`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md),
[`ex33`](https://myaseen208.com/VetResearchLMM/reference/ex33.md)

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
[`Examp3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp3.1.md),
[`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc mixed data=ex33; class breed anim_id; model pcv = breed breed*time / solution;
#     random anim_id(breed) / solution;                               * Model 1;
#     repeated / type=cs sub=anim_id(breed) r;                         * Model 1, second form;
#     repeated / type=ar(1) sub=anim_id(breed) r;                      * Model 2;
#     random intercept time / type=un sub=anim_id(breed) solution;     * Model 3;
#   run;

m1 <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = ~ animal_id:breed
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
m1$fixed
#>         effect  level   estimate         se    df           t            p
#>         <char> <char>      <num>      <num> <num>       <num>        <num>
#> 1: (Intercept)        35.0601525 1.05577722    10  33.2079076 1.447823e-11
#> 2:       breed     BO -0.8419559 1.49309447    10  -0.5638999 5.852457e-01
#> 3:       breed     ND  0.0000000         NA    NA          NA           NA
#> 4:  breed:time     BO -0.4133536 0.02248742   154 -18.3815483 1.131392e-40
#> 5:  breed:time     ND -0.2761367 0.02248742   154 -12.2796110 1.344801e-24
vlm_blup(
    fit   = m1
  , level = 0.95
  )
#> Best linear unbiased predictions of the random effects
#> 
#> Solution for random effects
#>           effect    level estimate    se  df       t       p  lower   upper
#>  animal_id:breed   BO1 BO    2.481 1.091 154   2.274 0.02436 0.3255   4.637
#>  animal_id:breed BO209 BO    3.038 1.091 154   2.784 0.00604 0.8823   5.193
#>  animal_id:breed BO241 BO  -0.6720 1.091 154 -0.6158 0.53891 -2.828   1.484
#>  animal_id:breed BO322 BO   -2.497 1.091 154  -2.288 0.02349 -4.652 -0.3411
#>  animal_id:breed BO326 BO   -2.383 1.091 154  -2.184 0.03050 -4.538 -0.2271
#>  animal_id:breed  BO37 BO  0.03242 1.091 154 0.02972 0.97633 -2.123   2.188
#>  animal_id:breed  ND60 ND   -1.667 1.091 154  -1.528 0.12861 -3.823  0.4885
#>  animal_id:breed  ND66 ND    2.626 1.091 154   2.407 0.01727 0.4708   4.782
#>  animal_id:breed  ND72 ND   -1.667 1.091 154  -1.528 0.12861 -3.823  0.4885
#>  animal_id:breed  ND73 ND  -0.3723 1.091 154 -0.3412 0.73340 -2.528   1.783
#>  animal_id:breed  ND74 ND   -1.754 1.091 154  -1.608 0.10994 -3.910  0.4013
#>  animal_id:breed  ND75 ND    2.834 1.091 154   2.598 0.01030 0.6788   4.990
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Henderson (1975). Full
#> references: vlm_cite(x).
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
cs$fit
#>                         statistic         value
#>                            <char>         <num>
#>  1:         -2 Res Log Likelihood  7.834514e+02
#>  2:       AIC (smaller is better)  7.874514e+02
#>  3:      AICC (smaller is better)  7.875259e+02
#>  4:       BIC (smaller is better)  7.884212e+02
#>  5:            Res Log Likelihood -3.917257e+02
#>  6: AIC (SAS 6, larger is better) -3.937257e+02
#>  7: SBC (SAS 6, larger is better) -3.968255e+02
#>  8:     Null model LRT chi-square  8.084471e+01
#>  9:             Null model LRT df  1.000000e+00
#> 10:        Null model LRT p-value  2.441712e-19
m1c <-
  vlm_fit(
      fixed    = PCV ~ time + breed + breed:time
    , data     = ex33
    , random   = ~ animal_id:breed
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
m1c$tests
#>        effect num_df den_df           F            p
#>        <char>  <int>  <num>       <num>        <num>
#> 1:       time      1    154 470.0533440 1.188853e-48
#> 2:      breed      1     10   0.3179831 5.852457e-01
#> 3: time:breed      1    154  18.6168195 2.845550e-05
ar <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
        , subject = ~ animal_id:breed
        , order   = ~ time
        )
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
ar$covariance
#>    parameter         subject  estimate         se        z            p
#>       <char>          <char>     <num>      <num>    <num>        <num>
#> 1:     AR(1) animal_id:breed  0.621372 0.06415086 9.686106 3.454487e-22
#> 2:  Residual                 10.189815 1.70803804 5.965801 1.217183e-09
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
rc$covariance
#>    parameter         subject     estimate          se         z            p
#>       <char>          <char>        <num>       <num>     <num>        <num>
#> 1:   UN(1,1) animal_id:breed 12.464572630 6.049874059  2.060303 1.968480e-02
#> 2:   UN(2,1) animal_id:breed -0.255121593 0.142828341 -1.786211 7.406506e-02
#> 3:   UN(2,2) animal_id:breed  0.005758072 0.003777797  1.524188 6.373091e-02
#> 4:  Residual                  4.353042151 0.513010930  8.485282 1.075986e-17
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

# the same model with lme4 (optional)
if (requireNamespace("lme4", quietly = TRUE)) {
  lm4 <-
    lme4::lmer(
        formula = PCV ~ breed + breed:time + (1 | animal_id)
      , data    = ex33
      , REML    = TRUE
      )
  print(lme4::VarCorr(lm4), comp = "Variance")
}
#>  Groups    Name        Variance
#>  animal_id (Intercept) 5.4785  
#>  Residual              4.9649  
```
