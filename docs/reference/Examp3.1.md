# Examp3.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp3.1 is.

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
## Example 3.1 Model 1 p-80
#-------------------------------------------------------------
# PROC MIXED DATA=ex31;
# CLASS drug dose herd;
# MODEL PCV2=drug dose(drug)/solution ddfm=satterth;
# RANDOM herd(drug);
# ESTIMATE 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;
# ESTIMATE 'Berenil 2 doses' dose(drug) 1 -1 0;
# ESTIMATE 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -1;
# CONTRAST 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;
# CONTRAST 'Berenil dif 2 doses' dose(drug) 1 -1 0;
# CONTRAST 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -l;
# CONTRAST 'some difference' drug 1 -1 dose(drug) 0.5 0.5 -1,
#           drug 0 0 dose(drug) 1 -1 0;
# LSMEANS dose(drug);
# RUN;

 library(lmerTest)
 str(ex31)
#> 'data.frame':    38 obs. of  6 variables:
#>  $ herd     : int  1 1 1 1 1 1 1 1 1 2 ...
#>  $ animal_id: int  667 1003 1177 227 241 271 44 48 233 1368 ...
#>  $ PCV1     : int  17 22 20 22 22 18 22 21 18 18 ...
#>  $ PCV2     : int  28 23 28 25 23 18 27 20 30 20 ...
#>  $ dose     : int  1 1 1 2 2 2 1 1 1 1 ...
#>  $ drug     : Factor w/ 2 levels "BERENIL","SAMORIN": 1 1 1 1 1 1 2 2 2 1 ...
 ex31 <-
   ex31 |>
   collapse::fmutate(
     herd1 = factor(herd),
     drug1 = factor(drug),
     dose1 = factor(dose),
     ber = as.integer(drug == "BERENIL"),
     ber1 = as.integer(drug == "BERENIL" & dose == 1L),
     pcv_ber1 = PCV1 * as.integer(drug == "BERENIL" & dose == 1L),
     pcv_ber2 = PCV1 * as.integer(drug == "BERENIL" & dose == 2L)
   )

 fm3.1 <-
  lmerTest::lmer(
         formula    = PCV2 ~ drug1 + dose1:drug1 + (1|herd1:drug1)
       , data       = ex31
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.1 |>
     report::report()
 }
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV2 with drug1 and dose1 (formula: PCV2 ~ drug1 + dose1:drug1). The
#> model included herd1 as random effects (formula: ~1 | herd1:drug1). The model's
#> total explanatory power is weak (conditional R2 = 0.12) and the part related to
#> the fixed effects alone (marginal R2) is of 0.06. The model's intercept,
#> corresponding to drug1 = BERENIL and dose1 = 1, is at 24.17 (95% CI [22.05,
#> 26.28], t(33) = 23.28, p < .001). Within this model:
#> 
#>   - The effect of drug1 [BERENIL] is statistically non-significant and positive
#> (beta = 1.10, 95% CI [-1.80, 4.00], t(33) = 0.77, p = 0.445; Std. beta = 0.32,
#> 95% CI [-0.53, 1.17])
#>   - The effect of drug1 [BERENIL] × dose11 is statistically non-significant and
#> negative (beta = -2.10, 95% CI [-4.75, 0.55], t(33) = -1.61, p = 0.116; Std.
#> beta = -0.61, 95% CI [-1.39, 0.16])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   emm3.1 <- emmeans::emmeans(fm3.1, ~ dose1 | drug1, lmer.df = "asymptotic")
   print(emm3.1)
   print(emmeans::contrast(emm3.1, method = "pairwise"))
 }
