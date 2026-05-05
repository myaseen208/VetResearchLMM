# Examp1.3.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).*Linear Mixed Models. An Introduction with applications in Veterinary Research*. International Livestock Research Institute.

Examp1.3.2 is used for inspecting probability distribution and to define
a plausible process through linear models and generalized linear models.

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
## Example 1.3.2 p-16
#-------------------------------------------------------------
 # PROC GLM DATA=ex124;
 # CLASS herd dose drug;
 # MODEL PCVdif=drug herd(drug) dose dose*drug;
 # RANDOM herd(drug);
 # RUN;

library(lme4)
#> Loading required package: Matrix
str(ex124)
#> 'data.frame':    40 obs. of  4 variables:
#>  $ herd  : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ drug  : Factor w/ 2 levels "Berenil","Samorin": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ dose  : Factor w/ 2 levels "h","l": 2 2 2 2 2 1 1 1 1 1 ...
#>  $ PCVdif: num  2.5 1.6 3.5 2.6 2.8 6.9 6.8 7.2 5.9 6.5 ...
summary(ex124)
#>       herd           drug    dose       PCVdif     
#>  Min.   :1.00   Berenil:20   h:20   Min.   :1.600  
#>  1st Qu.:1.75   Samorin:20   l:20   1st Qu.:3.225  
#>  Median :2.50                       Median :5.250  
#>  Mean   :2.50                       Mean   :5.263  
#>  3rd Qu.:3.25                       3rd Qu.:7.225  
#>  Max.   :4.00                       Max.   :8.700  

ex124 <-
  ex124 |>
  collapse::fmutate(
    herd1 = factor(herd),
    drug1 = factor(drug),
    dose1 = factor(dose)
  )

fm1.1 <-
  aov(
      formula     = PCVdif ~ drug1 + Error(herd1:drug1) + dose1 + dose1:drug1
    , data        = ex124
    , projections = FALSE
    , qr          = TRUE
    , contrasts   = NULL
  #  , ...
    )
#> Warning: Error() model is singular
if (requireNamespace("report", quietly = TRUE)) {
  fm1.1 |>
    report::report()
}
#> The repeated-measures ANOVA (formula: PCVdif ~ drug1 + Error(herd1:drug1) +
#> dose1 + dose1:drug1) suggests that:
#> 
#>   - The main effect of dose1 is statistically significant and medium (F(1, 34) =
#> 732.39, p < .001; Eta2 (partial) = 0.13, 95% CI [0.00, 1.00])
#>   - The interaction between drug1 and dose1 is statistically not significant and
#> large (F(1, 34) = 0.66, p = 0.421; Eta2 (partial) = 0.96, 95% CI [0.93, 1.00])
#>   - The main effect of drug1 is statistically NA and small (F(, 34) = , ; Eta2
#> (partial) = 0.02, 95% CI [0.00, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
summary(fm1.1)
#> 
#> Error: herd1:drug1
#>           Df Sum Sq Mean Sq F value Pr(>F)
#> drug1      1  1.722   1.722   0.305  0.636
#> Residuals  2 11.300   5.650               
#> 
#> Error: Within
#>             Df Sum Sq Mean Sq F value Pr(>F)    
#> dose1        1 172.64  172.64 732.394 <2e-16 ***
#> drug1:dose1  1   0.16    0.16   0.663  0.421    
#> Residuals   34   8.01    0.24                   
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
