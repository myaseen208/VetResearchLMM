# The examples of Chapters 1 and 2

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

Every example of Chapters 1 and 2 of Duchateau, Janssen and Rowlands
(1998), with the SAS program of Appendix B, the same analysis with
**VetResearchLMM**, and the numbers printed in the book next to the
computed ones. All of them agree (the variance 3.685 of Example 2.4.3.1
is printed truncated; it is 3.6855).

``` r

ref <-
  vlm_reference(
      source   = NULL
    , evaluate = TRUE
    , level    = 1
    )
show_ref <- function(pattern) {
  r <- ref[grepl(pattern = pattern, x = ref$source)]
  knitr::kable(x = r[, c("quantity", "value", "computed", "agrees")], digits = 4,
               col.names = c("Quantity", "Book", "Computed", "Agrees"))
}
```

## 2 Example 1.3.2: expected mean squares

Drugs were given to whole herds and doses to animals (`ex124`). With
herd random, drug must be tested against herd within drug, as the
expected mean squares show; when one animal is removed, the two expected
mean squares no longer match (9.7143 against 9.7222) and the F test
becomes approximate, one reason to prefer the mixed model.

``` r

em1 <-
  vlm_ems(
      fixed  = PCVdif ~ drug + drug:herd + dose + dose:drug
    , data   = ex124[-1, ]
    , random = ~ drug:herd
    , type   = 3
    , class  = "herd"
    )
em1
```

    Type 3 analysis of variance of PCVdif

    Analysis of variance
        source df     ss     ms                                              ems
          drug  1  1.619  1.619 Var(Residual) + 9.71429 Var(drug:herd) + Q(drug)
     drug:herd  2  10.99  5.496           Var(Residual) + 9.72222 Var(drug:herd)
          dose  1  167.2  167.2                          Var(Residual) + Q(dose)
     drug:dose  1 0.1687 0.1687                     Var(Residual) + Q(drug:dose)
      Residual 33  7.999 0.2424                                    Var(Residual)
          F den_df      p
     0.2948  2.000  0.642
      22.67  33.00 <1e-04
      689.6  33.00 <1e-04
     0.6958  33.00  0.410
                        .

    Error terms of the tests
        source                                             error
          drug 0.999184 MS(drug:herd) + 0.000816327 MS(Residual)
     drug:herd                                    1 MS(Residual)
          dose                                    1 MS(Residual)
     drug:dose                                    1 MS(Residual)

    Type 3 estimates of the variance components
     component estimate
     drug:herd   0.5404
      Residual   0.2424

    Sources: Duchateau, Janssen and Rowlands (1998); Searle, Casella and McCulloch
    (1992); Satterthwaite (1946). Full references: vlm_cite(x).

``` r

show_ref("Table 1.3.2")
```

| Quantity | Book | Computed | Agrees |
|:---|---:|---:|:---|
| coefficient of the herd variance in E(MS drug) | 10.0000 | 10.0000 | TRUE |
| coefficient of the herd variance in E(MS herd(drug)) | 10.0000 | 10.0000 | TRUE |
| coefficient in E(MS drug), one observation deleted | 9.7143 | 9.7143 | TRUE |
| coefficient in E(MS herd(drug)), one observation deleted | 9.7222 | 9.7222 | TRUE |

## 3 Example 2.2.1.7: one-way analysis of variance

``` r

f2217 <-
  vlm_fit(
      fixed    = PCVdiff ~ dose
    , data     = ex121
    , random   = NULL
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
vlm_estimate(
    fit    = f2217
  , L      = list("l vs mh" = list(dose = c(-0.5, 1, -0.5)))
  , random = NULL
  , level  = 0.95
  )
```

    Estimates (denominator df: residual)

    Estimates
       label estimate     se df      t       p  lower  upper space
     l vs mh   -3.683 0.9370 11 -3.930 0.00235 -5.745 -1.620 fixed

    Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
    (1991). Full references: vlm_cite(x).

``` r

show_ref("2.2.1")
```

