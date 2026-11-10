# Published values used by the tests and vignettes

Reads `inst/extdata/reference.csv`: one row per published number, with
its source, the R call that recomputes it with this package (`call`),
the expression that extracts the number from the result (`extract`, in
terms of `x`), the printed value and the digits to compare. The same
file drives the test of published values and the vignette that
reproduces the published examples. Each distinct `call` is evaluated
once.

## Usage

``` r
vlm_reference(source = NULL, evaluate = FALSE, level = 1)
```

## Arguments

- source:

  optional regular expression; keep rows whose `source` matches.

- evaluate:

  logical; evaluate the rows and add columns `computed` and `agrees`
  (default `FALSE`).

- level:

  largest `level` evaluated (1 = fast rows, 2 = slow rows; default 1);
  rows above it get `NA`.

## Value

A `data.table` with columns `id`, `source`, `quantity`, `call`,
`extract`, `value`, `digits`, `level`, `note` (and `computed`,
`agrees`).

## See also

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md),
[`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
ref <-
  vlm_reference(
      source   = NULL
    , evaluate = FALSE
    , level    = 1
    )
ref
#>                     id
#>                 <char>
#>   1:         e132_drug
#>   2:         e132_herd
#>   3:        e132d_drug
#>   4:        e132d_herd
#>   5:     e2217_ss_dose
#>  ---                  
#> 112:   e33_rc_blup_int
#> 113: e33_rc_blup_slope
#> 114:   e33_rc_blup_se1
#> 115:   e33_rc_blup_se2
#> 116:    e33_rc_blup_df
#>                                                            source
#>                                                            <char>
#>   1:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.2
#>   2:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.2
#>   3:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.3
#>   4:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.3
#>   5:        Duchateau, Janssen and Rowlands (1998), Table 2.2.1.3
#>  ---                                                             
#> 112: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 113: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 114: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 115: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 116: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#>                                                      quantity
#>                                                        <char>
#>   1:           coefficient of the herd variance in E(MS drug)
#>   2:     coefficient of the herd variance in E(MS herd(drug))
#>   3:       coefficient in E(MS drug), one observation deleted
#>   4: coefficient in E(MS herd(drug)), one observation deleted
#>   5:                               sum of squares among doses
#>  ---                                                         
#> 112:                                random intercept of BO241
#> 113:                                    random slope of BO241
#> 114:                     standard error of a random intercept
#> 115:                         standard error of a random slope
#> 116:                                    df of the predictions
#>                                                                                                                                                             call
#>                                                                                                                                                           <char>
#>   1:                                           vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd, class = 'herd')
#>   2:                                           vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd, class = 'herd')
#>   3:                                     vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124[-1, ], random = ~ drug:herd, class = 'herd')
#>   4:                                     vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124[-1, ], random = ~ drug:herd, class = 'herd')
#>   5:                                                                                                vlm_ems(fixed = PCVdiff ~ dose, data = ex121, random = NULL)
#>  ---                                                                                                                                                            
#> 112: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 113: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 114: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 115: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 116: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#>                   extract    value digits level   note
#>                    <char>    <num>  <int> <int> <char>
#>   1: x$coefficients[1, 1]  10.0000      4     1       
#>   2: x$coefficients[2, 1]  10.0000      4     1       
#>   3: x$coefficients[1, 1]   9.7143      4     1       
#>   4: x$coefficients[2, 1]   9.7222      4     1       
#>   5:        x$anova$ss[1]  80.7300      2     1       
#>  ---                                                  
#> 112:   x$blup$estimate[3]  -1.8360      3     1       
#> 113:  x$blup$estimate[15]   0.0563      4     1       
#> 114:         x$blup$se[3]   1.6400      2     1       
#> 115:        x$blup$se[15]   0.0417      4     1       
#> 116:         x$blup$df[3] 144.0000      0     1       
# \donttest{
vlm_reference(
    source   = "."
  , evaluate = TRUE
  , level    = 1
  )
#>                     id
#>                 <char>
#>   1:         e132_drug
#>   2:         e132_herd
#>   3:        e132d_drug
#>   4:        e132d_herd
#>   5:     e2217_ss_dose
#>  ---                  
#> 112:   e33_rc_blup_int
#> 113: e33_rc_blup_slope
#> 114:   e33_rc_blup_se1
#> 115:   e33_rc_blup_se2
#> 116:    e33_rc_blup_df
#>                                                            source
#>                                                            <char>
#>   1:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.2
#>   2:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.2
#>   3:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.3
#>   4:        Duchateau, Janssen and Rowlands (1998), Table 1.3.2.3
#>   5:        Duchateau, Janssen and Rowlands (1998), Table 2.2.1.3
#>  ---                                                             
#> 112: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 113: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 114: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 115: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#> 116: Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3
#>                                                      quantity
#>                                                        <char>
#>   1:           coefficient of the herd variance in E(MS drug)
#>   2:     coefficient of the herd variance in E(MS herd(drug))
#>   3:       coefficient in E(MS drug), one observation deleted
#>   4: coefficient in E(MS herd(drug)), one observation deleted
#>   5:                               sum of squares among doses
#>  ---                                                         
#> 112:                                random intercept of BO241
#> 113:                                    random slope of BO241
#> 114:                     standard error of a random intercept
#> 115:                         standard error of a random slope
#> 116:                                    df of the predictions
#>                                                                                                                                                             call
#>                                                                                                                                                           <char>
#>   1:                                           vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd, class = 'herd')
#>   2:                                           vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd, class = 'herd')
#>   3:                                     vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124[-1, ], random = ~ drug:herd, class = 'herd')
#>   4:                                     vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124[-1, ], random = ~ drug:herd, class = 'herd')
#>   5:                                                                                                vlm_ems(fixed = PCVdiff ~ dose, data = ex121, random = NULL)
#>  ---                                                                                                                                                            
#> 112: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 113: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 114: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 115: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#> 116: vlm_blup(fit = vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = 'un')))
#>                   extract    value digits level   note     computed agrees
#>                    <char>    <num>  <int> <int> <char>        <num> <lgcl>
#>   1: x$coefficients[1, 1]  10.0000      4     1         10.00000000   TRUE
#>   2: x$coefficients[2, 1]  10.0000      4     1         10.00000000   TRUE
#>   3: x$coefficients[1, 1]   9.7143      4     1          9.71428571   TRUE
#>   4: x$coefficients[2, 1]   9.7222      4     1          9.72222222   TRUE
#>   5:        x$anova$ss[1]  80.7300      2     1         80.72678571   TRUE
#>  ---                                                                      
#> 112:   x$blup$estimate[3]  -1.8360      3     1         -1.83580470   TRUE
#> 113:  x$blup$estimate[15]   0.0563      4     1          0.05626114   TRUE
#> 114:         x$blup$se[3]   1.6400      2     1          1.63760579   TRUE
#> 115:        x$blup$se[15]   0.0417      4     1          0.04174646   TRUE
#> 116:         x$blup$df[3] 144.0000      0     1        144.00000000   TRUE
# }
```
