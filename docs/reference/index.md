# Package index

## Models

- [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
  : Fit a linear mixed model
- [`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)
  [`vlm_repeated()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)
  : Random-effects and residual covariance structures
- [`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md)
  : Analysis of variance with expected mean squares
- [`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md)
  : Compare fitted models

## Inference

- [`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md)
  : Least-squares means
- [`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md)
  [`vlm_contrast()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md)
  : Estimates and contrasts of fixed (and random) effects
- [`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md)
  : Best linear unbiased predictions of the random effects

## The examples of the book

- [`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md)
  : Example 1.3.2: expected mean squares in the fixed and the mixed
  model
- [`Examp2.2.1.7`](https://myaseen208.com/VetResearchLMM/reference/Examp2.2.1.7.md)
  : Example 2.2.1.7: one-way analysis of variance, an estimate and a
  contrast
- [`Examp2.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.3.2.md)
  : Example 2.3.2: the mixed model descriptions of Chapter 2
- [`Examp2.4.2.2`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.2.2.md)
  : Example 2.4.2.2: ML and REML estimates of variance components
- [`Examp2.4.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.4.3.1.md)
  : Example 2.4.3.1: best linear unbiased prediction of sire effects
- [`Examp2.5.1.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.1.1.md)
  : Example 2.5.1.1: generalised least-squares estimates of the fixed
  effects
- [`Examp2.5.2.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.2.1.md)
  : Example 2.5.2.1: cell means as estimable functions
- [`Examp2.5.3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.3.1.md)
  : Example 2.5.3.1: confidence intervals with Satterthwaite degrees of
  freedom
- [`Examp2.5.4.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.5.4.1.md)
  : Example 2.5.4.1: broad and narrow inference spaces
- [`Examp2.6.1`](https://myaseen208.com/VetResearchLMM/reference/Examp2.6.1.md)
  : Example 2.6.1: F tests of general linear hypotheses
- [`Examp3.1`](https://myaseen208.com/VetResearchLMM/reference/Examp3.1.md)
  : Example 3.1: a designed experiment with doses nested in drug and a
  covariate
- [`Examp3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp3.2.md)
  : Example 3.2: sires nested in breed, heritability and breed
  comparisons
- [`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)
  : Example 3.3: covariance structures for repeated measures

## Data sets of the book

- [`ex121`](https://myaseen208.com/VetResearchLMM/reference/ex121.md) :
  Example 1.2.1: comparing three doses of a drug
- [`ex122`](https://myaseen208.com/VetResearchLMM/reference/ex122.md) :
  Example 1.2.2: comparing two doses of a drug in a randomised block
  design
- [`ex123`](https://myaseen208.com/VetResearchLMM/reference/ex123.md) :
  Example 1.2.3: comparing two drugs with herds as experimental units
- [`ex124`](https://myaseen208.com/VetResearchLMM/reference/ex124.md) :
  Example 1.2.4: two drugs at two doses with two sizes of experimental
  units
- [`ex125`](https://myaseen208.com/VetResearchLMM/reference/ex125.md) :
  Example 1.2.5: two drugs at two doses in a split-plot design
- [`ex126`](https://myaseen208.com/VetResearchLMM/reference/ex126.md) :
  Example 1.2.6: variation in ELISA data
- [`ex127`](https://myaseen208.com/VetResearchLMM/reference/ex127.md) :
  Example 1.2.7: helminth resistance in sheep
- [`ex31`](https://myaseen208.com/VetResearchLMM/reference/ex31.md) :
  Example 3.1: two drugs and their doses, herds nested in drug (part of
  the data)
- [`ex32`](https://myaseen208.com/VetResearchLMM/reference/ex32.md) :
  Example 3.2: weaning weights of lambs by breed and sire (part of the
  data)
- [`ex33`](https://myaseen208.com/VetResearchLMM/reference/ex33.md) :
  Example 3.3: breed differences in susceptibility to trypanosomosis

## Results, plots and interpretation

- [`print(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`summary(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`print(`*`<summary.vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`format(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`as.data.table(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`as.data.frame(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  [`plot(`*`<vlm_result>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm-methods.md)
  : Methods for VetResearchLMM results
- [`autoplot.vlm_result()`](https://myaseen208.com/VetResearchLMM/reference/autoplot.vlm_result.md)
  : Plot a result
- [`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md)
  [`print(`*`<vlm_interpretation>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md)
  [`format(`*`<vlm_interpretation>`*`)`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md)
  : Plain-language interpretation of a result

## Application

- [`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md)
  [`vlm_app_object()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md)
  : Linear mixed models in a web browser

## Version 1.1.0

Kept, and extended to vlm_fit() results.

- [`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md)
  : Estimated marginal means for a fitted mixed model
- [`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md)
  : Report a fitted mixed model

## Utilities

- [`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md)
  : References of a result or of the package
- [`vlm_theme()`](https://myaseen208.com/VetResearchLMM/reference/vlm_theme.md)
  : ggplot2 theme of VetResearchLMM
- [`vlm_save()`](https://myaseen208.com/VetResearchLMM/reference/vlm_save.md)
  : Save a figure (vector PDF by default)
- [`vlm_notation()`](https://myaseen208.com/VetResearchLMM/reference/vlm_notation.md)
  : Notation of VetResearchLMM
- [`vlm_reference()`](https://myaseen208.com/VetResearchLMM/reference/vlm_reference.md)
  : Published values used by the tests and vignettes
- [`VetResearchLMM`](https://myaseen208.com/VetResearchLMM/reference/VetResearchLMM-package.md)
  [`VetResearchLMM-package`](https://myaseen208.com/VetResearchLMM/reference/VetResearchLMM-package.md)
  : VetResearchLMM: Linear Mixed Models with Applications in Veterinary
  Research
