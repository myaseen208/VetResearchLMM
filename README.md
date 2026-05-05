# VetResearchLMM: Linear Mixed Models - An Introduction with Applications in Veterinary Research

## Introduction

**VetResearchLMM** provides datasets and reproducible R examples for
*Linear Mixed Models: An Introduction with Applications in Veterinary
Research* by Duchateau, Janssen, and Rowlands.

Current package maintenance includes the School of Mathematical and
Statistical Sciences, Clemson University.

## Installation

### Stable Version

Install the stable version from
[CRAN](https://cran.r-project.org/package=VetResearchLMM):

```r
install.packages("VetResearchLMM")
```

### Development Version

Install the development version from
[GitHub](https://github.com/myaseen208/VetResearchLMM):

```r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

devtools::install_github("myaseen208/VetResearchLMM", build_vignettes = TRUE)
```

## Example

```r
data(ex31, package = "VetResearchLMM")
str(ex31)
```

Modern examples use `collapse::fmutate()` for compact preprocessing,
`ggplot2` for figures, optional `report_mixed_model()` for easystats-style
interpretation, and optional `emmeans_mixed_model()` for estimated marginal
means and post hoc comparisons.

```r
if (requireNamespace("lme4", quietly = TRUE) &&
    requireNamespace("emmeans", quietly = TRUE)) {
  data(ex125, package = "VetResearchLMM")
  fit <- lme4::lmer(Pcv ~ dose * Drug + (1 | Region / Drug), data = ex125)
  if (requireNamespace("report", quietly = TRUE)) {
    report::report(fit)
  }
  emmeans_mixed_model(fit, ~ dose | Drug, lmer.df = "asymptotic")
  emmeans_mixed_model(
    fit,
    ~ dose | Drug,
    pairwise = TRUE,
    lmer.df = "asymptotic"
  )
}
```

## Articles

The package includes Quarto articles covering the package overview, mixed model
methodology, book example mapping, and ggplot2 plotting workflows. These
articles are intended for pkgdown and applied users working through the book.

## License

This package is free and open source software, licensed under GPL.