| Quantity                        |    Book | Computed | Agrees |
|:--------------------------------|--------:|---------:|:-------|
| sum of squares among doses      | 80.7300 |  80.7268 | TRUE   |
| error sum of squares            | 30.9100 |  30.9075 | TRUE   |
| mean square among doses         | 40.3600 |  40.3634 | TRUE   |
| error mean square               |  2.8100 |   2.8098 | TRUE   |
| F statistic of dose             | 14.3700 |  14.3654 | TRUE   |
| p-value of dose                 |  0.0009 |   0.0009 | TRUE   |
| estimate l vs mh                | -3.6800 |  -3.6825 | TRUE   |
| standard error of l vs mh       |  0.9370 |   0.9370 | TRUE   |
| variance of l vs mh             |  0.8750 |   0.8781 | TRUE   |
| t of l vs mh                    | -3.9300 |  -3.9299 | TRUE   |
| F of the contrast l vs mh       | 15.4400 |  15.4442 | TRUE   |
| p-value of the contrast l vs mh |  0.0024 |   0.0024 | TRUE   |

## 4 Section 2.3.2: the models of Chapter 1

The randomised blocks of `ex122`, the herds nested in drug of `ex123`
and the ELISA data of `ex126`, where animals and times are random and
the mean is the only fixed effect:

``` r

f126 <-
  vlm_fit(
      fixed    = OD ~ 1
    , data     = ex126
    , random   = ~ anim_id + time
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = "time"
    , bound    = TRUE
    , control  = list()
    )
f126$covariance
```

       parameter subject     estimate           se        z            p
          <char>  <char>        <num>        <num>    <num>        <num>
    1:   anim_id         0.0193086158 1.578702e-02 1.223069 1.106517e-01
    2:      time         0.0001238079 8.874540e-05 1.395090 8.149429e-02
    3:  Residual         0.0005826121 9.578042e-05 6.082789 5.905472e-10

## 5 Example 2.4.2.2: ML and REML

``` r

ml <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "ML"
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
reml <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = "REML"
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
data.frame(
    component = reml$covariance$parameter
  , ML        = ml$covariance$estimate
  , REML      = reml$covariance$estimate
  )
```

        component       ML     REML
    1      Region 4.292361 5.150833
    2 Region:Drug 0.322500 0.387000
    3    Residual 1.747014 2.096417

``` r

show_ref("Table 2.4.2.1")
```

| Quantity                         |  Book | Computed | Agrees |
|:---------------------------------|------:|---------:|:-------|
| ML region variance               | 4.292 |   4.2924 | TRUE   |
| ML herd within region variance   | 0.322 |   0.3225 | TRUE   |
| ML residual variance             | 1.747 |   1.7470 | TRUE   |
| REML region variance             | 5.151 |   5.1508 | TRUE   |
| REML herd within region variance | 0.387 |   0.3870 | TRUE   |
| REML residual variance           | 2.096 |   2.0964 | TRUE   |

## 6 Example 2.4.3.1: best linear unbiased prediction

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
vlm_blup(
    fit   = fs
  , level = 0.95
  )
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

show_ref("2.4.3.1")
```

| Quantity             |   Book | Computed | Agrees |
|:---------------------|-------:|---------:|:-------|
| sire variance        |  3.685 |   3.6855 | FALSE  |
| residual variance    |  3.542 |   3.5418 | TRUE   |
| overall mean         | 13.970 |  13.9686 | TRUE   |
| prediction of sire 4 |  3.160 |   3.1588 | TRUE   |

## 7 Examples 2.5.1.1 to 2.5.4.1: fixed effects, estimates and inference spaces

``` r

