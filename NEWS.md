# Changes in VetResearchLMM Version 1.1.0
## Minor Changes

* Added package-level documentation for `?VetResearchLMM`.
* Added the School of Mathematical and Statistical Sciences, Clemson University, Clemson, South Carolina, USA
  affiliation in package metadata and package-level documentation.
* Added `report_mixed_model()` as an optional easystats/report integration for
  fitted mixed model objects.
* Added guarded `report::report()` calls throughout fitted example workflows
  and vignettes so model interpretation follows immediately after fitting.
* Added `emmeans_mixed_model()` as an optional `emmeans` integration for
  estimated marginal means and post hoc pairwise comparisons.
* Added `emmeans` calls to examples with least-squares means, contrasts,
  pairwise comparisons, or fitted trend interpretation.
* Modernized example preprocessing with `collapse::fmutate()` for factor and
  indicator-variable creation.
* Updated the minimum R version to 4.1.0 because the modernized examples use
  the base R pipe operator.
* Added Quarto vignettes for package introduction, mixed model methodology,
  book examples, and ggplot2-based plotting.
* Added pkgdown configuration with reference and article organization and
  cleaner typography for the package site.
* Added regression tests for book examples with readable numerical targets.
* Added testthat data-integrity tests for bundled datasets.
* Updated dataset documentation to match the packaged data objects.
* Moved modelling packages used only in examples to Suggests and added
  `ggplot2` for plotting vignettes.
* Refreshed package metadata needed by current R CMD check and bumped the
  package version to 1.1.0.

# Changes in VetResearchLMM  Version 1.0.0
## Minor Changes 

* Prepare for new version of lmerTest

# Changes in VetResearchLMM  Version 0.2.0
## Minor Changes 

* Refined code and Improved documentation.

# Changes in VetResearchLMM  Version 0.1.0
## New Features 

* First version of VetResearchLMM. 
