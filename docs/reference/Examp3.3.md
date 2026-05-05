# Examp3.3 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp3.3 is used for inspecting probability distribution and to define a
plausible process through linear models and generalized linear models.

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
## Example 3.3 Model 1 p-88
#-------------------------------------------------------------
# PROC MIXED DATA=ex33;
# CLASS breed animal_id;
# MODEL pcv = breed breed*time/SOLUTION;
# RANDOM animal_id(breed)/SOLUTION;
# RUN;

 library(lme4)
 options(contrasts = c(factor = "contr.SAS", ordered = "contr.poly"))
 str(ex33)
#> 'data.frame':    168 obs. of  4 variables:
#>  $ animal_id: Factor w/ 12 levels "BO1","BO209",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  $ breed    : Factor w/ 2 levels "BO","ND": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ time     : int  0 2 4 7 9 14 17 18 21 23 ...
#>  $ PCV      : num  36.2 35.9 35.3 35.4 35.4 31.5 25.5 34.4 34.1 25.8 ...

 fm3.5 <-
  lme4::lmer(
         formula    = PCV ~ breed + breed:time + (1|animal_id:breed)
       , data       = ex33
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(breed = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.5 |>
     report::report()
 }
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV with breed and time (formula: PCV ~ breed + breed:time). The
#> model included animal_id as random effects (formula: ~1 | animal_id:breed). The
#> model's total explanatory power is substantial (conditional R2 = 0.82) and the
#> part related to the fixed effects alone (marginal R2) is of 0.62. The model's
#> intercept, corresponding to breed = ND and time = 0, is at 35.06 (95% CI
#> [32.97, 37.15], t(162) = 33.11, p < .001). Within this model:
#> 
#>   - The effect of breed [BO] is statistically non-significant and negative (beta
#> = -0.83, 95% CI [-3.79, 2.12], t(162) = -0.56, p = 0.578; Std. beta = -0.61,
#> 95% CI [-1.15, -0.08])
#>   - The effect of breed [BO] × time is statistically significant and negative
#> (beta = -0.41, 95% CI [-0.46, -0.37], t(162) = -18.44, p < .001; Std. beta =
#> -0.87, 95% CI [-0.97, -0.78])
#>   - The effect of breed [ND] × time is statistically significant and negative
#> (beta = -0.28, 95% CI [-0.32, -0.23], t(162) = -12.31, p < .001; Std. beta =
#> -0.58, 95% CI [-0.67, -0.49])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 summary(fm3.5)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: PCV ~ breed + breed:time + (1 | animal_id:breed)
#>    Data: ex33
#> 
#> REML criterion at convergence: 782.8
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -2.7450 -0.4937  0.1392  0.6072  2.7366 
#> 
#> Random effects:
#>  Groups          Name        Variance Std.Dev.
#>  animal_id:breed (Intercept) 5.523    2.350   
#>  Residual                    4.943    2.223   
#> Number of obs: 168, groups:  animal_id:breed, 12
#> 
#> Fixed effects:
#>              Estimate Std. Error t value
#> (Intercept)  35.05944    1.05883  33.112
#> breedBO      -0.83452    1.49743  -0.557
#> breedBO:time -0.41434    0.02247 -18.440
#> breedND:time -0.27590    0.02242 -12.307
#> 
#> Correlation of Fixed Effects:
#>             (Intr) bredBO brdBO:
#> breedBO     -0.707              
#> breedBO:tim  0.000 -0.252       
#> breedND:tim -0.356  0.251  0.000
 anova(fm3.5)
#> Analysis of Variance Table
#>            npar  Sum Sq Mean Sq  F value
#> breed         1   24.96   24.96   5.0507
#> breed:time    2 2429.25 1214.63 245.7448

 library(lmerTest)
 fm3.6 <-
  lmerTest::lmer(
         formula    = PCV ~ breed + breed:time + (1|animal_id:breed)
       , data       = ex33
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(breed = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.6 |>
     report::report()
 }
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV with breed and time (formula: PCV ~ breed + breed:time). The
#> model included animal_id as random effects (formula: ~1 | animal_id:breed). The
#> model's total explanatory power is substantial (conditional R2 = 0.82) and the
#> part related to the fixed effects alone (marginal R2) is of 0.62. The model's
#> intercept, corresponding to breed = ND and time = 0, is at 35.06 (95% CI
#> [32.97, 37.15], t(162) = 33.11, p < .001). Within this model:
#> 
#>   - The effect of breed [BO] is statistically non-significant and negative (beta
#> = -0.83, 95% CI [-3.79, 2.12], t(162) = -0.56, p = 0.578; Std. beta = -0.61,
#> 95% CI [-1.15, -0.08])
#>   - The effect of breed [BO] × time is statistically significant and negative
#> (beta = -0.41, 95% CI [-0.46, -0.37], t(162) = -18.44, p < .001; Std. beta =
#> -0.87, 95% CI [-0.97, -0.78])
#>   - The effect of breed [ND] × time is statistically significant and negative
#> (beta = -0.28, 95% CI [-0.32, -0.23], t(162) = -12.31, p < .001; Std. beta =
#> -0.58, 95% CI [-0.67, -0.49])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   trend3.6 <- emmeans::emtrends(
     fm3.6,
     ~ breed,
     var = "time",
     lmer.df = "asymptotic"
   )
   print(trend3.6)
   print(emmeans::contrast(trend3.6, method = "pairwise"))
 }
