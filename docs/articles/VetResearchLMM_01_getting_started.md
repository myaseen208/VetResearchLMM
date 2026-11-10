# Getting started with VetResearchLMM

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

**VetResearchLMM** contains the ten data sets and every analysis of
Duchateau, Janssen and Rowlands (1998), *Linear Mixed Models. An
Introduction with Applications in Veterinary Research*, and an engine
for linear mixed models that gives the results the book prints from SAS
PROC MIXED and PROC GLM. This vignette fits the split-plot experiment of
Example 1.2.5 in a few lines, reads the results, and points to the rest
of the package.

## 2 Why a mixed model?

An animal experiment rarely has a single source of random variation. In
Example 1.2.5, two drugs (Berenil and Samorin) were given to herds, one
herd per drug in each of six regions, and two doses to groups of animals
within each herd. Regions differ, herds within a region differ, and
animals differ: three sources of variation. A drug is compared between
herds, so its standard error must include the herd variation; a dose is
compared within herds, so its standard error does not. A model with a
single error term gets one of the two wrong. The linear mixed model \\
\vy = \mX\vbeta + \mZ\vu + \ve, \qquad \vu \sim N(\mathbf{0}, \mG),
\quad \ve \sim N(\mathbf{0}, \mR), \\ keeps the effects of interest
(drug, dose) fixed in \\\vbeta\\ and the sources of variation (region,
herd) random in \\\vu\\, so that \\\Var(\vy) = \mV = \mZ\mG\mZ^{\top} +
\mR\\ has a part for each source.

## 3 The data

``` r

str(ex125)
```

    'data.frame':   24 obs. of  4 variables:
     $ Region: int  1 1 1 1 2 2 2 2 3 3 ...
     $ Drug  : Factor w/ 2 levels "BERENIL","samorin": 1 1 2 2 1 1 2 2 1 1 ...
     $ dose  : Factor w/ 2 levels "h","l": 1 2 1 2 1 2 1 2 1 2 ...
     $ Pcv   : num  22.6 21.8 19.1 16.4 29 28.8 25.3 18.2 24 23.7 ...

## 4 Fit the model

The SAS program of the book (Appendix B.2.4) is

    proc mixed data=ex125;
      class drug dose region;
      model pcv = drug dose drug*dose / solution ddfm=satterth;
      random region drug*region;
    run;

and the same model with **VetResearchLMM** is

``` r

fm <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "REML"
    , ddfm     = "satterth"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
fm
```

    Linear mixed model: Pcv ~ Drug + dose + Drug:dose
    Estimation: REML; denominator df: satterth; converged after 6 iterations
    Random: Region; Region:Drug

    Covariance parameter estimates
       parameter subject estimate     se      z      p
          Region            5.151  3.739  1.378 0.0842
     Region:Drug           0.3870  1.022 0.3788 0.3524
        Residual            2.096 0.9375  2.236 0.0127

    Fit statistics
                    statistic   value
        -2 Res Log Likelihood 92.3786
      AIC (smaller is better) 98.3786
     AICC (smaller is better) 99.8786
      BIC (smaller is better) 101.366

    Solution for fixed effects
          effect     level estimate     se    df      t        p
     (Intercept)              17.13  1.128 8.208  15.19  < 1e-04
            Drug   BERENIL    7.150 0.9098 11.82  7.859  < 1e-04
            Drug   samorin        0                            .
            dose         h    4.350 0.8359 10.00  5.204 0.000399
            dose         l        0                            .
       Drug:dose BERENIL h   -3.183  1.182 10.00 -2.693 0.022594
       Drug:dose BERENIL l        0                            .
       Drug:dose samorin h        0                            .
       Drug:dose samorin l        0                            .

    Type 3 tests of fixed effects
        effect num_df den_df     F        p
          Drug      1  5.000 64.58 0.000483
          dose      1  10.00 21.78 0.000886
     Drug:dose      1  10.00 7.251 0.022594

    Sources: Duchateau, Janssen and Rowlands (1998); Patterson and Thompson (1971);
    Gilmour, Thompson and Cullis (1995); Littell, Milliken, Stroup and Wolfinger
    (1996); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
    (1996). Full references: vlm_cite(x).

