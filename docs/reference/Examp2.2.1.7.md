# Examp2.2.1.7 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp2.2.1.7 is used for inspecting probability distribution and to
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
## Example 2.2.1.7 p-42
#-------------------------------------------------------------
 # PROC GLM DATA=ex121;
 # CLASS dose;
 # MODEL PCVdif=dose;
 # ESTIMATE 'l vs mh' dose -0.5 1 -0.5;
 # CONTRAST 'l vs mh' dose -0.5 1 -0.5;
 # RUN;

library(lme4)
str(ex121)
#> 'data.frame':    14 obs. of  5 variables:
#>  $ animals: int  1 2 3 4 5 1 2 3 4 1 ...
#>  $ dose   : Factor w/ 3 levels "H","L","M": 2 2 2 2 2 3 3 3 3 1 ...
#>  $ PCV1   : num  17.4 18.7 15.8 16.4 16.6 16.8 17.3 17.5 15.2 18 ...
#>  $ PCV2   : num  19.3 18.9 19.2 19.9 17.8 22.6 19.7 20.2 19.5 25.7 ...
#>  $ PCVdiff: num  1.9 0.2 3.4 3.6 1.1 5.9 2.4 2.7 4.3 7.7 ...
fm2.1 <-
 aov(
     formula     = PCVdiff ~ dose
   , data        = ex121
   , projections = FALSE
   , qr          = TRUE
   , contrasts   = NULL
 #  , ...
   )
if (requireNamespace("report", quietly = TRUE)) {
  fm2.1 |>
    report::report()
}
#> The ANOVA (formula: PCVdiff ~ dose) suggests that:
#> 
#>   - The main effect of dose is statistically significant and large (F(2, 11) =
#> 14.37, p < .001; Eta2 = 0.72, 95% CI [0.39, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
summary(fm2.1)
#>             Df Sum Sq Mean Sq F value   Pr(>F)    
#> dose         2  80.73   40.36   14.37 0.000856 ***
#> Residuals   11  30.91    2.81                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
anova(fm2.1)
#> Analysis of Variance Table
#> 
#> Response: PCVdiff
#>           Df Sum Sq Mean Sq F value   Pr(>F)    
#> dose       2 80.727  40.363  14.365 0.000856 ***
#> Residuals 11 30.908   2.810                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

LvsMHConc <-
         matrix(
             data    = c(-0.5, 1, -0.5)
           , nrow    = length(levels(ex121$dose))
           , byrow   = FALSE
           , dimnames = list(
                             c(levels(ex121$dose))
                           , c("Low vs Mediam and Hight")
                           )
         )

contrasts(ex121$dose) <- LvsMHConc
fm2.2 <-
 aov(
     formula     = PCVdiff ~ dose
   , data        = ex121
   , projections = FALSE
   , qr          = TRUE
   , contrasts   = NULL
 #  , ...
   )
if (requireNamespace("report", quietly = TRUE)) {
  fm2.2 |>
    report::report()
}
#> The ANOVA (formula: PCVdiff ~ dose) suggests that:
#> 
#>   - The main effect of dose is statistically significant and large (F(2, 11) =
#> 14.37, p < .001; Eta2 = 0.72, 95% CI [0.39, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
summary(fm2.2, split = list(dose = list("Low vs Mediam and Hight" = 1)))
#>                                 Df Sum Sq Mean Sq F value   Pr(>F)    
#> dose                             2  80.73   40.36   14.37 0.000856 ***
#>   dose: Low vs Mediam and Hight  1  48.72   48.72   17.34 0.001578 ** 
#> Residuals                       11  30.91    2.81                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

library(multcomp)
#> Loading required package: mvtnorm
#> Loading required package: survival
#> Loading required package: TH.data
#> Loading required package: MASS
#> 
#> Attaching package: ‘TH.data’
#> The following object is masked from ‘package:MASS’:
#> 
#>     geyser
fm2.3 <-
     lm(
          formula     = PCVdiff ~ dose
        , data        = ex121
     #  , subset
     #  , weights
     #  , na.action
        , method      = "qr"
        , model       = TRUE
        , x           = FALSE
        , y           = FALSE
        , qr          = TRUE
        , singular.ok = TRUE
        , contrasts   = NULL
     #  , offset
     #  , ...
     )
if (requireNamespace("report", quietly = TRUE)) {
  fm2.3 |>
    report::report()
}
#> We fitted a linear model (estimated using OLS) to predict PCVdiff with dose
#> (formula: PCVdiff ~ dose). The model explains a statistically significant and
#> substantial proportion of variance (R2 = 0.72, F(2, 11) = 14.37, p < .001, adj.
#> R2 = 0.67). The model's intercept, corresponding to dose = , is at 4.50 (95% CI
#> [3.50, 5.49], t(11) = 9.98, p < .001). Within this model:
#> 
#>   - The effect of dose [Low vs Mediam and Hight] is statistically significant and
#> negative (beta = -2.45, 95% CI [-3.83, -1.08], t(11) = -3.93, p = 0.002; Std.
#> beta = -0.84, 95% CI [-1.31, -0.37])
#>   - The effect of dose [] is statistically significant and negative (beta =
#> -2.68, 95% CI [-4.43, -0.93], t(11) = -3.37, p = 0.006; Std. beta = -0.92, 95%
#> CI [-1.51, -0.32])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
if (requireNamespace("emmeans", quietly = TRUE)) {
  emm2.3 <- emmeans::emmeans(fm2.3, ~ dose)
  print(emm2.3)
  print(emmeans::contrast(
    emm2.3,
    method = list(low_vs_medium_high = c(-0.5, 1, -0.5))
  ))
}
#>  dose emmean    SE df lower.CL upper.CL
#>  H      7.62 0.750 11     5.97     9.27
#>  L      2.04 0.750 11     0.39     3.69
#>  M      3.83 0.838 11     1.98     5.67
#> 
#> Confidence level used: 0.95 
#>  contrast           estimate    SE df t.ratio p.value
#>  low_vs_medium_high    -3.68 0.937 11  -3.930  0.0024
#> 
summary(fm2.3)
#> 
#> Call:
#> lm(formula = PCVdiff ~ dose, data = ex121, method = "qr", model = TRUE, 
#>     x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE, contrasts = NULL)
#> 
#> Residuals:
#>    Min     1Q Median     3Q    Max 
#> -2.620 -1.079 -0.030  1.190  2.580 
#> 
#> Coefficients:
#>                             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)                   4.4950     0.4505   9.978 7.55e-07 ***
#> doseLow vs Mediam and Hight  -2.4550     0.6247  -3.930  0.00235 ** 
#> dose                         -2.6835     0.7951  -3.375  0.00620 ** 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 1.676 on 11 degrees of freedom
#> Multiple R-squared:  0.7231, Adjusted R-squared:  0.6728 
#> F-statistic: 14.37 on 2 and 11 DF,  p-value: 0.000856
#> 
anova(fm2.3)
#> Analysis of Variance Table
#> 
#> Response: PCVdiff
#>           Df Sum Sq Mean Sq F value   Pr(>F)    
#> dose       2 80.727  40.363  14.365 0.000856 ***
#> Residuals 11 30.907   2.810                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# multcomp::glht(
#      model       = fm2.3
#    , linfct      = LvsMHConc
#    , alternative = "two.sided" # c("two.sided", "less", "greater")
#    , rhs         = 0
#    )
```
