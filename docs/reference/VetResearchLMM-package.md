# VetResearchLMM: Linear Mixed Models for Veterinary Research Examples

The VetResearchLMM package provides the datasets and reproducible R
examples that accompany Duchateau, Janssen, and Rowlands (1998), *Linear
Mixed Models: An Introduction with Applications in Veterinary Research*.
The package is intended for readers who want to reproduce, inspect, and
adapt the linear mixed model examples from the book using current R
tooling.

## Details

The package focuses on small applied veterinary research examples
involving fixed effects, random effects, variance components, nested
designs, repeated measurements, and basic hypothesis tests for linear
mixed models. The package also includes
[`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)
and
[`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
small helpers that delegate fitted model interpretation and post hoc
marginal-mean inference to the optional report and emmeans packages when
they are installed. The main user-facing data objects are the book
datasets:

- [`ex121`](https://myaseen208.com/VetResearchLMM/reference/ex121.md):

  Dose comparison data for packed cell volume.

- [`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md):

  Herd, drug, and dose packed cell volume data.

- [`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md):

  Region, drug, and dose split-plot data.

- [`ex127`](https://myaseen208.com/VetResearchLMM/reference/ex127.md):

  Sire-level weaning weight data.

- [`ex31`](https://myaseen208.com/VetResearchLMM/reference/ex31.md):

  Designed experiment data for PCV response.

- [`ex32`](https://myaseen208.com/VetResearchLMM/reference/ex32.md):

  Breed, sire, sex, age, and weaning weight data.

- [`ex33`](https://myaseen208.com/VetResearchLMM/reference/ex33.md):

  Longitudinal PCV data by animal and breed.

The example help pages reproduce the corresponding analyses with modern
R packages such as lme4, lmerTest, nlme, multcomp, collapse, ggplot2,
and emmeans where those packages are available. Numerical results can
differ slightly from the book because the book reports SAS output and
modern R packages use their own optimizers, parameterizations, and
degrees-of-freedom methods.

A typical workflow is:

1.  Load one of the included datasets with
    [`data()`](https://rdrr.io/r/utils/data.html).

2.  Inspect the matching example help page, such as
    [`?Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md).

3.  Fit the fixed effect or mixed model shown in the example.

4.  Compare estimates, variance components, and tests with the book.

5.  Use
    [`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)
    for an optional narrative model report when report is installed.

6.  Use
    [`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md)
    for optional estimated marginal means and post hoc comparisons when
    emmeans is installed.

7.  Use the package vignettes for chapter-level narrative examples.

## Affiliation

School of Mathematical and Statistical Sciences, Clemson University,
Clemson, South Carolina, USA.

## Vignettes

The Quarto vignettes provide an introduction, methodology overview,
chapter/example walkthrough, and plotting guide:

- `vetresearchlmm-introduction`

- `vetresearchlmm-methodology`

- `vetresearchlmm-examples`

- `vetresearchlmm-plotting`

## References

Duchateau, L., Janssen, P., and Rowlands, G. J. (1998). *Linear Mixed
Models: An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute.

## See also

Useful links:

- <https://myaseen208.com/VetResearchLMM>

- <https://github.com/myaseen208/VetResearchLMM/>

- Report bugs at <https://github.com/myaseen208/VetResearchLMM/issues>

## Author

Muhammad Yaseen <myaseen208@gmail.com>
