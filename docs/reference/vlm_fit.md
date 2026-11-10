# Fit a linear mixed model

Fits the linear mixed model \\\mathbf{y} =
\mathbf{X}\boldsymbol{\beta} + \mathbf{Z}\mathbf{u} + \mathbf{e}\\ by
restricted maximum likelihood (REML), maximum likelihood (ML) or the
method of moments on Type 3 mean squares, and gives the results of SAS
PROC MIXED: covariance parameter estimates with standard errors, the
solution for the fixed effects in the overparameterised coding, Type 3
(or Type 1) tests with containment, residual, between-within,
Satterthwaite or Kenward-Roger denominator degrees of freedom, and fit
statistics. It is the engine behind every analysis of the book of
Duchateau, Janssen and Rowlands (1998).

## Usage

``` r
vlm_fit(
  fixed,
  data,
  random = NULL,
  repeated = NULL,
  method = c("REML", "ML", "Type3"),
  ddfm = c("default", "contain", "residual", "betwithin", "satterth", "kr"),
  type = 3,
  class = NULL,
  bound = TRUE,
  control = list()
)

# Default S3 method
vlm_fit(
  fixed,
  data,
  random = NULL,
  repeated = NULL,
  method = c("REML", "ML", "Type3"),
  ddfm = c("default", "contain", "residual", "betwithin", "satterth", "kr"),
  type = 3,
  class = NULL,
  bound = TRUE,
  control = list()
)
```

## Arguments

- fixed:

  two-sided formula of the response and the fixed effects, such as
  `Pcv ~ Drug * dose`; terms are kept in the order written, as in a SAS
  MODEL statement (`a/b` gives `a + a:b`).

- data:

  a data frame (or `data.table`) with the variables.

- random:

  `NULL`, a one-sided formula of random variance components (each term
  one component, such as `~ Region + Region:Drug`), a
  [`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)
  specification, or a list of these.

- repeated:

  `NULL` or a
  [`vlm_repeated()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)
  specification of the residual covariance.

- method:

  `"REML"` (default), `"ML"` or `"Type3"`.

- ddfm:

  denominator degrees of freedom: `"default"`, `"contain"`,
  `"residual"`, `"betwithin"`, `"satterth"` or `"kr"`, the DDFM=
  keywords of SAS.

- type:

  type of the tests of fixed effects: 3 (default) or 1 (sequential).

- class:

  optional character vector of numeric variables to treat as
  classification variables (factors), like the SAS CLASS statement.
  Non-numeric variables and the variables of random effects and subjects
  are always classification variables.

- bound:

  logical; keep variance estimates non-negative (default `TRUE`; `FALSE`
  is the SAS NOBOUND option).

- control:

  list with `maxit` (default 200), `tol` (default \\10^{-12}\\) and
  `start` (starting values of the covariance parameters, in the order of
  the covariance table).

## Value

A list of class `c("vlm_fit", "vlm_result", "list")` with `covariance`
(covariance parameter estimates, standard errors and Wald Z tests),
`fixed` (solution for the fixed effects), `tests` (tests of the fixed
effects), `fit` (fit statistics) and `dimensions`; the call is kept in
`attr(, "call")`. Further analyses of the fit:
[`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_contrast()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md),
[`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md)
and
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md).

## Details