#>  breed time.trend     SE  df asymp.LCL asymp.UCL
#>  BO        -0.414 0.0225 Inf    -0.458    -0.370
#>  ND        -0.276 0.0224 Inf    -0.320    -0.232
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#>  contrast estimate     SE  df z.ratio p.value
#>  BO - ND    -0.138 0.0317 Inf  -4.362 <0.0001
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm3.6)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: PCV ~ breed + breed:time + (1 | animal_id:breed)
#>    Data: ex33
#> 
#> REML criterion at convergence: 782.8
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -2.7450 -0.4937  0.1392  0.6072  2.7366 
#> 
#> Random effects:
#>  Groups          Name        Variance Std.Dev.
#>  animal_id:breed (Intercept) 5.523    2.350   
#>  Residual                    4.943    2.223   
#> Number of obs: 168, groups:  animal_id:breed, 12
#> 
#> Fixed effects:
#>               Estimate Std. Error        df t value Pr(>|t|)    
#> (Intercept)   35.05944    1.05883  13.08757  33.112 5.24e-14 ***
#> breedBO       -0.83452    1.49743  13.08836  -0.557    0.587    
#> breedBO:time  -0.41434    0.02247 154.00045 -18.440  < 2e-16 ***
#> breedND:time  -0.27590    0.02242 154.00011 -12.307  < 2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) bredBO brdBO:
#> breedBO     -0.707              
#> breedBO:tim  0.000 -0.252       
#> breedND:tim -0.356  0.251  0.000
 anova(object = fm3.6, ddf = "Satterthwaite")
#> Type III Analysis of Variance Table with Satterthwaite's method
#>             Sum Sq Mean Sq NumDF   DenDF  F value Pr(>F)    
#> breed         1.54    1.54     1  13.088   0.3106 0.5867    
#> breed:time 2429.25 1214.63     2 154.000 245.7448 <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# PROC MIXED DATA=ex33;
# CLASS breed animal_id;
# MODEL pcv = breed breed*time/SOLUTION;
# REPEATED/TYPE=CS SUB = animal_id(breed) R;
# RUN;


 library(nlme)
