# Plot a result

`autoplot()` methods for the results of VetResearchLMM;
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws the same
figures. A fit shows its residuals (`which = "residuals"`, `"qq"` or
`"observed"`); least-squares means and estimates show their confidence
limits; predictions of random effects are drawn as a caterpillar plot; a
comparison shows the information criteria.

## Usage

``` r
autoplot.vlm_result(object, which = NULL, ...)
```

## Arguments

- object:

  a result of a function of the package.

- which:

  for
  [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
  results, `"residuals"` (default), `"qq"` or `"observed"`.

- ...:

  not used.

## Value

A `ggplot` object.

## See also

Other VetResearchLMM utilities:
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md),
[`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md),
[`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
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
ggplot2::autoplot(
    object = vlm_blup(
        fit   = fs
      , level = 0.95
      )
  )
#> `height` was translated to `width`.
```