With \\\mathbf{u} \sim N(\mathbf{0}, \mathbf{G})\\ and \\\mathbf{e} \sim
N(\mathbf{0}, \mathbf{R})\\ independent, \\\mathbf{V} =
\mathbf{Z}\mathbf{G}\mathbf{Z}^{\top} + \mathbf{R}\\ depends on the
covariance parameters \\\boldsymbol{\theta}\\. With \\P =
\mathrm{rank}(\mathbf{X})\\ and \\N\\ observations, the REML
log-likelihood is \$\$\ell_R(\boldsymbol{\theta}) =
-\frac{1}{2}\left\\(N - P)\log(2\pi) + \log\|\mathbf{V}\| +
\log\|\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{X}\| +
\mathbf{r}^{\top}\mathbf{V}^{-1}\mathbf{r}\right\\,\$\$ with
\\\mathbf{r} = \mathbf{y} - \mathbf{X}\widehat{\boldsymbol{\beta}}\\;
the ML log-likelihood drops the third term and uses \\N\\ in the first.
It is maximised by Newton steps with the average-information matrix
\\\frac{1}{2}\mathbf{y}^{\top}\mathbf{P}\mathbf{V}\_i\mathbf{P}\mathbf{V}\_j\mathbf{P}\mathbf{y}\\,
where \\\mathbf{V}\_i = \partial\mathbf{V}/\partial\theta_i\\ and
\\\mathbf{P} = \mathbf{V}^{-1} -
\mathbf{V}^{-1}\mathbf{X}(\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{X})^{-}\mathbf{X}^{\top}\mathbf{V}^{-1}\\,
with step halving and variances kept non-negative (unless
`bound = FALSE`). The fixed effects are the generalised least-squares
solution \$\$\widehat{\boldsymbol{\beta}} =
(\mathbf{X}^{\top}\widehat{\mathbf{V}}^{-1}\mathbf{X})^{-}
\mathbf{X}^{\top}\widehat{\mathbf{V}}^{-1}\mathbf{y}\$\$ in the
overparameterised coding (one column per level), with the generalised
inverse that sets aliased levels to zero, as SAS does. Standard errors
of the covariance parameters come from the observed information.

Type 3 tests use the sum-to-zero coding of each effect (the SAS Type 3
hypothesis when every cell is observed). The denominator degrees of
freedom (`ddfm`) are: `"contain"`, the rank contribution of the random
effects that contain the fixed effect, or \\N -
\mathrm{rank}\[\mathbf{X}\\ \mathbf{Z}\]\\ if none does; `"residual"`,
\\N - \mathrm{rank}\[\mathbf{X}\\ \mathbf{Z}\]\\; `"betwithin"`, the
between- and within-subject parts of the residual degrees of freedom;
`"satterth"`, \\\nu = 2\\\mathbf{l}^{\top}\mathbf{C}\mathbf{l}\\^2 /
\mathbf{g}^{\top}\mathbf{A}\mathbf{g}\\, with \\\mathbf{g}\\ the
gradient of \\\mathbf{l}^{\top}\mathbf{C}\mathbf{l}\\ in
\\\boldsymbol{\theta}\\ and \\\mathbf{A}\\ the asymptotic covariance of
\\\widehat{\boldsymbol{\theta}}\\ (Giesbrecht and Burns 1985; Fai and
Cornelius 1996 for several rows); `"kr"`, the adjusted covariance and
scaled F of Kenward and Roger (1997). `"default"` chooses as SAS:
containment with random effects, between-within with a residual
structure only, residual otherwise.

