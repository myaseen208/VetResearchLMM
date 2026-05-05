# Examp2.4.3.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp2.4.3.1 is used for inspecting probability distribution and to
define a plausible process through linear models and generalized linear
models.

## References

1.  Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear
    Mixed Models. An Introduction with applications in Veterinary
    Research*. International Livestock Research Institute.

## See also

[`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md)

## Author

1.  Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
#-------------------------------------------------------------
## Example 2.4.3.1 p-66
#-------------------------------------------------------------
 # PROC MIXED DATA=ex127;
 # CLASS sire;
 # MODEL ww=;
 # RANDOM sire/solution;
 # RUN;
 
library(lme4)
str(ex127)
#> 'data.frame':    43 obs. of  2 variables:
#>  $ sire: int  1 1 1 2 2 2 2 2 2 2 ...
#>  $ Ww  : num  11.1 10.8 11.3 15.9 13 12.6 14.6 13.6 12.5 15.7 ...
fm2.8 <- 
  lme4::lmer(
         formula    = Ww~(1|sire)
       , data       = ex127
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = NULL
       , devFunOnly = FALSE
    #  , ...
       )  
if (requireNamespace("report", quietly = TRUE)) {
  fm2.8 |>
    report::report()
}
#>  We fitted a constant (intercept-only) linear mixed model (estimated using REML
#> and nloptwrap optimizer) to predict Ww (formula: Ww ~ 1). The model included
#> sire as random effect (formula: ~1 | sire). The model's intercept is at 13.97
#> (95% CI [12.47, 15.47], t(40) = 18.79, p < .001).
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(fm2.8)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: Ww ~ (1 | sire)
#>    Data: ex127
#> 
#> REML criterion at convergence: 188.9
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -1.5024 -0.7106 -0.2259  0.8414  1.9459 
#> 
#> Random effects:
#>  Groups   Name        Variance Std.Dev.
#>  sire     (Intercept) 3.686    1.920   
#>  Residual             3.542    1.882   
#> Number of obs: 43, groups:  sire, 8
#> 
#> Fixed effects:
#>             Estimate Std. Error t value
#> (Intercept)  13.9686     0.7435   18.79
lme4::fixef(fm2.8)
#> (Intercept) 
#>    13.96863 
lme4::ranef(fm2.8)
#> $sire
#>   (Intercept)
#> 1  -2.1979037
#> 2  -0.0318874
#> 3  -1.7434719
#> 4   3.1587811
#> 5   0.8691909
#> 6  -0.8627975
#> 7   1.3556763
#> 8  -0.5475878
#> 
#> with conditional variances for “sire” 
```
