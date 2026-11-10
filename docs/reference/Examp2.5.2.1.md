# Example 2.5.2.1: cell means as estimable functions

The four drug-by-dose means of
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)
(25.45, 24.28, 21.48 and 17.13) and their variance 1.27, as
least-squares means.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
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
#   proc mixed data=ex125;
#     class drug dose region;
#     model pcv = drug dose drug*dose;
#     random region drug*region;
#     lsmeans drug*dose;
#   run;

fm <-
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
vlm_lsmeans(
    fit    = fm
  , specs  = ~ Drug:dose
  , at     = NULL
  , diff   = FALSE
  , adjust = "none"
  , level  = 0.95
  )
#> Least-squares means (denominator df: contain; 95% limits)
#> 
#> Least squares means
#>     Drug dose estimate    se df     t      p lower upper
#>  BERENIL    h    25.45 1.128 10 22.56 <1e-04 22.94 27.96
#>  BERENIL    l    24.28 1.128 10 21.53 <1e-04 21.77 26.80
#>  samorin    h    21.48 1.128 10 19.05 <1e-04 18.97 24.00
#>  samorin    l    17.13 1.128 10 15.19 <1e-04 14.62 19.65
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980). Full references: vlm_cite(x).
```
