# References of a result or of the package

`vlm_cite()` gives the references of the methods behind a result of the
package, or every reference of the package, as text or BibTeX.
`citation("VetResearchLMM")` cites the package and the book.

## Usage

``` r
vlm_cite(x = NULL, style = c("text", "bibtex"))

# Default S3 method
vlm_cite(x = NULL, style = c("text", "bibtex"))
```

## Arguments

- x:

  a result of a function of the package, or `NULL` (default) for every
  reference.

- style:

  `"text"` (default) or `"bibtex"`.

## Value

An object of class `bibentry` (printed in the chosen style).

## See also

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md),
[`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md),
[`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
vlm_cite(
    x     = NULL
  , style = "text"
  )
#> Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). Linear Mixed Models. An Introduction with Applications in Veterinary Research. International Livestock Research Institute, Nairobi. ISBN 92-9146-038-9.
#> 
#> Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block information when block sizes are unequal. Biometrika, 58(3), 545-554. doi:10.1093/biomet/58.3.545
#> 
#> Harville, D. A. (1977). Maximum likelihood approaches to variance component estimation and to related problems. Journal of the American Statistical Association, 72(358), 320-338. doi:10.1080/01621459.1977.10480998
#> 
#> Gilmour, A. R., Thompson, R. and Cullis, B. R. (1995). Average information REML: an efficient algorithm for variance parameter estimation in linear mixed models. Biometrics, 51(4), 1440-1450. doi:10.2307/2533274
#> 
#> Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D. (1996). SAS System for Mixed Models. SAS Institute, Cary, NC.
#> 
#> Satterthwaite, F. E. (1946). An approximate distribution of estimates of variance components. Biometrics Bulletin, 2(6), 110-114. doi:10.2307/3002019
#> 
#> Giesbrecht, F. G. and Burns, J. C. (1985). Two-stage analysis based on a mixed model: large-sample asymptotic theory and small-sample simulation results. Biometrics, 41(2), 477-486. doi:10.2307/2530872
#> 
#> Fai, A. H.-T. and Cornelius, P. L. (1996). Approximate F-tests of multiple degree of freedom hypotheses in generalized least squares analyses of unbalanced split-plot experiments. Journal of Statistical Computation and Simulation, 54(4), 363-378. doi:10.1080/00949659608811740
#> 
#> Kenward, M. G. and Roger, J. H. (1997). Small sample inference for fixed effects from restricted maximum likelihood. Biometrics, 53(3), 983-997. doi:10.2307/2533558
#> 
#> Henderson, C. R. (1975). Best linear unbiased estimation and prediction under a selection model. Biometrics, 31(2), 423-447. doi:10.2307/2529430
#> 
#> McLean, R. A., Sanders, W. L. and Stroup, W. W. (1991). A unified approach to mixed linear models. The American Statistician, 45(1), 54-64. doi:10.1080/00031305.1991.10475767
#> 
#> Searle, S. R., Speed, F. M. and Milliken, G. A. (1980). Population marginal means in the linear model: an alternative to least squares means. The American Statistician, 34(4), 216-221. doi:10.1080/00031305.1980.10483031
#> 
#> Kramer, C. Y. (1956). Extension of multiple range tests to group means with unequal numbers of replications. Biometrics, 12(3), 307-310. doi:10.2307/3001469
#> 
#> Searle, S. R., Casella, G. and McCulloch, C. E. (1992). Variance Components. Wiley, New York.
#> 
#> Akaike, H. (1974). A new look at the statistical model identification. IEEE Transactions on Automatic Control, 19(6), 716-723. doi:10.1109/TAC.1974.1100705
#> 
#> Schwarz, G. (1978). Estimating the dimension of a model. The Annals of Statistics, 6(2), 461-464. doi:10.1214/aos/1176344136 
```
