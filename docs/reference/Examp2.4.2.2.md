# Examp2.4.2.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp2.4.2.2 is used for inspecting probability distribution and to
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
## Example 2.4.2.2 p-64
#-------------------------------------------------------------
# PROC MIXED DATA=ex125 METHOD=ML;
# CLASS drug dose region;
# MODEL pcv=drug dose drug*dose;
# RANDOM region drug*region;
# RUN;
# 
# PROC MIXED DATA=ex125 METHOD=REML;
# CLASS drug dose region;
# MODEL pcv=drug dose drug*dose;
# RANDOM region drug*region;
# RUN;
 
 
library(lme4)
str(ex125)
#> 'data.frame':    24 obs. of  4 variables:
#>  $ Region: int  1 1 1 1 2 2 2 2 3 3 ...
#>  $ Drug  : Factor w/ 2 levels "BERENIL","samorin": 1 1 2 2 1 1 2 2 1 1 ...
#>  $ dose  : Factor w/ 2 levels "h","l": 1 2 1 2 1 2 1 2 1 2 ...
#>  $ Pcv   : num  22.6 21.8 19.1 16.4 29 28.8 25.3 18.2 24 23.7 ...

fm2.4 <- 
  lme4::lmer(
         formula    = Pcv ~ dose*Drug + (1|Region/Drug)
       , data       = ex125
       , REML       = FALSE
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
  fm2.4 |>
    report::report()
}
#> Model was not fitted with REML, however, `estimator = "REML"`. Set
#>   `estimator = "ML"` to obtain identical results as from `AIC()`.
#> Model was not fitted with REML, however, `estimator = "REML"`. Set
#>   `estimator = "ML"` to obtain identical results as from `AIC()`.
#> We fitted a linear mixed model (estimated using ML and nloptwrap optimizer) to
#> predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model included
#> Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)). The
#> model's total explanatory power is substantial (conditional R2 = 0.90) and the
#> part related to the fixed effects alone (marginal R2) is of 0.63. The model's
#> intercept, corresponding to dose = h and Drug = BERENIL, is at 25.45 (95% CI
#> [23.28, 27.62], t(17) = 24.72, p < .001). Within this model:
#> 
#>   - The effect of dose [l] is statistically non-significant and negative (beta =
#> -1.17, 95% CI [-2.78, 0.44], t(17) = -1.53, p = 0.145; Std. beta = -0.28, 95%
#> CI [-0.67, 0.11])
#>   - The effect of Drug [samorin] is statistically significant and negative (beta
#> = -3.97, 95% CI [-5.72, -2.21], t(17) = -4.78, p < .001; Std. beta = -0.95, 95%
#> CI [-1.37, -0.53])
#>   - The effect of dose [l] × Drug [samorin] is statistically significant and
#> negative (beta = -3.18, 95% CI [-5.46, -0.91], t(17) = -2.95, p = 0.009; Std.
#> beta = -0.76, 95% CI [-1.31, -0.22])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(fm2.4)
#> Linear mixed model fit by maximum likelihood  ['lmerMod']
#> Formula: Pcv ~ dose * Drug + (1 | Region/Drug)
#>    Data: ex125
#> 
#>       AIC       BIC    logLik -2*log(L)  df.resid 
#>     111.9     120.1     -48.9      97.9        17 
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.87406 -0.56556  0.09217  0.76983  1.27213 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  Drug:Region (Intercept) 0.3225   0.5679  
#>  Region      (Intercept) 4.2924   2.0718  
#>  Residual                1.7470   1.3217  
#> Number of obs: 24, groups:  Drug:Region, 12; Region, 6
#> 
#> Fixed effects:
#>                   Estimate Std. Error t value
#> (Intercept)        25.4500     1.0297  24.716
#> dosel              -1.1667     0.7631  -1.529
#> Drugsamorin        -3.9667     0.8306  -4.776
#> dosel:Drugsamorin  -3.1833     1.0792  -2.950
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dosel  Drgsmr
#> dosel       -0.371              
#> Drugsamorin -0.403  0.459       
#> dsl:Drgsmrn  0.262 -0.707 -0.650
anova(fm2.4)
#> Analysis of Variance Table
#>           npar Sum Sq Mean Sq F value
#> dose         1  45.65   45.65 26.1305
#> Drug         1 135.39  135.39 77.4955
#> dose:Drug    1  15.20   15.20  8.7008

