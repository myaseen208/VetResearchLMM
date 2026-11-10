# Random-effects and residual covariance structures

`vlm_random()` declares random coefficients for a subject (the
`RANDOM ... / SUBJECT= TYPE=` statement of SAS PROC MIXED), and
`vlm_repeated()` declares the covariance structure of the residuals
within a subject (the `REPEATED / SUBJECT= TYPE=` statement). Both are
passed to
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md).

## Usage

``` r
vlm_random(effects = ~1, subject, type = c("vc", "un"))

vlm_repeated(
  type = c("vc", "cs", "ar1", "sp_pow", "un"),
  subject,
  order = NULL
)
```

## Arguments

- effects:

  one-sided formula of the random coefficients, such as `~ 1 + time`
  (random intercept and slope) or `~ 1`.

- subject:

  one-sided formula of the subject, such as `~ animal_id:breed`; its
  variables are treated as classification variables and their
  combination identifies a subject.

- type:

  `"vc"` (variance components, independent coefficients; the default of
  `vlm_random()`) or `"un"` (unstructured) for `vlm_random()`; `"vc"`,
  `"cs"`, `"ar1"`, `"sp_pow"` or `"un"` for `vlm_repeated()`.

- order:

  one-sided formula of the time (or order) variable within a subject,
  such as `~ time`; required for `"sp_pow"` and `"un"`; for `"ar1"` the
  data order within a subject is used when it is `NULL`.

## Value

An object of class `vlm_random` or `vlm_repeated`: a list with the
arguments.

## Details

A random coefficient specification adds, for subject \\s\\ with design
rows \\\mathbf{z}\_{si}^{\top}\\ (the values of `effects` for
observation \\i\\), the term \\\mathbf{z}\_{si}^{\top}\mathbf{b}\_s\\
with \\\mathbf{b}\_s \sim N(\mathbf{0}, \mathbf{G}\_0)\\ independent
between subjects. With `type = "vc"`, \\\mathbf{G}\_0\\ is diagonal (one
variance per effect); with `type = "un"` it is unstructured and its
parameters are reported as \\UN(1,1)\\, \\UN(2,1)\\, \\UN(2,2)\\, ...,
as in SAS.

The residual structures for the observations of one subject, with
\\t_i\\ the order (or time) of observation \\i\\, are \$\$\mathrm{vc}:\\
\sigma^2\mathbf{I},\qquad \mathrm{cs}:\\ \sigma_1\mathbf{J} +
\sigma^2\mathbf{I},\qquad \mathrm{ar1}:\\ \sigma^2\rho^{\|r_i -
r_j\|},\qquad \mathrm{sp\\pow}:\\ \sigma^2\rho^{\|t_i - t_j\|},\qquad
\mathrm{un}:\\ \sigma\_{t_i t_j},\$\$ where \\r_i\\ is the rank of
\\t_i\\ among the distinct times in the data, \\\mathbf{J}\\ a matrix of
ones and \\\sigma_1\\ the compound-symmetry covariance. Observations of
different subjects are independent.

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi. Section 3.4.

Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D.
(1996). *SAS System for Mixed Models*. SAS Institute, Cary, NC.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

Other VetResearchLMM models:
[`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md),
[`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md),
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
# random intercept and slope per animal, unstructured covariance (Example 3.3, Model 3)
ri <-
  vlm_random(
      effects = ~ 1 + time
    , subject = ~ animal_id:breed
    , type    = "un"
    )
ri
#> Random coefficients ~1 + time, subject ~animal_id:breed, type UN

# first-order autoregressive residuals within an animal (Example 3.3, Model 2)
ar <-
  vlm_repeated(
      type    = "ar1"
    , subject = ~ animal_id:breed
    , order   = ~ time
    )
ar
#> Residual structure AR1, subject ~animal_id:breed, order ~time
```
