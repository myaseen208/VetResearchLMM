# Examp2.5.2.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp2.5.2.1 is used for inspecting probability distribution and to
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
## Example 2.5.2.1 p-68
#-------------------------------------------------------------
 # PROC MIXED DATA=ex125;
 # CLASS drug dose region;
 # MODEL pcv=drug dose drug*dose / solution covb;
 # RANDOM region drug*region;
 # LSMEANS drug*dose;
 # RUN;

library(lmerTest)
str(ex125)
#> 'data.frame':    24 obs. of  4 variables:
#>  $ Region: int  1 1 1 1 2 2 2 2 3 3 ...
#>  $ Drug  : Factor w/ 2 levels "BERENIL","samorin": 1 1 2 2 1 1 2 2 1 1 ...
#>  $ dose  : Factor w/ 2 levels "h","l": 1 2 1 2 1 2 1 2 1 2 ...
#>  $ Pcv   : num  22.6 21.8 19.1 16.4 29 28.8 25.3 18.2 24 23.7 ...

fm2.10 <-
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
  fm2.10 |>
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
  emm2.10 <- emmeans::emmeans(fm2.10, ~ dose | Drug, lmer.df = "asymptotic")
  print(emm2.10)
  print(emmeans::contrast(emm2.10, method = "pairwise"))
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
summary(fm2.10)
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
anova(fm2.10)
#> Type III Analysis of Variance Table with Satterthwaite's method
#>           Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)    
#> dose       45.65   45.65     1    10 21.7754 0.0008856 ***
#> Drug      135.39  135.39     1     5 64.5796 0.0004826 ***
#> dose:Drug  15.20   15.20     1    10  7.2507 0.0225945 *  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
summary(fm2.10)$vcov
#> 4 x 4 Matrix of class "dpoMatrix"
#>                   (Intercept)      doseh DrugBERENIL doseh:DrugBERENIL
#> (Intercept)         1.2723747 -0.3494028  -0.4139028         0.3494028
#> doseh              -0.3494028  0.6988057   0.3494028        -0.6988057
#> DrugBERENIL        -0.4139028  0.3494028   0.8278056        -0.6988057
#> doseh:DrugBERENIL   0.3494028 -0.6988057  -0.6988057         1.3976114
lsmeansLT(model = fm2.10)
#> Least Squares Means table:
#> 
#>                   Estimate Std. Error  df t value   lower   upper  Pr(>|t|)    
#> doseh              23.4667     1.0322 5.9  22.735 20.9316 26.0018 5.592e-07 ***
#> dosel              20.7083     1.0322 5.9  20.062 18.1732 23.2434 1.161e-06 ***
#> DrugBERENIL        24.8667     1.0477 6.2  23.735 22.3234 27.4099 2.515e-07 ***
#> Drugsamorin        19.3083     1.0477 6.2  18.429 16.7651 21.8516 1.185e-06 ***
#> doseh:DrugBERENIL  25.4500     1.1280 8.2  22.562 22.8603 28.0397 1.120e-08 ***
#> dosel:DrugBERENIL  24.2833     1.1280 8.2  21.528 21.6936 26.8731 1.637e-08 ***
#> doseh:Drugsamorin  21.4833     1.1280 8.2  19.046 18.8936 24.0731 4.396e-08 ***
#> dosel:Drugsamorin  17.1333     1.1280 8.2  15.189 14.5436 19.7231 2.688e-07 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#>   Confidence level: 95%
#>   Degrees of freedom method: Satterthwaite 
```