#> NOTE: A nesting structure was detected in the fitted model:
#>     dose1 %in% drug1
#> drug1 = BERENIL:
#>  dose1 emmean    SE  df asymp.LCL asymp.UCL
#>  1       23.2 1.040 Inf      21.1      25.2
#>  2       25.3 0.977 Inf      23.4      27.2
#> 
#> drug1 = SAMORIN:
#>  dose1 emmean    SE  df asymp.LCL asymp.UCL
#>  1       24.2 1.040 Inf      22.1      26.2
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#> drug1 = BERENIL:
#>  contrast        estimate  SE  df z.ratio p.value
#>  dose11 - dose12     -2.1 1.3 Inf  -1.612  0.1069
#> 
#> drug1 = SAMORIN:
#>  contrast        estimate  SE  df z.ratio p.value
#>  (nothing)         nonEst  NA  NA      NA      NA
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm3.1)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: PCV2 ~ drug1 + dose1:drug1 + (1 | herd1:drug1)
#>    Data: ex31
#> 
#> REML criterion at convergence: 192.1
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -2.19435 -0.64365  0.04272  0.47738  1.69413 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  herd1:drug1 (Intercept)  0.6682  0.8175  
#>  Residual                10.9299  3.3060  
#> Number of obs: 38, groups:  herd1:drug1, 8
#> 
#> Fixed effects:
#>                     Estimate Std. Error     df t value Pr(>|t|)    
#> (Intercept)           24.167      1.038 15.358  23.277 2.14e-13 ***
#> drug1BERENIL           1.102      1.426 13.734   0.773    0.453    
#> drug1BERENIL:dose11   -2.102      1.303 31.520  -1.612    0.117    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dr1BERENIL
#> drg1BERENIL -0.728           
#> d1BERENIL:1  0.000 -0.424    
#> fit warnings:
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
 anova(object = fm3.1, ddf = "Satterthwaite")
#> Missing cells for: drug1SAMORIN:dose12.  
#> Interpret type III hypotheses with care.
#> Type III Analysis of Variance Table with Satterthwaite's method
#>              Sum Sq Mean Sq NumDF  DenDF F value Pr(>F)
#> drug1        5.0701  5.0701     1 15.358  0.4639 0.5060
#> drug1:dose1 28.4190 28.4190     1 31.520  2.6001 0.1168
 lsmeansLT(model = fm3.1, test.effs = "dose1:drug1")
#> Least Squares Means table:
#> 
#>                     Estimate Std. Error   df t value    lower    upper
#> drug1BERENIL        24.21745    0.76923  5.3  31.483 22.26991 26.16499
#> drug1SAMORIN              NA         NA   NA      NA       NA       NA
#> drug1BERENIL:dose11 23.16667    1.03821 15.4  22.314 20.95825 25.37508
#> drug1SAMORIN:dose11 24.16667    1.03821 15.4  23.277 21.95825 26.37508
#> drug1BERENIL:dose12 25.26823    0.97716 12.1  25.859 23.14188 27.39459
#> drug1SAMORIN:dose12       NA         NA   NA      NA       NA       NA
#>                      Pr(>|t|)    
#> drug1BERENIL        3.348e-07 ***
#> drug1SAMORIN               NA    
#> drug1BERENIL:dose11 4.024e-13 ***
#> drug1SAMORIN:dose11 2.140e-13 ***
#> drug1BERENIL:dose12 5.494e-12 ***
#> drug1SAMORIN:dose12        NA    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#>   Confidence level: 95%
#>   Degrees of freedom method: Satterthwaite 

#-------------------------------------------------------------
## Example 3.1 Model 2 p-84
#-------------------------------------------------------------
# PROC MIXED DATA=ex31;
# CLASS drug dose herd;
# MODEL PCV2=PCV1 drug dose(drug)/solution ddfm=satterth;
# RANDOM herd(drug);
# RUN;

 fm3.2 <-
  lmerTest::lmer(
         formula    = PCV2 ~ PCV1 + drug1 + dose1:drug1 + (1|herd1:drug1)
       , data       = ex31
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.2 |>
     report::report()
 }
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV2 with PCV1, drug1 and dose1 (formula: PCV2 ~ PCV1 + drug1 +
#> dose1:drug1). The model included herd1 as random effects (formula: ~1 |
#> herd1:drug1). The model's total explanatory power is weak (conditional R2 =
#> 0.11) and the part related to the fixed effects alone (marginal R2) is of 0.06.
#> The model's intercept, corresponding to PCV1 = 0, drug1 = BERENIL and dose1 =
#> 1, is at 23.64 (95% CI [11.28, 36.00], t(32) = 3.90, p < .001). Within this
#> model:
#> 
#>   - The effect of PCV1 is statistically non-significant and positive (beta =
#> 0.03, 95% CI [-0.57, 0.62], t(32) = 0.09, p = 0.930; Std. beta = 0.01, 95% CI
#> [-0.33, 0.36])
#>   - The effect of drug1 [BERENIL] is statistically non-significant and positive
#> (beta = 1.13, 95% CI [-1.85, 4.12], t(32) = 0.77, p = 0.446; Std. beta = 0.33,
#> 95% CI [-0.54, 1.20])
#>   - The effect of drug1 [BERENIL] × dose11 is statistically non-significant and
#> negative (beta = -2.13, 95% CI [-4.90, 0.63], t(32) = -1.57, p = 0.126; Std.
#> beta = -0.62, 95% CI [-1.43, 0.18])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   emm3.2 <- emmeans::emmeans(fm3.2, ~ dose1 | drug1, lmer.df = "asymptotic")
   print(emm3.2)
   print(emmeans::contrast(emm3.2, method = "pairwise"))
 }
