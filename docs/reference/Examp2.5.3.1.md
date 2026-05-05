# Examp2.5.3.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp2.5.3.1 is used for inspecting probability distribution and to
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
## Example 2.5.3.1 p-70
#-------------------------------------------------------------
 # PROC GLM DATA=ex125;
 # CLASS drug dose region;
 # MODEL pcv=region drug region*drug dose drug*dose;
 # RANDOM region drug*region;
 # RUN;


 # PROC MIXED DATA=ex125;
 # CLASS drug dose region;
 # MODEL pcv=drug dose drug*dose / ddfm=satterth;
 # RANDOM region drug*region;
 # ESTIMATE 'drug dif' drug -1 1 drug*dose -0.5 -0.5 0.5 0.5;
 # ESTIMATE 'Samorin mean' INTERCEPT 1 drug 0 1 dose 0.5 0.5
 #                             drug*dose 0 0 0.5 0.5;
 # ESTIMATE 'Samorin HvsL' dose 1 -1 drug*dose 0 0 1 -1;
 # ESTIMATE 'Samorin high' INTERCEPT 1 drug 0 1 dose 1 0
 #                             drug*dose 0 0 1 0;
 # RUN;

library(lme4)
str(ex125)
#> 'data.frame':    24 obs. of  4 variables:
#>  $ Region: int  1 1 1 1 2 2 2 2 3 3 ...
#>  $ Drug  : Factor w/ 2 levels "BERENIL","samorin": 1 1 2 2 1 1 2 2 1 1 ...
#>  $ dose  : Factor w/ 2 levels "h","l": 1 2 1 2 1 2 1 2 1 2 ...
#>  $ Pcv   : num  22.6 21.8 19.1 16.4 29 28.8 25.3 18.2 24 23.7 ...
ex125 <-
  ex125 |>
  collapse::fmutate(Region1 = factor(Region))
 fm2.11 <-
  aov(
      formula     = Pcv ~ Region1 + Drug + Error(Drug:Region1) + dose + dose:Drug
    , data        = ex125
    , projections = FALSE
    , qr          = TRUE
    , contrasts   = NULL
  #  , ...
    )
#> Warning: Error() model is singular
 if (requireNamespace("report", quietly = TRUE)) {
   fm2.11 |>
     report::report()
 }
#> The repeated-measures ANOVA (formula: Pcv ~ Region1 + Drug +
#> Error(Drug:Region1) + dose + dose:Drug) suggests that:
#> 
#>   - The main effect of dose is statistically significant and large (F(1, 10) =
#> 21.78, p < .001; Eta2 (partial) = 0.89, 95% CI [0.39, 1.00])
#>   - The interaction between Drug and dose is statistically significant and large
#> (F(1, 10) = 7.25, p = 0.023; Eta2 (partial) = 0.93, 95% CI [0.71, 1.00])
#>   - The main effect of Drug is statistically NA and large (F(, 10) = , ; Eta2
#> (partial) = 0.69, 95% CI [0.33, 1.00])
#>   - The main effect of Region1 is statistically NA and large (F(, 10) = , ; Eta2
#> (partial) = 0.42, 95% CI [0.05, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
 summary(fm2.11)
#> 
#> Error: Drug:Region1
#>           Df Sum Sq Mean Sq F value   Pr(>F)    
#> Region1    5 117.37   23.47   8.178 0.018857 *  
#> Drug       1 185.37  185.37  64.580 0.000483 ***
#> Residuals  5  14.35    2.87                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Error: Within
#>           Df Sum Sq Mean Sq F value   Pr(>F)    
#> dose       1  45.65   45.65  21.775 0.000886 ***
#> Drug:dose  1  15.20   15.20   7.251 0.022594 *  
#> Residuals 10  20.96    2.10                     
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

 fm2.12 <-
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
       , contrasts  = list(dose = "contr.SAS", Drug = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
 if (requireNamespace("report", quietly = TRUE)) {
   fm2.12 |>
     report::report()
 }
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Pcv with dose and Drug (formula: Pcv ~ dose * Drug). The model
#> included Drug as random effects (formula: list(~1 | Drug:Region, ~1 | Region)).
#> The model's total explanatory power is substantial (conditional R2 = 0.89) and
#> the part related to the fixed effects alone (marginal R2) is of 0.58. The
#> model's intercept, corresponding to dose = h and Drug = BERENIL, is at 17.13
#> (95% CI [14.75, 19.51], t(17) = 15.19, p < .001). Within this model:
#> 
#>   - The effect of dose [h] is statistically significant and positive (beta =
#> 4.35, 95% CI [2.59, 6.11], t(17) = 5.20, p < .001; Std. beta = 1.04, 95% CI
#> [0.62, 1.47])
#>   - The effect of Drug [BERENIL] is statistically significant and positive (beta
#> = 7.15, 95% CI [5.23, 9.07], t(17) = 7.86, p < .001; Std. beta = 1.72, 95% CI
#> [1.26, 2.18])
#>   - The effect of dose [h] × Drug [BERENIL] is statistically significant and
#> negative (beta = -3.18, 95% CI [-5.68, -0.69], t(17) = -2.69, p = 0.015; Std.
#> beta = -0.76, 95% CI [-1.36, -0.17])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   emm2.12 <- emmeans::emmeans(fm2.12, ~ dose | Drug, lmer.df = "asymptotic")
   print(emm2.12)
   print(emmeans::contrast(emm2.12, method = "pairwise"))
 }