fm <-
  vlm_fit(
      fixed    = Pcv ~ Drug + dose + Drug:dose
    , data     = ex125
    , random   = ~ Region + Region:Drug
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = "satterth"
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
fm$fixed
```

            effect     level  estimate        se        df         t            p
            <char>    <char>     <num>     <num>     <num>     <num>        <num>
    1: (Intercept)           17.133333 1.1279960  8.208034 15.189179 2.687717e-07
    2:        Drug   BERENIL  7.150000 0.9098382 11.818516  7.858540 4.962661e-06
    3:        Drug   samorin  0.000000        NA        NA        NA           NA
    4:        dose         h  4.350000 0.8359459 10.000000  5.203686 3.991647e-04
    5:        dose         l  0.000000        NA        NA        NA           NA
    6:   Drug:dose BERENIL h -3.183333 1.1822060 10.000000 -2.692706 2.259450e-02
    7:   Drug:dose BERENIL l  0.000000        NA        NA        NA           NA
    8:   Drug:dose samorin h  0.000000        NA        NA        NA           NA
    9:   Drug:dose samorin l  0.000000        NA        NA        NA           NA

``` r

vlm_estimate(
    fit    = fm
  , L      = list(
        "broad"  = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
      , "narrow" = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
      )
  , random = list("narrow" = list(Region = rep(1 / 6, 6), "Region:Drug" = rep(c(0, 1 / 6), 6)))
  , level  = 0.95
  )
```

    Estimates (denominator df: satterth)

    Estimates
      label estimate     se    df     t      p lower upper  space
      broad    19.31  1.048 6.205 18.43 <1e-04 16.77 21.85  broad
     narrow    19.31 0.4180 10.00 46.20 <1e-04 18.38 20.24 narrow

    Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
    (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
    (1996). Full references: vlm_cite(x).

``` r

show_ref("2\\.5\\.|Table 2\\.5")
```

| Quantity | Book | Computed | Agrees |
|:---|---:|---:|:---|
| fixed-effect solution, row 1 | 17.1300 | 17.1333 | TRUE |
| variance of the solution, row 1 | 1.2700 | 1.2724 | TRUE |
| fixed-effect solution, row 2 | 7.1500 | 7.1500 | TRUE |
| variance of the solution, row 2 | 0.8300 | 0.8278 | TRUE |
| fixed-effect solution, row 4 | 4.3500 | 4.3500 | TRUE |
| variance of the solution, row 4 | 0.7000 | 0.6988 | TRUE |
| fixed-effect solution, row 6 | -3.1800 | -3.1833 | TRUE |
| variance of the solution, row 6 | 1.4000 | 1.3976 | TRUE |
| cell mean 1 | 25.4500 | 25.4500 | TRUE |
| cell mean 2 | 24.2800 | 24.2833 | TRUE |
| cell mean 3 | 21.4800 | 21.4833 | TRUE |
| cell mean 4 | 17.1300 | 17.1333 | TRUE |
| variance of a cell mean | 1.2700 | 1.2724 | TRUE |
| estimate c3 | 19.3100 | 19.3083 | TRUE |
| variance of estimate c3 | 1.0975 | 1.0977 | TRUE |
| Satterthwaite df of estimate c3 | 6.2000 | 6.2048 | TRUE |
| variance of estimate c4 | 0.4780 | 0.4784 | TRUE |
| Satterthwaite df of estimate c4 | 5.0000 | 5.0000 | TRUE |
| estimate c5 | 21.4800 | 21.4833 | TRUE |
| variance of estimate c5 | 1.2720 | 1.2724 | TRUE |
| Satterthwaite df of estimate c5 | 8.2000 | 8.2080 | TRUE |
| estimate c6 | 4.3500 | 4.3500 | TRUE |
| variance of estimate c6 | 0.6980 | 0.6988 | TRUE |
| Satterthwaite df of estimate c6 | 10.0000 | 10.0000 | TRUE |
| mean square, row 1 | 23.4700 | 23.4737 | TRUE |
| mean square, row 2 | 185.3700 | 185.3704 | TRUE |
| mean square, row 3 | 2.8700 | 2.8704 | TRUE |
| mean square, row 4 | 45.6500 | 45.6504 | TRUE |
| mean square, row 5 | 15.2000 | 15.2004 | TRUE |
| mean square, row 6 | 2.0960 | 2.0964 | TRUE |
| variance of the Samorin mean, narrow inference space | 0.1750 | 0.1747 | TRUE |

## 8 Example 2.6.1: general linear hypotheses

``` r

vlm_contrast(
    fit = fm
  , L   = list(
        "all" = list(
            list(Drug = c(1, -1), "Drug:dose" = c(0.5, 0.5, -0.5, -0.5))
          , list(dose = c(1, -1), "Drug:dose" = c(0.5, -0.5, 0.5, -0.5))
          , list("Drug:dose" = c(0.5, -0.5, -0.5, 0.5))
          )
      )
  )
```

    Contrasts (denominator df: satterth)

    Contrasts
     label num_df den_df     F        p
       all      3  7.143 31.20 0.000179

    Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
    (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
    (1996). Full references: vlm_cite(x).

``` r

show_ref("2.6.1")
```

| Quantity | Book | Computed | Agrees |
|:---|---:|---:|:---|
| F of the joint hypothesis of equal cell means | 31.2000 | 31.2019 | TRUE |
| Satterthwaite denominator df of the joint hypothesis | 7.1400 | 7.1429 | TRUE |
| p-value of the joint hypothesis | 0.0002 | 0.0002 | TRUE |
