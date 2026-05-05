# Examp3.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp3.2 is used for inspecting probability distribution and to define a
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
## Example 3.3 p-88
#-------------------------------------------------------------
# PROC MIXED DATA=ex32;
# CLASS sex sire_id breed;
# MODEL ww = sex agew breed/SOLUTION DDFM=SATTERTH;
# RANDOM sire_id(breed)/SOLUTION;
# LSMEANS breed/ADJUST = TUKEY;
# RUN;

 library(lmerTest)
 str(ex32)
#> 'data.frame':    65 obs. of  5 variables:
#>  $ breed  : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ sire_id: int  1971 1971 1971 1971 1972 1972 1972 1972 1972 1972 ...
#>  $ sex    : Factor w/ 2 levels "F","M": 1 1 1 2 1 2 1 1 2 1 ...
#>  $ agew   : int  145 140 140 122 152 151 146 139 132 131 ...
#>  $ Ww     : num  11.2 15.4 10.9 11.4 16 13.2 14.9 7.9 15.7 13.1 ...
 ex32 <-
   ex32 |>
   collapse::fmutate(
     sire_id1 = factor(sire_id),
     breed1 = factor(breed)
   )

 fm3.4 <-
  lmerTest::lmer(
         formula    = Ww ~ sex + agew + breed1 + (1|sire_id1:breed1)
       , data       = ex32
       , REML       = TRUE
       , control    = lmerControl()
       , start      = NULL
       , verbose    = 0L
    #  , subset
    #  , weights
    #  , na.action
    #  , offset
       , contrasts  = list(sex = "contr.SAS", breed1 = "contr.SAS")
       , devFunOnly = FALSE
    #  , ...
       )
#> boundary (singular) fit: see help('isSingular')
 if (requireNamespace("report", quietly = TRUE)) {
   fm3.4 |>
     report::report()
 }
#> boundary (singular) fit: see help('isSingular')
#> Random effect variances not available. Returned R2 does not account for random effects.
#> boundary (singular) fit: see help('isSingular')
#> Random effect variances not available. Returned R2 does not account for random effects.
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Ww with sex, agew and breed1 (formula: Ww ~ sex + agew + breed1).
#> The model included sire_id1 as random effects (formula: ~1 | sire_id1:breed1).
#> The model's explanatory power related to the fixed effects alone (marginal R2)
#> is 0.48. The model's intercept, corresponding to sex = F, agew = 0 and breed1 =
#> 1, is at -0.36 (95% CI [-6.63, 5.91], t(55) = -0.12, p = 0.908). Within this
#> model:
#> 
#>   - The effect of sex [F] is statistically significant and negative (beta =
#> -1.44, 95% CI [-2.67, -0.21], t(55) = -2.34, p = 0.023; Std. beta = -0.46, 95%
#> CI [-0.85, -0.07])
#>   - The effect of agew is statistically significant and positive (beta = 0.08,
#> 95% CI [0.04, 0.13], t(55) = 3.50, p < .001; Std. beta = 0.45, 95% CI [0.19,
#> 0.71])
#>   - The effect of breed1 [1] is statistically significant and positive (beta =
#> 3.07, 95% CI [0.80, 5.35], t(55) = 2.70, p = 0.009; Std. beta = 0.98, 95% CI
#> [0.25, 1.70])
#>   - The effect of breed1 [2] is statistically non-significant and positive (beta
#> = 2.35, 95% CI [-0.11, 4.80], t(55) = 1.91, p = 0.061; Std. beta = 0.75, 95% CI
#> [-0.04, 1.53])
#>   - The effect of breed1 [3] is statistically non-significant and positive (beta
#> = 0.55, 95% CI [-2.15, 3.25], t(55) = 0.41, p = 0.686; Std. beta = 0.17, 95% CI
#> [-0.68, 1.03])
#>   - The effect of breed1 [4] is statistically significant and positive (beta =
#> 2.69, 95% CI [0.31, 5.07], t(55) = 2.27, p = 0.027; Std. beta = 0.85, 95% CI
#> [0.10, 1.61])
#>   - The effect of breed1 [5] is statistically non-significant and negative (beta
#> = -0.33, 95% CI [-2.83, 2.17], t(55) = -0.26, p = 0.793; Std. beta = -0.10, 95%
#> CI [-0.90, 0.69])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
 if (requireNamespace("emmeans", quietly = TRUE)) {
   emm3.4 <- emmeans::emmeans(fm3.4, ~ breed1, lmer.df = "asymptotic")
   print(emm3.4)
   print(emmeans::contrast(emm3.4, method = "pairwise", adjust = "tukey"))
 }
