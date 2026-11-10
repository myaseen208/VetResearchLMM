# Analysis of variance with expected mean squares

The analysis of variance of a linear model fitted by ordinary least
squares, with the expected mean squares of each source when some effects
are random, F tests built from the appropriate (synthesised) error terms
with Satterthwaite degrees of freedom, and the method-of-moments (Type
3) estimates of the variance components. This is SAS PROC GLM with a
RANDOM statement and the TEST option (Examples 1.3.2 and 2.5.3.1 of the
book).

## Usage

``` r
vlm_ems(fixed, data, random = NULL, type = 3, class = NULL)

# Default S3 method
vlm_ems(fixed, data, random = NULL, type = 3, class = NULL)
```

## Arguments

- fixed:

  two-sided formula with every effect of the model, random effects
  included, in SAS MODEL order (for example
  `PCVdif ~ drug + drug:herd + dose + dose:drug`).

- data:

  a data frame with the variables.

- random:

  one-sided formula of the effects of `fixed` that are random (for
  example `~ drug:herd`); `NULL` for a fixed-effects analysis.

- type:

  type of sums of squares: 3 (default) or 1.

- class:

  optional character vector of numeric variables to treat as
  classification variables.

## Value

A list of class `c("vlm_ems", "vlm_result", "list")` with `anova`
(source, df, sum of squares, mean square, expected mean square, F, error
degrees of freedom and p-value), `coefficients` (the coefficients of the
variance components in each expected mean square), `error_terms` (the
combination of mean squares used as the error of each test) and
`components` (Type 3 estimates of the variance components).

## Details

The sum of squares of a source is a quadratic form \\SS =
\mathbf{y}^{\top}\mathbf{A}\mathbf{y}\\: for Type 3, \\\mathbf{A} =
\mathbf{X}\mathbf{C}\mathbf{L}^{\top}(\mathbf{L}\mathbf{C}\mathbf{L}^{\top})^{-1}\mathbf{L}
\mathbf{C}\mathbf{X}^{\top}\\ with \\\mathbf{C} =
(\mathbf{X}^{\top}\mathbf{X})^{-1}\\ in the sum-to-zero coding and
\\\mathbf{L}\\ selecting the columns of the source; for Type 1, the
projection on the columns added by the source. With random effects
\\\mathbf{u}\_k \sim N(\mathbf{0}, \sigma_k^2\mathbf{I})\\ of design
\\\mathbf{Z}\_k\\, \$\$E(MS) = \sigma^2 + \sum_k
\frac{\mathrm{tr}(\mathbf{Z}\_k^{\top}\mathbf{A}\mathbf{Z}\_k)}{DF}\\\sigma_k^2 +
Q(\mathrm{fixed}).\$\$ The error term of a source is the combination
\\\sum_r a_r MS_r\\ of mean squares of other random sources and the
residual whose expectation equals that of the source under the null
hypothesis; its degrees of freedom are \\(\sum_r a_r MS_r)^2 / \sum_r
(a_r MS_r)^2 / DF_r\\ (Satterthwaite 1946). Equating the mean squares of
the random sources and the error to their expectations gives the Type 3
estimates of the variance components.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Section 1.3.2 and
Appendix G.

Satterthwaite, F. E. (1946). An approximate distribution of estimates of
variance components. *Biometrics Bulletin*, 2, 110-114.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

Other VetResearchLMM models:
[`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md),
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# Example 1.3.2: PROC GLM; CLASS herd dose drug; MODEL PCVdif = drug herd(drug) dose dose*drug;
# RANDOM herd(drug) / TEST;
em <-
  vlm_ems(
      fixed  = PCVdif ~ drug + drug:herd + dose + dose:drug
    , data   = ex124
    , random = ~ drug:herd
    , type   = 3
    , class  = "herd"
    )
em
#> Type 3 analysis of variance of PCVdif
#> 
#> Analysis of variance
#>     source df     ss     ms                                         ems      F
#>       drug  1  1.722  1.722 Var(Residual) + 10 Var(drug:herd) + Q(drug) 0.3048
#>  drug:herd  2  11.30  5.650           Var(Residual) + 10 Var(drug:herd)  23.97
#>       dose  1  172.6  172.6                     Var(Residual) + Q(dose)  732.4
#>  drug:dose  1 0.1562 0.1562                Var(Residual) + Q(drug:dose) 0.6629
#>   Residual 34  8.014 0.2357                               Var(Residual)       
#>  den_df      p
#>       2  0.636
#>      34 <1e-04
#>      34 <1e-04
#>      34  0.421
#>       .      .
#> 
#> Error terms of the tests
#>     source           error
#>       drug 1 MS(drug:herd)
#>  drug:herd  1 MS(Residual)
#>       dose  1 MS(Residual)
#>  drug:dose  1 MS(Residual)
#> 
#> Type 3 estimates of the variance components
#>  component estimate
#>  drug:herd   0.5415
#>   Residual   0.2357
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Searle, Casella and McCulloch
#> (1992); Satterthwaite (1946). Full references: vlm_cite(x).

# one observation deleted: the expected mean squares of drug and herd(drug) no longer match
# (Table 1.3.2.3)
em1 <-
  vlm_ems(
      fixed  = PCVdif ~ drug + drug:herd + dose + dose:drug
    , data   = ex124[-1, ]
    , random = ~ drug:herd
    , type   = 3
    , class  = "herd"
    )
em1$coefficients
#>           drug:herd Residual
#> drug       9.714286        1
#> drug:herd  9.722222        1
#> dose       0.000000        1
#> drug:dose  0.000000        1
#> Residual   0.000000        1
```
