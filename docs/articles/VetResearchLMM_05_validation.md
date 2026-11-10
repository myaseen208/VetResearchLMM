# Validation of VetResearchLMM

\\ \newcommand{\vy}{\mathbf{y}} \newcommand{\vx}{\mathbf{x}}
\newcommand{\vb}{\mathbf{b}} \newcommand{\ve}{\mathbf{e}}
\newcommand{\vone}{\mathbf{1}} \newcommand{\vbeta}{\boldsymbol{\beta}}
\newcommand{\vmu}{\boldsymbol{\mu}} \newcommand{\mX}{\mathbf{X}}
\newcommand{\mZ}{\mathbf{Z}} \newcommand{\mV}{\mathbf{V}}
\newcommand{\mI}{\mathbf{I}} \newcommand{\mJ}{\mathbf{J}}
\newcommand{\mSigma}{\boldsymbol{\Sigma}} \newcommand{\vg}{\mathbf{g}}
\newcommand{\vc}{\mathbf{c}} \newcommand{\vz}{\mathbf{z}}
\newcommand{\vlambda}{\boldsymbol{\lambda}} \newcommand{\mA}{\mathbf{A}}
\newcommand{\mB}{\mathbf{B}} \newcommand{\mK}{\mathbf{K}}
\newcommand{\mD}{\mathbf{D}} \newcommand{\mL}{\mathbf{L}}
\newcommand{\mQ}{\mathbf{Q}} \newcommand{\vu}{\mathbf{u}}
\newcommand{\vr}{\mathbf{r}} \newcommand{\vl}{\mathbf{l}}
\newcommand{\vk}{\mathbf{k}} \newcommand{\vtheta}{\boldsymbol{\theta}}
\newcommand{\mG}{\mathbf{G}} \newcommand{\mR}{\mathbf{R}}
\newcommand{\mP}{\mathbf{P}} \newcommand{\mC}{\mathbf{C}}
\newcommand{\mH}{\mathbf{H}} \newcommand{\mW}{\mathbf{W}}
\newcommand{\mPhi}{\boldsymbol{\Phi}} \newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}} \newcommand{\Cov}{\mathrm{Cov}}
\newcommand{\tr}{\operatorname{tr}} \\

## 1 Abstract

The engine of **VetResearchLMM** is checked in two ways: against every
number the book prints for the data it gives in full, and against
established R packages on unbalanced data. The book’s numbers are
reproduced (one printed value is truncated), and the likelihoods,
variance components, Satterthwaite and Kenward-Roger degrees of freedom
and least-squares means agree with **lme4**, **lmerTest**, **pbkrtest**,
**nlme** and **emmeans**.

## 2 The published values

``` r

ref <-
  vlm_reference(
      source   = NULL
    , evaluate = TRUE
    , level    = 1
    )
c(values = nrow(ref), agree = sum(ref$agrees))
```

    values  agree
       116    115 

``` r

ref[agrees == FALSE, c("id", "value", "computed", "note")]
```

               id value computed
           <char> <num>    <num>
    1: e2431_sire 3.685 3.685537
                                                                   note
                                                                 <char>
    1: the book truncates 3.6855 (also given by lme4 and nlme) to 3.685

## 3 Against other packages

These checks run in the tests of the package
(`tests/testthat/test-engine.R`) when the packages are installed.

``` r

d <- ex31
d$cell <- interaction(d$drug, d$dose, drop = TRUE)
fm <-
  vlm_fit(
      fixed    = PCV2 ~ drug + drug:dose
    , data     = ex31
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = "satterth"
    , type     = 3
    , class    = c("herd", "dose")
    , bound    = TRUE
    , control  = list()
    )
lt <- lmerTest::lmer(formula = PCV2 ~ 0 + cell + (1 | drug:herd), data = d)
ct <- lmerTest::contest(lt, rbind(c(0.5, -1, 0.5)), joint = TRUE)
data.frame(package = c("VetResearchLMM", "lmerTest"), F = c(fm$tests$F[1L], ct[["F value"]]),
           den_df = c(fm$tests$den_df[1L], ct[["DenDF"]]))
```

             package           F   den_df
    1 VetResearchLMM 0.001544608 10.08194
    2       lmerTest 0.001544636 10.08200

``` r

ar <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[4]
        , subject = ~ animal_id:breed
        , order   = ~ time
        )
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
ex33$sub <- interaction(ex33$animal_id, ex33$breed, drop = TRUE)
g <-
  nlme::gls(
      model       = PCV ~ breed + breed:time
    , data        = ex33
    , correlation = nlme::corExp(form = ~ time | sub)
    , method      = "REML"
    )
c(VetResearchLMM = -ar$fit$value[1L] / 2, nlme = as.numeric(stats::logLik(g)))
```

    VetResearchLMM           nlme
         -414.6905      -414.6905 

## 4 Differences from the book

- **Data.** Version 1.1.0 had three typing errors in `ex33` (two
  measurement days and a trailing space in an animal identifier); with
  them, the variances of Example 3.3 were 5.522 and 4.943 instead of the
  printed 5.478 and 4.965. Version 2.0.0 corrects them.
- **Containment degrees of freedom of random coefficient models.** For
  Model 3 of Example 3.3, SAS 6.12 (used by the book) gives the fixed
  effects 144 or 10 degrees of freedom by rules that later versions of
  SAS changed; the package follows the current containment rule (the
  random effect `time` per animal contains `breed*time`), which
  gives 10. The estimates and standard errors agree.
- **Information criteria.** SAS 6.12 printed the “larger is better”
  forms \\\ell - d\\ and \\\ell - \tfrac{d}{2}\log(N - P)\\; they are
  given next to the current forms.
- **Rounding.** The book rounds or truncates some numbers computed from
  rounded variance components (for example 1.0975 and 0.698 in Example
  2.5.3.1); they are compared at the precision that the book’s own
  computation supports.