#> 
#> Attaching package: ‘nlme’
#> The following object is masked from ‘package:lme4’:
#> 
#>     lmList
 fm3.7 <-
      nlme::gls(
            model       = PCV ~ breed + breed:time
          , data        = ex33
          , correlation = corCompSymm(, form = ~ 1|animal_id/breed)
          , weights     = NULL
        # , subset      =
          , method      = "REML" # c("REML", "ML")
          , na.action   = na.fail
          , control     = list()
          )
 if (requireNamespace("report", quietly = TRUE)) {
   try(report::report(fm3.7), silent = TRUE)
 }
 summary(fm3.7)
#> Generalized least squares fit by REML
#>   Model: PCV ~ breed + breed:time 
#>   Data: ex33 
#>        AIC     BIC    logLik
#>   794.8318 813.431 -391.4159
#> 
#> Correlation Structure: Compound symmetry
#>  Formula: ~1 | animal_id/breed 
#>  Parameter estimate(s):
#>       Rho 
#> 0.5277216 
#> 
#> Coefficients:
#>                 Value Std.Error   t-value p-value
#> (Intercept)  35.05944 1.0588267  33.11160  0.0000
#> breedBO      -0.83452 1.4974299  -0.55730  0.5781
#> breedBO:time -0.41434 0.0224703 -18.43951  0.0000
#> breedND:time -0.27590 0.0224172 -12.30747  0.0000
#> 
#>  Correlation: 
#>              (Intr) bredBO brdBO:
#> breedBO      -0.707              
#> breedBO:time  0.000 -0.252       
#> breedND:time -0.356  0.251  0.000
#> 
#> Standardized residuals:
#>        Min         Q1        Med         Q3        Max 
#> -2.0924486 -0.6122067 -0.1882516  0.6971169  2.6510489 
#> 
#> Residual standard error: 3.235044 
#> Degrees of freedom: 168 total; 164 residual
 anova(fm3.7)
#> Denom. DF: 164 
#>             numDF   F-value p-value
#> (Intercept)     1 1700.0770  <.0001
#> breed           1    5.0507  0.0259
#> breed:time      2  245.7448  <.0001