The printout has the tables of SAS: the covariance parameter estimates
(5.151 for regions, 0.387 for herds within regions and 2.096 for
animals, as in Table 2.4.2.1 of the book), the fit statistics, the
solution for the fixed effects with the last level of each effect set to
zero (17.13, 7.15, 4.35 and \\-3.18\\, Example 2.5.1.1) and the Type 3
tests. Each component is a `data.table`:

``` r

fm$covariance
```

         parameter subject estimate       se         z          p
            <char>  <char>    <num>    <num>     <num>      <num>
    1:      Region         5.150833 3.739172 1.3775332 0.08417372
    2: Region:Drug         0.387000 1.021605 0.3788156 0.35241241
    3:    Residual         2.096417 0.937546 2.2360680 0.01267366

## 5 Read the results in plain language

``` r

vlm_interpret(
    x     = fm
  , alpha = 0.05
  , top   = 3
  )
```

    Linear mixed model

    Pcv ~ Drug + dose + Drug:dose, fitted by REML with 3 covariance parameters.

    Findings:
    - Of the total variance 7.63, 67.5% is due to Region, 5.1% is due to
      Region:Drug, 27.5% is due to the residual (within) variation.
    - Significant at the 0.05 level: Drug (F = 64.6 on 1 and 5 df, p = 0.00048);
      dose (F = 21.8 on 1 and 10 df, p = 0.00089); Drug:dose (F = 7.25 on 1 and
      10 df, p = 0.023).

    Recommendations:
    - The interaction Drug:dose is significant: compare the levels of one factor
      within each level of the other (vlm_lsmeans() of the interaction, or
      vlm_estimate()) rather than main-effect means.
    - Report means with standard errors in the broad inference space
      (vlm_lsmeans()); use vlm_estimate() with `random` for the narrow space of
      the observed levels.

    Sources:
    - Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). Linear Mixed Models.
      An Introduction with Applications in Veterinary Research. International
      Livestock Research Institute, Nairobi. ISBN 92-9146-038-9.
    - Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block
      information when block sizes are unequal. Biometrika, 58(3), 545-554.
      doi:10.1093/biomet/58.3.545
    - Gilmour, A. R., Thompson, R. and Cullis, B. R. (1995). Average information
      REML: an efficient algorithm for variance parameter estimation in linear
      mixed models. Biometrics, 51(4), 1440-1450. doi:10.2307/2533274
    - Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D. (1996).
      SAS System for Mixed Models. SAS Institute, Cary, NC.
    - Satterthwaite, F. E. (1946). An approximate distribution of estimates of
      variance components. Biometrics Bulletin, 2(6), 110-114.
      doi:10.2307/3002019
    - Giesbrecht, F. G. and Burns, J. C. (1985). Two-stage analysis based on a
      mixed model: large-sample asymptotic theory and small-sample simulation
      results. Biometrics, 41(2), 477-486. doi:10.2307/2530872
    - Fai, A. H.-T. and Cornelius, P. L. (1996). Approximate F-tests of multiple
      degree of freedom hypotheses in generalized least squares analyses of
      unbalanced split-plot experiments. Journal of Statistical Computation and
      Simulation, 54(4), 363-378. doi:10.1080/00949659608811740

## 6 Means, estimates and contrasts

Least-squares means of the four drug-dose combinations, with
Tukey-Kramer comparisons:

``` r

lm1 <-
  vlm_lsmeans(
      fit    = fm
    , specs  = ~ Drug:dose
    , at     = NULL
    , diff   = TRUE
    , adjust = "tukey"
    , level  = 0.95
    )
lm1
```

    Least-squares means (denominator df: satterth; 95% limits)

    Least squares means
        Drug dose estimate    se    df     t      p lower upper
     BERENIL    h    25.45 1.128 8.208 22.56 <1e-04 22.86 28.04
     BERENIL    l    24.28 1.128 8.208 21.53 <1e-04 21.69 26.87
     samorin    h    21.48 1.128 8.208 19.05 <1e-04 18.89 24.07
     samorin    l    17.13 1.128 8.208 15.19 <1e-04 14.54 19.72

    Differences of least squares means (adjustment: tukey)
       level_1   level_2 estimate     se    df     t        p p_adjusted   lower
     BERENIL h BERENIL l    1.167 0.8359 10.00 1.396 0.193041    0.52926  -1.391
     BERENIL h samorin h    3.967 0.9098 11.82 4.360 0.000962    0.00459   1.259
     BERENIL h samorin l    8.317 0.9098 11.82 9.141  < 1e-04    < 1e-04   5.609
     BERENIL l samorin h    2.800 0.9098 11.82 3.077 0.009738    0.04197 0.09258
     BERENIL l samorin l    7.150 0.9098 11.82 7.859  < 1e-04    < 1e-04   4.443
     samorin h samorin l    4.350 0.8359 10.00 5.204 0.000399    0.00188   1.793
     upper
     3.724
     6.674
     11.02
     5.507
     9.857
     6.907

    Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
    (1980); Kramer (1956); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai
    and Cornelius (1996). Full references: vlm_cite(x).