#> NOTE: A nesting structure was detected in the fitted model:
#>     dose1 %in% drug1
#> drug1 = BERENIL:
#>  dose1 emmean   SE  df asymp.LCL asymp.UCL
#>  1       23.2 1.06 Inf      21.1      25.2
#>  2       25.3 1.00 Inf      23.3      27.3
#> 
#> drug1 = SAMORIN:
#>  dose1 emmean   SE  df asymp.LCL asymp.UCL
#>  1       24.2 1.05 Inf      22.1      26.2
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#> drug1 = BERENIL:
#>  contrast        estimate   SE  df z.ratio p.value
#>  dose11 - dose12    -2.13 1.36 Inf  -1.571  0.1161
#> 
#> drug1 = SAMORIN:
#>  contrast        estimate   SE  df z.ratio p.value
#>  (nothing)         nonEst   NA  NA      NA      NA
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm3.2)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: PCV2 ~ PCV1 + drug1 + dose1:drug1 + (1 | herd1:drug1)
#>    Data: ex31
#> 
#> REML criterion at convergence: 192.8
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -2.14932 -0.63140  0.05373  0.47166  1.69087 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  herd1:drug1 (Intercept)  0.6391  0.7994  
#>  Residual                11.2803  3.3586  
#> Number of obs: 38, groups:  herd1:drug1, 8
#> 
#> Fixed effects:
#>                     Estimate Std. Error       df t value Pr(>|t|)    
#> (Intercept)         23.64038    6.06889 33.91516   3.895 0.000438 ***
#> PCV1                 0.02567    0.29159 33.74677   0.088 0.930362    
#> drug1BERENIL         1.13037    1.46551 13.70396   0.771 0.453615    
#> drug1BERENIL:dose11 -2.13251    1.35725 30.87596  -1.571 0.126329    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) PCV1   dr1BERENIL
#> PCV1        -0.985                  
#> drg1BERENIL -0.308  0.187           
#> d1BERENIL:1  0.217 -0.220 -0.450    
#> fit warnings:
#> fixed-effect model matrix is rank deficient so dropping 1 column / coefficient
 anova(object = fm3.2, ddf = "Satterthwaite")
#> Missing cells for: drug1SAMORIN:dose12.  
#> Interpret type III hypotheses with care.
#> Type III Analysis of Variance Table with Satterthwaite's method
#>              Sum Sq Mean Sq NumDF  DenDF F value Pr(>F)
#> PCV1         0.0874  0.0874     1 33.747  0.0078 0.9304
#> drug1        5.1489  5.1489     1 14.799  0.4565 0.5097
#> drug1:dose1 27.8474 27.8474     1 30.876  2.4687 0.1263
 lsmeansLT(model = fm3.2, test.effs = "herd1:drug1")
