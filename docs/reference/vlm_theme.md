# ggplot2 theme of VetResearchLMM

The theme used by every
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) method of
VetResearchLMM (identical in all packages of the author):
[`theme_classic`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
with a serif font, black axis lines, ticks pointing inwards and no grid,
close to the look of TikZ/pgfplots figures in LaTeX documents. The
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) methods also
use `scales::pretty_breaks(n = 10)` on every continuous axis. Save
figures with
[`vlm_save`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md).

## Usage

``` r
vlm_theme(
  base_size = 11,
  base_family = "serif",
  ticks_inward = TRUE,
  legend_position = "bottom"
)
```

## Arguments

- base_size:

  base font size in points (default 11).

- base_family:

  font family (default `"serif"`; for example `"Latin Modern Roman"`
  when installed, to match LaTeX documents).

- ticks_inward:

  logical; ticks point into the panel, as in pgfplots (default `TRUE`).

- legend_position:

  position of the legend (default `"bottom"`).

## Value

A `ggplot2` theme.

## See also

Other VetResearchLMM utilities:
[`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md),
[`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md),
[`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
[`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
[`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md),
[`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md),
[`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md)

## Author

Muhammad Yaseen (<myaseen208@gmail.com>)

## Examples

``` r
library(ggplot2)
p <-
  ggplot(data = data.frame(x = 1:20, y = cumsum(sin(1:20))), mapping = aes(x = x, y = y)) +
  geom_line()
p +
  vlm_theme(
      base_size       = 11
    , base_family     = "serif"
    , ticks_inward    = TRUE
    , legend_position = "bottom"
    )

p +
  vlm_theme(
      base_size       = 12
    , base_family     = "serif"
    , ticks_inward    = FALSE
    , legend_position = "right"
    ) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10))
```
