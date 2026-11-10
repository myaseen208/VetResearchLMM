# Linear mixed models in a web browser

`vlm_app()` starts the application of VetResearchLMM: choose a data set
of the book (or upload a CSV file), fit a linear mixed model with random
effects and a residual covariance structure, and obtain least-squares
means, estimates and contrasts, predictions of random effects, the
analysis of variance with expected mean squares, and a comparison of
covariance structures. Every example of the book can be loaded with one
click. Each result page shows an interpretation computed from the
results
([`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md)),
the output as R prints it, formatted tables, plots and the R code that
repeats the analysis, each with a Copy button.

## Usage

``` r
vlm_app(launch.browser = interactive(), ...)

vlm_app_object()
```

## Arguments

- launch.browser:

  passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html): `TRUE`
  (default in an interactive session) opens the application in the web
  browser.

- ...:

  further arguments to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), such
  as `port`.

## Value

`vlm_app()` is called for its side effect and returns the value of
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) when the
application is closed; `vlm_app_object()` returns the application object
(for [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html),
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
or deployment on a server).

## Details

The application needs the suggested packages shiny, bslib and DT. Plots
are sent to the browser as WebP images when magick is installed (PNG
otherwise) and can be downloaded as PNG, PDF or WebP. Estimates and
contrasts are typed as in SAS:
`label: effect coefficients effect coefficients`, one per line, with
rows of a contrast separated by commas.

## See also

[`vlm_fit`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md),
[`vlm_lsmeans`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
[`vlm_ems`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md)

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
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
if (interactive()) {
  vlm_app(
      launch.browser = TRUE
    )
}
```