# PROC MIXED DATA=ex33;
# CLASS breed animal_id;
# MODEL pcv = time breed breed*time/SOLUTION;
# RANDOM animal_id(breed)/SOLUTION;
# RUN;

 fm3.8 <-
  lme4::lmer(
         formula    = PCV ~ time + breed + breed:time + (1|animal_id:breed)
       , data       = ex33
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(breed = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.8 |>
     report::report()
 }
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV with time and breed (formula: PCV ~ time + breed + breed:time).
#> The model included animal_id as random effects (formula: ~1 | animal_id:breed).
#> The model's total explanatory power is substantial (conditional R2 = 0.82) and
#> the part related to the fixed effects alone (marginal R2) is of 0.62. The
#> model's intercept, corresponding to time = 0 and breed = ND, is at 35.06 (95%
#> CI [32.97, 37.15], t(162) = 33.11, p < .001). Within this model:
#> 
#>   - The effect of time is statistically significant and negative (beta = -0.28,
#> 95% CI [-0.32, -0.23], t(162) = -12.31, p < .001; Std. beta = -0.58, 95% CI
#> [-0.67, -0.49])
#>   - The effect of breed [BO] is statistically non-significant and negative (beta
#> = -0.83, 95% CI [-3.79, 2.12], t(162) = -0.56, p = 0.578; Std. beta = -0.61,
#> 95% CI [-1.15, -0.08])
#>   - The effect of time × breed [BO] is statistically significant and negative
#> (beta = -0.14, 95% CI [-0.20, -0.08], t(162) = -4.36, p < .001; Std. beta =
#> -0.29, 95% CI [-0.42, -0.16])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 summary(fm3.8)
#> Linear mixed model fit by REML ['lmerMod']
#> Formula: PCV ~ time + breed + breed:time + (1 | animal_id:breed)
#>    Data: ex33
#> 
#> REML criterion at convergence: 782.8
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -2.7450 -0.4937  0.1392  0.6072  2.7366 
#> 
#> Random effects:
#>  Groups          Name        Variance Std.Dev.
#>  animal_id:breed (Intercept) 5.523    2.350   
#>  Residual                    4.943    2.223   
#> Number of obs: 168, groups:  animal_id:breed, 12
#> 
#> Fixed effects:
#>              Estimate Std. Error t value
#> (Intercept)  35.05944    1.05883  33.112
#> time         -0.27590    0.02242 -12.307
#> breedBO      -0.83452    1.49743  -0.557
#> time:breedBO -0.13844    0.03174  -4.362
#> 
#> Correlation of Fixed Effects:
#>             (Intr) time   bredBO
#> time        -0.356              
#> breedBO     -0.707  0.251       
#> time:bredBO  0.251 -0.706 -0.356
 anova(fm3.8)
#> Analysis of Variance Table
#>            npar  Sum Sq Mean Sq  F value
#> time          1 2335.02 2335.02 472.4249
#> breed         1   25.16   25.16   5.0904
#> time:breed    1   94.03   94.03  19.0249


 fm3.9 <-
  lmerTest::lmer(
         formula    = PCV ~ time + breed + breed:time + (1|animal_id:breed)
       , data       = ex33
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(breed = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.9 |>
     report::report()
 }
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV with time and breed (formula: PCV ~ time + breed + breed:time).
#> The model included animal_id as random effects (formula: ~1 | animal_id:breed).
#> The model's total explanatory power is substantial (conditional R2 = 0.82) and
#> the part related to the fixed effects alone (marginal R2) is of 0.62. The
#> model's intercept, corresponding to time = 0 and breed = ND, is at 35.06 (95%
#> CI [32.97, 37.15], t(162) = 33.11, p < .001). Within this model:
#> 
#>   - The effect of time is statistically significant and negative (beta = -0.28,
#> 95% CI [-0.32, -0.23], t(162) = -12.31, p < .001; Std. beta = -0.58, 95% CI
#> [-0.67, -0.49])
#>   - The effect of breed [BO] is statistically non-significant and negative (beta
#> = -0.83, 95% CI [-3.79, 2.12], t(162) = -0.56, p = 0.578; Std. beta = -0.61,
#> 95% CI [-1.15, -0.08])
#>   - The effect of time × breed [BO] is statistically significant and negative
#> (beta = -0.14, 95% CI [-0.20, -0.08], t(162) = -4.36, p < .001; Std. beta =
#> -0.29, 95% CI [-0.42, -0.16])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   trend3.9 <- emmeans::emtrends(
     fm3.9,
     ~ breed,
     var = "time",
     lmer.df = "asymptotic"
   )
   print(trend3.9)
   print(emmeans::contrast(trend3.9, method = "pairwise"))
 }
#>  breed time.trend     SE  df asymp.LCL asymp.UCL
#>  BO        -0.414 0.0225 Inf    -0.458    -0.370
#>  ND        -0.276 0.0224 Inf    -0.320    -0.232
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#>  contrast estimate     SE  df z.ratio p.value
#>  BO - ND    -0.138 0.0317 Inf  -4.362 <0.0001
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm3.9)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: PCV ~ time + breed + breed:time + (1 | animal_id:breed)
#>    Data: ex33
#> 
#> REML criterion at convergence: 782.8
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -2.7450 -0.4937  0.1392  0.6072  2.7366 
#> 
#> Random effects:
#>  Groups          Name        Variance Std.Dev.
#>  animal_id:breed (Intercept) 5.523    2.350   
#>  Residual                    4.943    2.223   
#> Number of obs: 168, groups:  animal_id:breed, 12
#> 
#> Fixed effects:
#>               Estimate Std. Error        df t value Pr(>|t|)    
#> (Intercept)   35.05944    1.05883  13.08757  33.112 5.24e-14 ***
#> time          -0.27590    0.02242 154.00011 -12.307  < 2e-16 ***
#> breedBO       -0.83452    1.49743  13.08836  -0.557    0.587    
#> time:breedBO  -0.13844    0.03174 154.00028  -4.362 2.35e-05 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) time   bredBO
#> time        -0.356              
#> breedBO     -0.707  0.251       
#> time:bredBO  0.251 -0.706 -0.356
 anova(object = fm3.9, ddf = "Satterthwaite", type = 3)