#> Least Squares Means table:
#> 
#>                     Estimate Std. Error   df t value    lower    upper
#> drug1BERENIL        24.22268    0.77398  4.9  31.296 22.22655 26.21880
#> drug1SAMORIN              NA         NA   NA      NA       NA       NA
#> drug1BERENIL:dose11 23.15642    1.05515 15.0  21.946 20.90761 25.40523
#> drug1SAMORIN:dose11 24.15856    1.05275 14.9  22.948 21.91379 26.40333
#> drug1BERENIL:dose12 25.28893    1.00290 12.0  25.216 23.10450 27.47336
#> drug1SAMORIN:dose12       NA         NA   NA      NA       NA       NA
#>                      Pr(>|t|)    
#> drug1BERENIL        7.056e-07 ***
#> drug1SAMORIN               NA    
#> drug1BERENIL:dose11 8.033e-13 ***
#> drug1SAMORIN:dose11 4.672e-13 ***
#> drug1BERENIL:dose12 8.709e-12 ***
#> drug1SAMORIN:dose12        NA    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#>   Confidence level: 95%
#>   Degrees of freedom method: Satterthwaite 

#-------------------------------------------------------------
## Example 3.1 Model 3 p-86
#-------------------------------------------------------------
# PROC MIXED DATA=ex31;
# CLASS drug dose herd;
# MODEL PCV2=drug dose(drug) PCV1*dose(drug)/solution ddfm=satterth;
# RANDOM herd(drug);
# RUN;

 fm3.3 <-
  lmerTest::lmer(
         formula    = PCV2 ~ drug1 + PCV1*dose1:drug1 + (1|herd1:drug1)
       , data       = ex31
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.3 |>
     report::report()
 }
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict PCV2 with drug1, PCV1 and dose1 (formula: PCV2 ~ drug1 + PCV1 *
#> dose1:drug1). The model included herd1 as random effects (formula: ~1 |
#> herd1:drug1). The model's total explanatory power is moderate (conditional R2 =
#> 0.14) and the part related to the fixed effects alone (marginal R2) is of 0.09.
#> The model's intercept, corresponding to drug1 = BERENIL, PCV1 = 0 and dose1 =
#> 1, is at 33.12 (95% CI [2.67, 63.57], t(30) = 2.22, p = 0.034). Within this
#> model:
#> 
#>   - The effect of drug1 [BERENIL] is statistically non-significant and negative
#> (beta = -13.83, 95% CI [-47.83, 20.17], t(30) = -0.83, p = 0.413; Std. beta =
#> 0.34, 95% CI [-0.55, 1.22])
#>   - The effect of PCV1 is statistically non-significant and positive (beta =
#> 0.31, 95% CI [-0.46, 1.07], t(30) = 0.82, p = 0.421; Std. beta = 0.18, 95% CI
#> [-0.27, 0.62])
#>   - The effect of drug1 [BERENIL] × dose11 is statistically non-significant and
#> positive (beta = 12.13, 95% CI [-17.95, 42.21], t(30) = 0.82, p = 0.417; Std.
#> beta = -0.62, 95% CI [-1.45, 0.20])
#>   - The effect of drug1 [BERENIL] × PCV1 × dose11 is statistically
#> non-significant and negative (beta = -0.71, 95% CI [-2.18, 0.77], t(30) =
#> -0.98, p = 0.335; Std. beta = -0.41, 95% CI [-1.26, 0.44])
#>   - The effect of drug1SAMORIN × PCV1 × dose11 is statistically non-significant
#> and negative (beta = -0.74, 95% CI [-2.41, 0.93], t(30) = -0.91, p = 0.371;
#> Std. beta = -0.43, 95% CI [-1.40, 0.54])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   emm3.3 <- emmeans::emmeans(fm3.3, ~ dose1 | drug1, lmer.df = "asymptotic")
   print(emm3.3)
   print(emmeans::contrast(emm3.3, method = "pairwise"))
 }
