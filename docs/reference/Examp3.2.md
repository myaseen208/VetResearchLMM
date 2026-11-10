# Example 3.2: sires nested in breed, heritability and breed comparisons

Weaning weights of lambs
([`ex32`](https://myaseen208.com/VetResearchLMM/reference/ex32.md)) with
sex, age and breed fixed and sires within breed random: the heritability
\\h^2 = 4\sigma_s^2/(\sigma_s^2 + \sigma^2)\\, Tukey-Kramer comparisons
of the breeds and the predicted breeding values of the sires. The book
prints only part of the data, so the numbers differ from those of the
book (for this part the sire variance is estimated as zero).

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_blup`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`ex32`](https://myaseen208.com/VetResearchLMM/reference/ex32.md)

Other VetResearchLMM examples:
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md),
[`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md),
[`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md),
[`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md),
[`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md),
[`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md),
[`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md),
[`Examp2.5.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.3.1.md),
[`Examp2.5.4.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.4.1.md),
[`Examp2.6.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.6.1.md),
[`Examp3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp3.1.md),
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc mixed data=ex32;
#     class sex sire_id breed;
#     model ww = sex agew breed / solution ddfm=satterth;
#     random sire_id(breed) / solution;
#     lsmeans breed / adjust=tukey;
#   run;

fm <-
  vlm_fit(
      fixed    = Ww ~ sex + agew + breed
    , data     = ex32
    , random   = ~ breed:sire_id
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = "breed"
    , bound    = TRUE
    , control  = list()
    )
v <- fm$covariance$estimate
h2 <- 4 * v[1] / sum(v)
h2
#> [1] 0
vlm_lsmeans(
    fit    = fm
  , specs  = ~ breed
  , at     = NULL
  , diff   = TRUE
  , adjust = "tukey"
  , level  = 0.95
  )
#> Least-squares means (denominator df: satterth; 95% limits)
#> 
#> Least squares means
#>  breed estimate     se    df     t      p lower upper
#>      1    13.12 0.6056 57.00 21.67 <1e-04 11.91 14.34
#>      2    12.40 0.7201 57.00 17.21 <1e-04 10.95 13.84
#>      3    10.60 0.8774 57.00 12.08 <1e-04 8.842 12.36
#>      4    12.74 0.6570 57.00 19.39 <1e-04 11.42 14.06
#>      5    9.722 0.8625 57.00 11.27 <1e-04 7.995 11.45
#>      6    10.05 0.9687 57.00 10.38 <1e-04 8.111 11.99
#> 
#> Differences of least squares means (adjustment: tukey)
#>  level_1 level_2 estimate     se    df       t       p p_adjusted   lower
#>        1       2   0.7279 0.9436 57.00  0.7714 0.44364     0.9712  -2.055
#>        1       3    2.525  1.067 57.00   2.367 0.02134     0.1853 -0.6203
#>        1       4   0.3837 0.8986 57.00  0.4270 0.67098     0.9981  -2.266
#>        1       5    3.402  1.055 57.00   3.223 0.00210     0.0244  0.2893
#>        1       6    3.073  1.136 57.00   2.704 0.00901     0.0901 -0.2781
#>        2       3    1.797  1.081 57.00   1.663 0.10190     0.5616  -1.390
#>        2       4  -0.3442 0.9590 57.00 -0.3589 0.72100     0.9992  -3.172
#>        2       5    2.674  1.186 57.00   2.255 0.02801     0.2298 -0.8232
#>        2       6    2.345  1.227 57.00   1.911 0.06100     0.4060  -1.273
#>        3       4   -2.141  1.065 57.00  -2.011 0.04909     0.3492  -5.282
#>        3       5   0.8766  1.385 57.00  0.6332 0.52916     0.9880  -3.206
#>        3       6   0.5480  1.348 57.00  0.4064 0.68594     0.9985  -3.428
#>        4       5    3.018  1.119 57.00   2.697 0.00918     0.0916 -0.2816
#>        4       6    2.689  1.187 57.00   2.266 0.02729     0.2252 -0.8110
#>        5       6  -0.3287  1.248 57.00 -0.2634 0.79319     0.9998  -4.008
#>   upper
#>   3.510
#>   5.670
#>   3.034
#>   6.514
#>   6.424
#>   4.985
#>   2.484
#>   6.171
#>   5.963
#>  0.9989
#>   4.959
#>   4.524
#>   6.317
#>   6.190
#>   3.351
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
#> (1980); Kramer (1956); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai
#> and Cornelius (1996). Full references: vlm_cite(x).
vlm_blup(
    fit   = fm
  , level = 0.95
  )
#> Best linear unbiased predictions of the random effects
#> 
#> Solution for random effects
#>         effect  level estimate se df t p lower upper
#>  breed:sire_id 1 1971        0  0 48 . .     0     0
#>  breed:sire_id 1 1972        0  0 48 . .     0     0
#>  breed:sire_id 2 1876        0  0 48 . .     0     0
#>  breed:sire_id 2 1975        0  0 48 . .     0     0
#>  breed:sire_id 2 1976        0  0 48 . .     0     0
#>  breed:sire_id 3 1971        0  0 48 . .     0     0
#>  breed:sire_id 4 1973        0  0 48 . .     0     0
#>  breed:sire_id 4 1975        0  0 48 . .     0     0
#>  breed:sire_id 4 1976        0  0 48 . .     0     0
#>  breed:sire_id 5 1975        0  0 48 . .     0     0
#>  breed:sire_id 5 1979        0  0 48 . .     0     0
#>  breed:sire_id 6 1972        0  0 48 . .     0     0
#>  breed:sire_id 6 1991        0  0 48 . .     0     0
#>  breed:sire_id 6 4908        0  0 48 . .     0     0
#>  breed:sire_id 6 4910        0  0 48 . .     0     0
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Henderson (1975). Full
#> references: vlm_cite(x).
```