``` r

plot(lm1)
```

![](data:image/webp;base64,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)

Any linear combination is an ESTIMATE statement, coefficients given per
effect in the order of the levels of `fm$fixed`:

``` r

vlm_estimate(
    fit    = fm
  , L      = list(
        "drug dif"     = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
      , "Samorin mean" = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
      )
  , random = NULL
  , level  = 0.95
  )
```

    Estimates (denominator df: satterth)

    Estimates
            label estimate     se    df      t        p  lower  upper space
         drug dif   -5.558 0.6917 5.000 -8.036 0.000483 -7.336 -3.780 broad
     Samorin mean    19.31  1.048 6.205  18.43  < 1e-04  16.77  21.85 broad

    Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
    (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
    (1996). Full references: vlm_cite(x).

## 7 Predicting random effects

The book’s Example 2.4.3.1 predicts the merit of eight sires from the
weaning weights of their lambs:

``` r

fs <-
  vlm_fit(
      fixed    = Ww ~ 1
    , data     = ex127
    , random   = ~ sire
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
bl <-
  vlm_blup(
      fit   = fs
    , level = 0.95
    )
bl
```

    Best linear unbiased predictions of the random effects

    Solution for random effects
     effect level estimate     se df        t       p   lower   upper
       sire     1   -2.198  1.101 35   -1.997 0.05364  -4.432 0.03641
       sire     2 -0.03189 0.8983 35 -0.03550 0.97188  -1.855   1.792
       sire     3   -1.743  1.101 35   -1.584 0.12216  -3.978  0.4908
       sire     4    3.159 0.9589 35    3.294 0.00227   1.212   5.106
       sire     5   0.8692 0.9340 35   0.9306 0.35842  -1.027   2.765
       sire     6  -0.8628 0.9915 35  -0.8702 0.39013  -2.876   1.150
       sire     7    1.356  1.036 35    1.309 0.19922 -0.7475   3.459
       sire     8  -0.5476 0.9589 35  -0.5710 0.57162  -2.494   1.399

    Sources: Duchateau, Janssen and Rowlands (1998); Henderson (1975). Full
    references: vlm_cite(x).

``` r

plot(bl)
```

![](data:image/webp;base64,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)

## 8 Where next

- [`vignette("VetResearchLMM_02_theory")`](https://myaseen208.com/VetResearchLMM/articles/VetResearchLMM_02_theory.md):
  the methods, with formulas.
- [`vignette("VetResearchLMM_03_book_chapters_1_2")`](https://myaseen208.com/VetResearchLMM/articles/VetResearchLMM_03_book_chapters_1_2.md)
  and
  [`vignette("VetResearchLMM_04_book_chapter_3")`](https://myaseen208.com/VetResearchLMM/articles/VetResearchLMM_04_book_chapter_3.md):
  every example of the book, with the printed numbers next to the
  computed ones.
- [`vignette("VetResearchLMM_05_validation")`](https://myaseen208.com/VetResearchLMM/articles/VetResearchLMM_05_validation.md):
  checks against the book and against **lme4**, **lmerTest**,
  **pbkrtest** and **nlme**.
- [`vignette("VetResearchLMM_06_app")`](https://myaseen208.com/VetResearchLMM/articles/VetResearchLMM_06_app.md):
  the point-and-click application,
  [`vlm_app()`](https://myaseen208.com/VetResearchLMM/reference/vlm_app.md).
- The help pages
  [`?Examp1.3.2`](https://myaseen208.com/VetResearchLMM/reference/Examp1.3.2.md)
  to
  [`?Examp3.3`](https://myaseen208.com/VetResearchLMM/reference/Examp3.3.md)
  give the code of each example.

## 9 References

Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). *Linear Mixed
Models. An Introduction with Applications in Veterinary Research*.
International Livestock Research Institute, Nairobi.
