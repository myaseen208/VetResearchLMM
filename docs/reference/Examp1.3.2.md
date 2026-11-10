# Example 1.3.2: expected mean squares in the fixed and the mixed model

Drugs are given to whole herds and doses to animals within herds
([`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md)).
With herd random, drug is tested against herd within drug (Table
1.3.2.2); with one observation deleted the two expected mean squares no
longer match (Table 1.3.2.3: 9.7143 and 9.7222), so the F test is only
approximate.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

[`vlm_ems`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md)

Other VetResearchLMM examples:
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
[`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md),
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# SAS program of the book (Appendix B):
#   proc glm data=ex124;
#     class herd dose drug;
#     model PCVdif = drug herd(drug) dose dose*drug;
#     random herd(drug) / test;
#   run;

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

# one observation deleted (Table 1.3.2.3)
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

# the mixed model analysis that replaces it
fm <-
  vlm_fit(
      fixed    = PCVdif ~ drug + dose + drug:dose
    , data     = ex124
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = "herd"
    , bound    = TRUE
    , control  = list()
    )
fm$tests
#>       effect num_df den_df           F            p
#>       <char>  <int>  <num>       <num>        <num>
#> 1:      drug      1      2   0.3048095 6.363390e-01
#> 2:      dose      1     34 732.3935991 1.385997e-24
#> 3: drug:dose      1     34   0.6628611 4.212176e-01
```
