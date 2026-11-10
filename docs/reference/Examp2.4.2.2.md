# Example 2.4.2.2: ML and REML estimates of variance components

The split-plot data
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md):
REML gives 5.151 (region), 0.387 (herd within region) and 2.096
(residual); ML gives the smaller 4.292, 0.322 and 1.747 (Table 2.4.2.1),
because it ignores the degrees of freedom used by the fixed effects. The
Type 3 (moment) estimates equal REML here, as the data are balanced.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
[`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md),
[`Examp2.5.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.3.1.md),
[`Examp2.5.4.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.4.1.md),
[`Examp2.6.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.6.1.md),
[`Examp3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp3.1.md),
[`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md),
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc mixed data=ex125 method=ml;   * and method=reml;
#     class drug dose region;
#     model pcv = drug dose drug*dose;
#     random region drug*region;
#   run;

ml <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "ML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
reml <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
mom <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "Type3"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
cbind(ML = ml$covariance$estimate, REML = reml$covariance$estimate, Type3 = mom$covariance$estimate)
#>            ML     REML    Type3
#> [1,] 4.292361 5.150833 5.150833
#> [2,] 0.322500 0.387000 0.387000
#> [3,] 1.747014 2.096417 2.096417

# the same model with lme4 (optional)
if (requireNamespace("lme4", quietly = TRUE)) {
  lm4 <-
    lme4::lmer(
        formula = Pcv ~ Drug * dose + (1 | Region / Drug)
      , data    = ex125
      , REML    = TRUE
      )
  print(lme4::VarCorr(lm4), comp = "Variance")
}
#>  Groups      Name        Variance
#>  Drug:Region (Intercept) 0.3870  
#>  Region      (Intercept) 5.1508  
#>  Residual                2.0964  
```
