# Example 2.4.3.1: best linear unbiased prediction of sire effects

The random sire model of
[`ex127`](https://myaseen208.com/VetResearchLMM/reference/ex127.md):
REML variances 3.685 (sire) and 3.542 (residual), overall mean 13.97,
and the prediction 3.16 for sire 4, a shrunken version of its mean
deviation 17.63 - 13.97.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_blup`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`ex127`](https://myaseen208.com/VetResearchLMM/reference/ex127.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
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
#   proc mixed data=ex127;
#     class sire;
#     model ww = ;
#     random sire / solution;
#   run;

fs <-
  vlm_fit(
      fixed    = Ww ~ 1
    , data     = ex127
    , random   = ~ sire
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
fs$fixed
#>         effect  level estimate       se    df        t            p
#>         <char> <char>    <num>    <num> <num>    <num>        <num>
#> 1: (Intercept)        13.96863 0.743532     7 18.78685 3.007855e-07
vlm_blup(
    fit   = fs
  , level = 0.95
  )
#> Best linear unbiased predictions of the random effects
#> 
#> Solution for random effects
#>  effect level estimate     se df        t       p   lower   upper
#>    sire     1   -2.198  1.101 35   -1.997 0.05364  -4.432 0.03641
#>    sire     2 -0.03189 0.8983 35 -0.03550 0.97188  -1.855   1.792
#>    sire     3   -1.743  1.101 35   -1.584 0.12216  -3.978  0.4908
#>    sire     4    3.159 0.9589 35    3.294 0.00227   1.212   5.106
#>    sire     5   0.8692 0.9340 35   0.9306 0.35842  -1.027   2.765
#>    sire     6  -0.8628 0.9915 35  -0.8702 0.39013  -2.876   1.150
#>    sire     7    1.356  1.036 35    1.309 0.19922 -0.7475   3.459
#>    sire     8  -0.5476 0.9589 35  -0.5710 0.57162  -2.494   1.399
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Henderson (1975). Full
#> references: vlm_cite(x).

# the same model with lme4 (optional)
if (requireNamespace("lme4", quietly = TRUE)) {
  lm4 <-
    lme4::lmer(
        formula = Ww ~ 1 + (1 | sire)
      , data    = ex127
      , REML    = TRUE
      )
  print(lme4::VarCorr(lm4), comp = "Variance")
}
#>  Groups   Name        Variance
#>  sire     (Intercept) 3.6855  
#>  Residual             3.5418  
```