#> Drug = BERENIL:
#>  dose emmean   SE  df asymp.LCL asymp.UCL
#>  h      25.4 1.13 Inf      23.2      27.7
#>  l      24.3 1.13 Inf      22.1      26.5
#> 
#> Drug = samorin:
#>  dose emmean   SE  df asymp.LCL asymp.UCL
#>  h      21.5 1.13 Inf      19.3      23.7
#>  l      17.1 1.13 Inf      14.9      19.3
#> 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#> Drug = BERENIL:
#>  contrast estimate    SE  df z.ratio p.value
#>  h - l        1.17 0.836 Inf   1.396  0.1628
#> 
#> Drug = samorin:
#>  contrast estimate    SE  df z.ratio p.value
#>  h - l        4.35 0.836 Inf   5.204 <0.0001
#> 
#> Degrees-of-freedom method: asymptotic 
 summary(fm2.12)
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
#> (Intercept)        17.1333     1.1280  8.2080  15.189 2.69e-07 ***
#> doseh               4.3500     0.8359 10.0000   5.204 0.000399 ***
#> DrugBERENIL         7.1500     0.9098 11.8185   7.859 4.96e-06 ***
#> doseh:DrugBERENIL  -3.1833     1.1822 10.0000  -2.693 0.022595 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>             (Intr) doseh  DBEREN
#> doseh       -0.371              
#> DrugBERENIL -0.403  0.459       
#> ds:DBERENIL  0.262 -0.707 -0.650
 anova(object = fm2.12, ddf = "Satterthwaite")
#> Type III Analysis of Variance Table with Satterthwaite's method
#>           Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)    
#> dose       45.65   45.65     1    10 21.7754 0.0008856 ***
#> Drug      135.39  135.39     1     5 64.5796 0.0004826 ***
#> dose:Drug  15.20   15.20     1    10  7.2507 0.0225945 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

library(multcomp)
Contrasts1 <-
          matrix(c(
                  1, 0.5, 0, 0
                , 0, 0, -1, -0.5
                , 1, 1, 0, 0
                , 0, 1, 0, 0
                )
               , ncol = 4
               , byrow = TRUE
               , dimnames = list(
                  c("C1", "C2", "C3", "C4")
                , rownames(summary(fm2.12)$coef)
               )
              )

Contrasts1
#>    (Intercept) doseh DrugBERENIL doseh:DrugBERENIL
#> C1           1   0.5           0               0.0
#> C2           0   0.0          -1              -0.5
#> C3           1   1.0           0               0.0
#> C4           0   1.0           0               0.0
summary(glht(fm2.12, linfct=Contrasts1))
#> 
#>   Simultaneous Tests for General Linear Hypotheses
#> 
#> Fit: lmerTest::lmer(formula = Pcv ~ dose * Drug + (1 | Region/Drug), 
#>     data = ex125, REML = TRUE, control = lmerControl(), start = NULL, 
#>     verbose = 0L, contrasts = list(dose = "contr.SAS", Drug = "contr.SAS"), 
#>     devFunOnly = FALSE)
#> 
#> Linear Hypotheses:
#>         Estimate Std. Error z value Pr(>|z|)    
#> C1 == 0  19.3083     1.0477  18.429  < 1e-07 ***
#> C2 == 0  -5.5583     0.6917  -8.036  < 1e-07 ***
#> C3 == 0  21.4833     1.1280  19.046  < 1e-07 ***
#> C4 == 0   4.3500     0.8359   5.204 7.21e-07 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> (Adjusted p values reported -- single-step method)
#> 
```
