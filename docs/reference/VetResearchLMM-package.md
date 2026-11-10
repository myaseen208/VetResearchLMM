# VetResearchLMM: Linear Mixed Models with Applications in Veterinary Research

The VetResearchLMM package gives the data sets and every analysis of
Duchateau, Janssen and Rowlands (1998), *Linear Mixed Models. An
Introduction with Applications in Veterinary Research*, with its own
engine for linear mixed models. The engine gives the results that the
book prints from SAS PROC MIXED and PROC GLM, and extends them.

## Functions

- [`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md):

  fits a linear mixed model by REML, ML or Type 3 moments: covariance
  parameters, fixed-effects solution, Type 3 or Type 1 tests and fit
  statistics.

- [`vlm_random()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md),
  [`vlm_repeated()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md):

  random coefficients (VC or UN) and residual structures (CS, AR(1),
  SP(POW), UN).

- [`vlm_lsmeans()`](https://myaseen208.com/VetResearchLMM/reference/vlm_lsmeans.md),
  [`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md),
  [`vlm_contrast()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md):

  least-squares means, estimates in the broad and narrow inference
  spaces, and contrasts.

- [`vlm_blup()`](https://myaseen208.com/VetResearchLMM/reference/vlm_blup.md):

  best linear unbiased predictions of the random effects.

- [`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md):

  analysis of variance with expected mean squares and synthesised F
  tests.

- [`vlm_compare()`](https://myaseen208.com/VetResearchLMM/reference/vlm_compare.md):

  information criteria and likelihood ratio tests of several fits.

- [`vlm_interpret()`](https://myaseen208.com/VetResearchLMM/reference/vlm_interpret.md),
  [`vlm_cite()`](https://myaseen208.com/VetResearchLMM/reference/vlm_cite.md),
  [`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md):

  plain-language interpretation, references and a shiny application.

- [`emmeans_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/emmeans_mixed_model.md),
  [`report_mixed_model()`](https://myaseen208.com/VetResearchLMM/reference/report_mixed_model.md):

  the helpers of version 1.1.0, now also for `vlm_fit` results.

The help pages
[`Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md)
to
[`Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)
give the code of every example of the book, and the data sets are
[`ex121`](https://myaseen208.com/VetResearchLMM/reference/ex121.md) to
[`ex127`](https://myaseen208.com/VetResearchLMM/reference/ex127.md),
[`ex31`](https://myaseen208.com/VetResearchLMM/reference/ex31.md),
[`ex32`](https://myaseen208.com/VetResearchLMM/reference/ex32.md) and
[`ex33`](https://myaseen208.com/VetResearchLMM/reference/ex33.md).

## References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.

## See also

Useful links:

- <https://myaseen208.com/VetResearchLMM/>

- <https://github.com/myaseen208/VetResearchLMM>

- Report bugs at <https://github.com/myaseen208/VetResearchLMM/issues>

## Author

Muhammad Yaseen (<myaseen208@gmail.com>); the book and its data: Luc
Duchateau, Paul Janssen and John Rowlands.