#> Type III Analysis of Variance Table with Satterthwaite's method
#>             Sum Sq Mean Sq NumDF   DenDF  F value    Pr(>F)    
#> time       2337.43 2337.43     1 154.000 472.9112 < 2.2e-16 ***
#> breed         1.54    1.54     1  13.088   0.3106    0.5867    
#> time:breed   94.03   94.03     1 154.000  19.0249 2.352e-05 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# PROC MIXED DATA=ex33;
# CLASS breed animal_id;
# MODEL pcv = breed breed*time/SOLUTION;
# REPEATED/TYPE=AR(1) SUBJET = animal_id(breed) R;
# RUN;


 library(nlme)
 fm3.10 <-
      nlme::gls(
            model       = PCV ~ breed + breed:time
          , data        = ex33
          , correlation = corAR1(, form = ~ 1|animal_id/breed)
          , weights     = NULL
        # , subset      =
          , method      = "REML" # c("REML", "ML")
          , na.action   = na.fail
          , control     = list()
          )
 if (requireNamespace("report", quietly = TRUE)) {
   try(report::report(fm3.10), silent = TRUE)
 }
 summary(fm3.10)
#> Generalized least squares fit by REML
#>   Model: PCV ~ breed + breed:time 
#>   Data: ex33 
#>        AIC      BIC    logLik
#>   804.5616 823.1608 -396.2808
#> 
#> Correlation Structure: AR(1)
#>  Formula: ~1 | animal_id/breed 
#>  Parameter estimate(s):
#>       Phi 
#> 0.6241789 
#> 
#> Coefficients:
#>                 Value Std.Error  t-value p-value
#> (Intercept)  35.08913 1.0471270 33.50991  0.0000
#> breedBO      -0.85157 1.4796797 -0.57551  0.5657
#> breedBO:time -0.43550 0.0483666 -9.00410  0.0000
#> breedND:time -0.28735 0.0484103 -5.93569  0.0000
#> 
#>  Correlation: 
#>              (Intr) bredBO brdBO:
#> breedBO      -0.708              
#> breedBO:time  0.000 -0.553       
#> breedND:time -0.783  0.554  0.000
#> 
#> Standardized residuals:
#>        Min         Q1        Med         Q3        Max 
#> -2.0668140 -0.5350802 -0.1433891  0.7629290  2.8190628 
#> 
#> Residual standard error: 3.195351 
#> Degrees of freedom: 168 total; 164 residual
 anova(fm3.10)
#> Denom. DF: 164 
#>             numDF  F-value p-value
#> (Intercept)     1 3839.638  <.0001
#> breed           1   13.197   4e-04
#> breed:time      2   58.153  <.0001

# PROC MIXED DATA=ex33;
# CLASS breed animal_id;
# MODEL pcv = breed breed*time/SOLUTION;
# RANDOM INTERCEPT time/TYPE=UN SUBJET = animal_id(breed) SOLUTION;
# RUN;


 library(nlme)
# fm3.11 <-
#      nlme::gls(
#            model       = PCV ~ breed + breed:time
#          , data        = ex33
#          , random      = ~1|animal_id/breed
#          , correlation = corAR1(, form = ~ 1|animal_id/breed)
#          , weights     = NULL
#        # , subset      =
#          , method      = "REML" # c("REML", "ML")
#          , na.action   = na.fail
#          , control     = list()
#          )
# summary(fm3.11)
# anova(fm3.11)
```