#>  breed1 emmean    SE  df asymp.LCL asymp.UCL
#>  1       13.12 0.606 Inf     11.94      14.3
#>  2       12.40 0.720 Inf     10.98      13.8
#>  3       10.60 0.877 Inf      8.88      12.3
#>  4       12.74 0.657 Inf     11.45      14.0
#>  5        9.72 0.863 Inf      8.03      11.4
#>  6       10.05 0.969 Inf      8.15      11.9
#> 
#> Results are averaged over the levels of: sex 
#> Degrees-of-freedom method: asymptotic 
#> Confidence level used: 0.95 
#>  contrast          estimate    SE  df z.ratio p.value
#>  breed11 - breed12    0.728 0.944 Inf   0.771  0.9723
#>  breed11 - breed13    2.525 1.070 Inf   2.367  0.1678
#>  breed11 - breed14    0.384 0.899 Inf   0.427  0.9982
#>  breed11 - breed15    3.402 1.060 Inf   3.223  0.0160
#>  breed11 - breed16    3.073 1.140 Inf   2.704  0.0744
#>  breed12 - breed13    1.797 1.080 Inf   1.663  0.5568
#>  breed12 - breed14   -0.344 0.959 Inf  -0.359  0.9992
#>  breed12 - breed15    2.674 1.190 Inf   2.255  0.2130
#>  breed12 - breed16    2.345 1.230 Inf   1.911  0.3951
#>  breed13 - breed14   -2.141 1.060 Inf  -2.011  0.3360
#>  breed13 - breed15    0.877 1.380 Inf   0.633  0.9886
#>  breed13 - breed16    0.548 1.350 Inf   0.406  0.9986
#>  breed14 - breed15    3.018 1.120 Inf   2.697  0.0757
#>  breed14 - breed16    2.689 1.190 Inf   2.266  0.2083
#>  breed15 - breed16   -0.329 1.250 Inf  -0.263  0.9998
#> 
#> Results are averaged over the levels of: sex 
#> Degrees-of-freedom method: asymptotic 
#> P value adjustment: tukey method for comparing a family of 6 estimates 
 summary(fm3.4)
#> Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#> lmerModLmerTest]
#> Formula: Ww ~ sex + agew + breed1 + (1 | sire_id1:breed1)
#>    Data: ex32
#> 
#> REML criterion at convergence: 284.3
#> 
#> Scaled residuals: 
#>     Min      1Q  Median      3Q     Max 
#> -2.5654 -0.6608  0.2366  0.6499  2.2953 
#> 
#> Random effects:
#>  Groups          Name        Variance Std.Dev.
#>  sire_id1:breed1 (Intercept) 0.000    0.000   
#>  Residual                    5.447    2.334   
#> Number of obs: 65, groups:  sire_id1:breed1, 15
#> 
#> Fixed effects:
#>             Estimate Std. Error       df t value Pr(>|t|)    
#> (Intercept) -0.36196    3.12869 57.00000  -0.116 0.908304    
#> sexF        -1.43763    0.61338 57.00000  -2.344 0.022600 *  
#> agew         0.08386    0.02393 57.00000   3.505 0.000898 ***
#> breed11      3.07302    1.13643 57.00000   2.704 0.009013 ** 
#> breed12      2.34510    1.22697 57.00000   1.911 0.060999 .  
#> breed13      0.54799    1.34825 57.00000   0.406 0.685939    
#> breed14      2.68929    1.18700 57.00000   2.266 0.027291 *  
#> breed15     -0.32865    1.24771 57.00000  -0.263 0.793188    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Correlation of Fixed Effects:
#>         (Intr) sexF   agew   bred11 bred12 bred13 bred14
#> sexF     0.121                                          
#> agew    -0.944 -0.257                                   
#> breed11 -0.146  0.065 -0.121                            
#> breed12 -0.023  0.161 -0.240  0.684                     
#> breed13  0.162  0.152 -0.406  0.643  0.651              
#> breed14 -0.077  0.187 -0.196  0.702  0.685  0.654       
#> breed15 -0.514  0.067  0.279  0.612  0.541  0.433  0.579
#> optimizer (nloptwrap) convergence code: 0 (OK)
#> boundary (singular) fit: see help('isSingular')
#> 
 anova(object = fm3.4, ddf = "Satterthwaite")
#> Type III Analysis of Variance Table with Satterthwaite's method
#>         Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)    
#> sex     29.924  29.924     1    57  5.4932 0.0226004 *  
#> agew    66.904  66.904     1    57 12.2819 0.0008979 ***
#> breed1 109.411  21.882     5    57  4.0170 0.0034289 ** 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
 lsmeansLT(model = fm3.4)
#> Least Squares Means table:
#> 
#>         Estimate Std. Error df t value    lower    upper  Pr(>|t|)    
#> sexF    10.71994    0.42885 57  24.997  9.86118 11.57869 < 2.2e-16 ***
#> sexM    12.15756    0.43216 57  28.132 11.29218 13.02295 < 2.2e-16 ***
#> breed11 13.12398    0.60557 57  21.672 11.91136 14.33661 < 2.2e-16 ***
#> breed12 12.39605    0.72013 57  17.214 10.95402 13.83809 < 2.2e-16 ***
#> breed13 10.59894    0.87738 57  12.080  8.84202 12.35587 < 2.2e-16 ***
#> breed14 12.74025    0.65697 57  19.392 11.42469 14.05581 < 2.2e-16 ***
#> breed15  9.72230    0.86252 57  11.272  7.99513 11.44948 3.896e-16 ***
#> breed16 10.05096    0.96866 57  10.376  8.11126 11.99066 9.546e-15 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#>   Confidence level: 95%
#>   Degrees of freedom method: Satterthwaite 
```