fm2.5 <- 
  lme4::lmer(
         formula    = Pcv ~ dose*Drug + (1|Region/Drug)
       , data       = ex125
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
  fm2.5 |>
    report::report()
}
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model
#> included Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)).
#> The model's total explanatory power is substantial (conditional R2 = 0.89) and
#> the part related to the fixed effects alone (marginal R2) is of 0.58. The
#> model's intercept, corresponding to dose = h and Drug = BERENIL, is at 25.45
#> (95% CI [23.07, 27.83], t(17) = 22.56, p < .001). Within this model:
#> 
#>   - The effect of dose [l] is statistically non-significant and negative (beta =
#> -1.17, 95% CI [-2.93, 0.60], t(17) = -1.40, p = 0.181; Std. beta = -0.28, 95%
#> CI [-0.70, 0.14])
#>   - The effect of Drug [samorin] is statistically significant and negative (beta
#> = -3.97, 95% CI [-5.89, -2.05], t(17) = -4.36, p < .001; Std. beta = -0.95, 95%
#> CI [-1.41, -0.49])
#>   - The effect of dose [l] × Drug [samorin] is statistically significant and
#> negative (beta = -3.18, 95% CI [-5.68, -0.69], t(17) = -2.69, p = 0.015; Std.
#> beta = -0.76, 95% CI [-1.36, -0.17])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(fm2.5)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: Pcv ~ dose * Drug + (1 | Region/Drug)
#>    Data: ex125
#> 
#> REML criterion at convergence: 92.4
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.71077 -0.51628  0.08414  0.70276  1.16129 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  Drug:Region (Intercept) 0.387    0.6221  
#>  Region      (Intercept) 5.151    2.2695  
#>  Residual                2.096    1.4479  
#> Number of obs: 24, groups:  Drug:Region, 12; Region, 6
#> 
#> Fixed effects:
#>                   Estimate Std. Error t value
#> (Intercept)        25.4500     1.1280  22.562
#> dosel              -1.1667     0.8359  -1.396
#> Drugsamorin        -3.9667     0.9098  -4.360
#> dosel:Drugsamorin  -3.1833     1.1822  -2.693
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dosel  Drgsmr
#> dosel       -0.371              
#> Drugsamorin -0.403  0.459       
#> dsl:Drgsmrn  0.262 -0.707 -0.650
anova(fm2.5)
#> Analysis of Variance Table
#>           npar Sum Sq Mean Sq F value
#> dose         1  45.65   45.65 21.7754
#> Drug         1 135.39  135.39 64.5796
#> dose:Drug    1  15.20   15.20  7.2507

library(lmerTest)
#> 
#> Attaching package: ‘lmerTest’
#> The following object is masked from ‘package:lme4’:
#> 
#>     lmer
#> The following object is masked from ‘package:stats’:
#> 
#>     step

fm2.6 <- 
    lmerTest::lmer(
         formula    = Pcv ~ dose*Drug + (1|Region/Drug)
        , data       = ex125
        , REML       = FALSE
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
  fm2.6 |>
    report::report()
}
#> Model was not fitted with REML, however, `estimator = "REML"`. Set
#>   `estimator = "ML"` to obtain identical results as from `AIC()`.
#> Model was not fitted with REML, however, `estimator = "REML"`. Set
#>   `estimator = "ML"` to obtain identical results as from `AIC()`.
#> We fitted a linear mixed model (estimated using ML and nloptwrap optimizer) to
#> predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model included
#> Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)). The
#> model's total explanatory power is substantial (conditional R2 = 0.90) and the
#> part related to the fixed effects alone (marginal R2) is of 0.63. The model's
#> intercept, corresponding to dose = h and Drug = BERENIL, is at 25.45 (95% CI
#> [23.28, 27.62], t(17) = 24.72, p < .001). Within this model:
#> 
#>   - The effect of dose [l] is statistically non-significant and negative (beta =
#> -1.17, 95% CI [-2.78, 0.44], t(17) = -1.53, p = 0.145; Std. beta = -0.28, 95%
#> CI [-0.67, 0.11])
#>   - The effect of Drug [samorin] is statistically significant and negative (beta
#> = -3.97, 95% CI [-5.72, -2.21], t(17) = -4.78, p < .001; Std. beta = -0.95, 95%
#> CI [-1.37, -0.53])
#>   - The effect of dose [l] × Drug [samorin] is statistically significant and
#> negative (beta = -3.18, 95% CI [-5.46, -0.91], t(17) = -2.95, p = 0.009; Std.
#> beta = -0.76, 95% CI [-1.31, -0.22])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(fm2.6)
#> Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
#>   method [lmerModLmerTest]
#> Formula: Pcv ~ dose * Drug + (1 | Region/Drug)
#>    Data: ex125
#> 
#>       AIC       BIC    logLik -2*log(L)  df.resid 
#>     111.9     120.1     -48.9      97.9        17 
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.87406 -0.56556  0.09217  0.76983  1.27213 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  Drug:Region (Intercept) 0.3225   0.5679  
#>  Region      (Intercept) 4.2924   2.0718  
#>  Residual                1.7470   1.3217  
#> Number of obs: 24, groups:  Drug:Region, 12; Region, 6
#> 
#> Fixed effects:
#>                   Estimate Std. Error      df t value Pr(>|t|)    
#> (Intercept)        25.4500     1.0297  9.8496  24.716 3.43e-10 ***
#> dosel              -1.1667     0.7631 12.0000  -1.529 0.152229    
#> Drugsamorin        -3.9667     0.8306 14.1822  -4.776 0.000285 ***
#> dosel:Drugsamorin  -3.1833     1.0792 12.0000  -2.950 0.012151 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dosel  Drgsmr
#> dosel       -0.371              
#> Drugsamorin -0.403  0.459       
#> dsl:Drgsmrn  0.262 -0.707 -0.650
anova(fm2.6)
#> Type III Analysis of Variance Table with Satterthwaite's method
#>           Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)    
#> dose       45.65   45.65     1    12 26.1305 0.0002567 ***
#> Drug      135.39  135.39     1     6 77.4955 0.0001192 ***
#> dose:Drug  15.20   15.20     1    12  8.7008 0.0121507 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