#> NOTE: A nesting structure was detected in the fitted model:
#>     dose1 %in% drug1
#> NOTE: Results may be misleading due to involvement in interactions
#> drug1 = BERENIL:
#>  dose1 emmean   SE  df asymp.LCL asymp.UCL
#>  1       23.3 1.09 Inf      21.2      25.5
#>  2       25.5 1.02 Inf      23.5      27.5
#> 
#> drug1 = SAMORIN:
#>  dose1 emmean   SE  df asymp.LCL asymp.UCL
#>  1       24.3 1.08 Inf      22.2      26.4
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#> drug1 = BERENIL:
#>  contrast        estimate   SE  df z.ratio p.value
#>  dose11 - dose12    -2.13 1.38 Inf  -1.548  0.1217
#> 
#> drug1 = SAMORIN:
#>  contrast        estimate   SE  df z.ratio p.value
#>  (nothing)         nonEst   NA  NA      NA      NA
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm3.3)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: PCV2 ~ drug1 + PCV1 * dose1:drug1 + (1 | herd1:drug1)
#>    Data: ex31
#> 
#> REML criterion at convergence: 188.8
#> 
#> Scaled residuals: 
#>      Min       1Q   Median       3Q      Max 
#> -2.03785 -0.67127  0.06847  0.62206  1.47702 
#> 
#> Random effects:
#>  Groups      Name        Variance Std.Dev.
#>  herd1:drug1 (Intercept)  0.6475  0.8046  
#>  Residual                11.4692  3.3866  
#> Number of obs: 38, groups:  herd1:drug1, 8
#> 
#> Fixed effects:
#>                          Estimate Std. Error       df t value Pr(>|t|)  
#> (Intercept)               33.1192    14.9092  31.5039   2.221   0.0336 *
#> drug1BERENIL             -13.8326    16.6481  31.8493  -0.831   0.4122  
#> PCV1                       0.3058     0.3752  30.9513   0.815   0.4212  
#> drug1BERENIL:dose11       12.1279    14.7286  31.0475   0.823   0.4165  
#> drug1BERENIL:PCV1:dose11  -0.7065     0.7218  31.0117  -0.979   0.3352  
#> drug1SAMORIN:PCV1:dose11  -0.7425     0.8167  31.8994  -0.909   0.3701  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) dr1BERENIL PCV1   d1BERENIL:1 d1BERENIL:P
#> drg1BERENIL -0.896                                          
#> PCV1         0.000 -0.441                                   
#> d1BERENIL:1  0.000 -0.221      0.494                        
#> d1BERENIL:P  0.000  0.227     -0.515 -0.996                 
#> d1SAMORIN:P -0.886  0.996     -0.459 -0.227       0.237     
#> fit warnings:
#> fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
 anova(object = fm3.3, ddf = "Satterthwaite")
#> Missing cells for: drug1SAMORIN:dose12, drug1SAMORIN:PCV1:dose12.  
#> Interpret type III hypotheses with care.
#> Type III Analysis of Variance Table with Satterthwaite's method
#>                   Sum Sq Mean Sq NumDF  DenDF F value Pr(>F)
#> drug1             0.0864  0.0864     1 31.982  0.0075 0.9314
#> PCV1              7.6204  7.6204     1 30.951  0.6644 0.4212
#> drug1:dose1       7.7764  7.7764     1 31.048  0.6780 0.4165
#> drug1:PCV1:dose1 16.5665  8.2832     2 31.918  0.7222 0.4934
 lsmeansLT(model = fm3.3, test.effs = "dose1:drug1")
#> Least Squares Means table:
#> 
#>                     Estimate Std. Error   df t value    lower    upper
#> drug1BERENIL        24.39310    0.79713  5.1  30.601 22.35878 26.42743
#> drug1SAMORIN              NA         NA   NA      NA       NA       NA
#> drug1BERENIL:dose11 23.32660    1.08564 15.0  21.486 21.01278 25.64041
#> drug1SAMORIN:dose11 24.30457    1.08172 14.7  22.468 21.99515 26.61400
#> drug1BERENIL:dose12 25.45960    1.02085 11.8  24.940 23.23211 27.68710
#> drug1SAMORIN:dose12       NA         NA   NA      NA       NA       NA
#>                      Pr(>|t|)    
#> drug1BERENIL        5.327e-07 ***
#> drug1SAMORIN               NA    
#> drug1BERENIL:dose11 1.096e-12 ***
#> drug1SAMORIN:dose11 8.388e-13 ***
#> drug1BERENIL:dose12 1.328e-11 ***
#> drug1SAMORIN:dose12        NA    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#>   Confidence level: 95%
#>   Degrees of freedom method: Satterthwaite 
```