Method `"Type3"` (random variance components only) equates the Type 3
mean squares of the random effects to their expectations
([`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md));
negative solutions are set to zero.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block
information when block sizes are unequal. *Biometrika*, 58, 545-554.

Kenward, M. G. and Roger, J. H. (1997). Small sample inference for fixed
effects from restricted maximum likelihood. *Biometrics*, 53, 983-997.

## See also

[`vlm_random`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md),
[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_estimate`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
[`vlm_ems`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md)

Other VetResearchLMM models:
[`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md),
[`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# Example 2.5.1.1: PROC MIXED; CLASS drug dose region; MODEL pcv = drug dose drug*dose / SOLUTION;
# RANDOM region drug*region;
fm <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
fm
#> Linear mixed model: Pcv ~ Drug + dose + Drug:dose
#> Estimation: REML; denominator df: satterth; converged after 6 iterations
#> Random: Region; Region:Drug
#> 
#> Covariance parameter estimates
#>    parameter subject estimate     se      z      p
#>       Region            5.151  3.739  1.378 0.0842
#>  Region:Drug           0.3870  1.022 0.3788 0.3524
#>     Residual            2.096 0.9375  2.236 0.0127
#> 
#> Fit statistics
#>                 statistic   value
#>     -2 Res Log Likelihood 92.3786
#>   AIC (smaller is better) 98.3786
#>  AICC (smaller is better) 99.8786
#>   BIC (smaller is better) 101.366
#> 
#> Solution for fixed effects
#>       effect     level estimate     se    df      t        p
#>  (Intercept)              17.13  1.128 8.208  15.19  < 1e-04
#>         Drug   BERENIL    7.150 0.9098 11.82  7.859  < 1e-04
#>         Drug   samorin        0                            .
#>         dose         h    4.350 0.8359 10.00  5.204 0.000399
#>         dose         l        0                            .
#>    Drug:dose BERENIL h   -3.183  1.182 10.00 -2.693 0.022594
#>    Drug:dose BERENIL l        0                            .
#>    Drug:dose samorin h        0                            .
#>    Drug:dose samorin l        0                            .
#> 
#> Type 3 tests of fixed effects
#>     effect num_df den_df     F        p
#>       Drug      1  5.000 64.58 0.000483
#>       dose      1  10.00 21.78 0.000886
#>  Drug:dose      1  10.00 7.251 0.022594
#> 
#> Sources: Duchateau, Janssen and Rowlands (1998); Patterson and Thompson (1971);
#> Gilmour, Thompson and Cullis (1995); Littell, Milliken, Stroup and Wolfinger
#> (1996); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
#> (1996). Full references: vlm_cite(x).
fm$covariance
#>      parameter subject estimate       se         z          p
#>         <char>  <char>    <num>    <num>     <num>      <num>
#> 1:      Region         5.150833 3.739172 1.3775332 0.08417372
#> 2: Region:Drug         0.387000 1.021605 0.3788156 0.35241241
#> 3:    Residual         2.096417 0.937546 2.2360680 0.01267366
fm$fixed
#>         effect     level  estimate        se        df         t            p
#>         <char>    <char>     <num>     <num>     <num>     <num>        <num>
#> 1: (Intercept)           17.133333 1.1279960  8.208034 15.189179 2.687717e-07
#> 2:        Drug   BERENIL  7.150000 0.9098382 11.818516  7.858540 4.962661e-06
#> 3:        Drug   samorin  0.000000        NA        NA        NA           NA
#> 4:        dose         h  4.350000 0.8359459 10.000000  5.203686 3.991647e-04
#> 5:        dose         l  0.000000        NA        NA        NA           NA
#> 6:   Drug:dose BERENIL h -3.183333 1.1822060 10.000000 -2.692706 2.259450e-02
#> 7:   Drug:dose BERENIL l  0.000000        NA        NA        NA           NA
#> 8:   Drug:dose samorin h  0.000000        NA        NA        NA           NA
#> 9:   Drug:dose samorin l  0.000000        NA        NA        NA           NA

# Example 3.3, Model 2: first-order autoregressive residuals within an animal
ar <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
        , subject = ~ animal_id:breed
        , order   = ~ time
        )
    , method   = "REML"
    , ddfm     = "default"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
ar$covariance
#>    parameter         subject  estimate         se        z            p
#>       <char>          <char>     <num>      <num>    <num>        <num>
#> 1:     AR(1) animal_id:breed  0.621372 0.06415086 9.686106 3.454487e-22
#> 2:  Residual                 10.189815 1.70803804 5.965801 1.217183e-09
ar$fit
#>                         statistic         value
#>                            <char>         <num>
#>  1:         -2 Res Log Likelihood  7.931394e+02
#>  2:       AIC (smaller is better)  7.971394e+02
#>  3:      AICC (smaller is better)  7.972140e+02
#>  4:       BIC (smaller is better)  7.981093e+02
#>  5:            Res Log Likelihood -3.965697e+02
#>  6: AIC (SAS 6, larger is better) -3.985697e+02
#>  7: SBC (SAS 6, larger is better) -4.016696e+02
#>  8:     Null model LRT chi-square  7.115662e+01
#>  9:             Null model LRT df  1.000000e+00
#> 10:        Null model LRT p-value  3.299639e-17
```
