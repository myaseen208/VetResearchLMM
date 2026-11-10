# Notation of VetResearchLMM

The symbols used in the help pages and vignettes of VetResearchLMM, with
their meaning and the argument or result component that holds them. The
notation follows one rule throughout: scalars are upper-case letters in
normal face (\\P\\, \\R\\), indices lower-case italic (\\i, j\\),
vectors lower-case bold (\\\mathbf{y}\\, \\\boldsymbol{\beta}\\) and
matrices upper-case bold (\\\mathbf{X}\\, \\\boldsymbol{\Sigma}\\).

## Usage

``` r
vlm_notation(format = c("table", "path", "tex"))
```

## Arguments

- format:

  `"table"` (default: a `data.table` with columns `symbol` (LaTeX),
  `text` (plain text), `kind` (scalar, index, vector, matrix, set,
  function, operator), `meaning` and `argument`), `"path"` (the path of
  `notation.csv`) or `"tex"` (the path of `Notations.tex`, the notation
  appendix used in the articles).

## Value

See `format`.

## See also

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md),
[`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
vlm_notation(
    format = "table"
  )
#>                       symbol     text     kind
#>                       <char>   <char>   <char>
#>  1:                        N        N   scalar
#>  2:                        P        P   scalar
#>  3:              \\mathbf{y}        y   vector
#>  4:              \\mathbf{X}        X   matrix
#>  5:     \\boldsymbol{\\beta}     beta   vector
#>  6:              \\mathbf{Z}        Z   matrix
#>  7:              \\mathbf{u}        u   vector
#>  8:              \\mathbf{e}        e   vector
#>  9:              \\mathbf{G}        G   matrix
#> 10:              \\mathbf{R}        R   matrix
#> 11:              \\mathbf{V}        V   matrix
#> 12:    \\boldsymbol{\\theta}    theta   vector
#> 13:            \\mathbf{V}_i      V_i   matrix
#> 14:              \\mathbf{P}        P   matrix
#> 15:              \\mathbf{C}        C   matrix
#> 16:           \\ell_R, \\ell        l function
#> 17: \\mathbf{l}, \\mathbf{L}        L   vector
#> 18:              \\mathbf{k}        k   vector
#> 19:                     \\nu       nu   scalar
#> 20:              \\mathbf{A}        A   matrix
#> 21:        \\mathbf{\\Phi}_A    Phi_A   matrix
#> 22:                \\sigma^2   sigma2   scalar
#> 23:              \\sigma_k^2 sigma2_k   scalar
#> 24:                    \\rho      rho   scalar
#> 25:          \\mathrm{E}(MS)      EMS function
#> 26:                        d        d   scalar
#> 27:                        s        s   scalar
#>                       symbol     text     kind
#>                       <char>   <char>   <char>
#>                                                                          meaning
#>                                                                           <char>
#>  1:                                                       number of observations
#>  2:                                      rank of the fixed-effects design matrix
#>  3:                                                      response (observations)
#>  4: design matrix of the fixed effects (overparameterised: one column per level)
#>  5:                                                                fixed effects
#>  6:                                          design matrix of the random effects
#>  7:                                                               random effects
#>  8:                                                              residual errors
#>  9:                                      covariance matrix of the random effects
#> 10:                                           covariance matrix of the residuals
#> 11:                            covariance matrix of the observations: Z G Z' + R
#> 12:       covariance parameters (variance components, covariances, correlations)
#> 13:                derivative of V with respect to the i-th covariance parameter
#> 14:                                          V^-1 - V^-1 X (X' V^-1 X)^- X' V^-1
#> 15:               (X' V^-1 X)^-: covariance matrix of the fixed-effects solution
#> 16:                                           restricted and full log-likelihood
#> 17:                     coefficients of an estimate or contrast of fixed effects
#> 18:                    coefficients of random effects in a narrow-space estimate
#> 19:                                               denominator degrees of freedom
#> 20:           asymptotic covariance matrix of the covariance-parameter estimates
#> 21:                Kenward-Roger adjusted covariance matrix of the fixed effects
#> 22:                                                            residual variance
#> 23:                                           variance of the k-th random effect
#> 24:     correlation of the first-order autoregressive or spatial power structure
#> 25:                                                         expected mean square
#> 26:                                              number of covariance parameters
#> 27:                                                           number of subjects
#>                                                                          meaning
#>                                                                           <char>
#>     argument
#>       <char>
#>  1:     data
#>  2:    fixed
#>  3:    fixed
#>  4:    fixed
#>  5:    fixed
#>  6:   random
#>  7:   random
#>  8:         
#>  9:   random
#> 10: repeated
#> 11:         
#> 12:         
#> 13:         
#> 14:         
#> 15:         
#> 16:   method
#> 17:        L
#> 18:   random
#> 19:     ddfm
#> 20:         
#> 21:     ddfm
#> 22:         
#> 23:   random
#> 24: repeated
#> 25:     type
#> 26:         
#> 27: repeated
#>     argument
#>       <char>
```