fm2.7 <- 
    lmerTest::lmer(
         formula    = Pcv ~ dose*Drug + (1|Region/Drug)
        , data       = ex125
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
  fm2.7 |>
    report::report()
}
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model
#> included Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)).
#> The model's total explanatory power is substantial (conditional R2 = 0.89) and
#> the part related to the fixed effects alone (marginal R2) is of 0.58. The
#> model's intercept, corresponding to dose = h and Drug = BERENIL, is at 25.45
#> (95% CI [23.07, 27.83], t(17) = 22.56, p < .001). Within this model:
#> 
#>   - The effect of dose [l] is statistically non-significant and negative (beta =
#> -1.17, 95% CI [-2.93, 0.60], t(17) = -1.40, p = 0.181; Std. beta = -0.28, 95%
#> CI [-0.70, 0.14])
#>   - The effect of Drug [samorin] is statistically significant and negative (beta
#> = -3.97, 95% CI [-5.89, -2.05], t(17) = -4.36, p < .001; Std. beta = -0.95, 95%
#> CI [-1.41, -0.49])
#>   - The effect of dose [l] × Drug [samorin] is statistically significant and
#> negative (beta = -3.18, 95% CI [-5.68, -0.69], t(17) = -2.69, p = 0.015; Std.
#> beta = -0.76, 95% CI [-1.36, -0.17])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(fm2.7)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: Pcv ~ dose * Drug + (1 | Region/Drug)
#>    Data: ex125
#> 
#> REML criterion at convergence: 92.4
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -1.71077 -0.51628  0.08414  0.70276  1.16129 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  Drug:Region (Intercept) 0.387    0.6221  
#>  Region      (Intercept) 5.151    2.2695  
#>  Residual                2.096    1.4479  
#> Number of obs: 24, groups:  Drug:Region, 12; Region, 6
#> 
#> Fixed effects:
#>                   Estimate Std. Error      df t value Pr(>|t|)    
#> (Intercept)        25.4500     1.1280  8.2080  22.562 1.12e-08 ***
#> dosel              -1.1667     0.8359 10.0000  -1.396 0.193041    
#> Drugsamorin        -3.9667     0.9098 11.8185  -4.360 0.000962 ***
#> dosel:Drugsamorin  -3.1833     1.1822 10.0000  -2.693 0.022595 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dosel  Drgsmr
#> dosel       -0.371              
#> Drugsamorin -0.403  0.459       
#> dsl:Drgsmrn  0.262 -0.707 -0.650
anova(fm2.7)
#> Type III Analysis of Variance Table with Satterthwaite's method
#>           Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)    
#> dose       45.65   45.65     1    10 21.7754 0.0008856 ***
#> Drug      135.39  135.39     1     5 64.5796 0.0004826 ***
#> dose:Drug  15.20   15.20     1    10  7.2507 0.0225945 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
