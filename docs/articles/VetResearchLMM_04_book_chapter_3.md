# The examples of Chapter 3

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

Chapter 3 of the book applies the mixed model to a designed experiment
with a covariate (Example 3.1), to the estimation of heritability and
breeding values (Example 3.2) and to repeated measures with several
covariance structures (Example 3.3). The book prints only part of the
data of Examples 3.1 and 3.2, so their analyses run but cannot reproduce
the printed numbers; the complete data of Example 3.3 reproduce every
printed number.

``` r

ref <-
  vlm_reference(
      source   = "Example 3"
    , evaluate = TRUE
    , level    = 1
    )
```

## 2 Example 3.1: doses nested in drug, with a covariate

``` r

m1 <-
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
m1$tests
```

          effect num_df   den_df           F         p
          <char>  <int>    <num>       <num>     <num>
    1:      drug      1 10.08194 0.001544608 0.9694174
    2: drug:dose      1 31.51959 2.600111652 0.1168256

``` r

vlm_estimate(
    fit    = m1
  , L      = list(
        "Mean Samorin"         = list(Intercept = 1, drug = c(0, 1), "drug:dose" = c(0, 0, 1))
      , "Berenil 2 doses"      = list("drug:dose" = c(1, -1, 0))
      , "Ber vs Sam at dose 1" = list(drug = c(1, -1), "drug:dose" = c(1, 0, -1))
      )
  , random = NULL
  , level  = 0.95
  )
```

    Estimates (denominator df: satterth)

    Estimates
                    label estimate    se    df       t      p  lower  upper space
             Mean Samorin    24.17 1.038 15.36   23.28 <1e-04  21.96  26.38 broad
          Berenil 2 doses   -2.102 1.303 31.52  -1.612  0.117 -4.758 0.5548 broad
     Ber vs Sam at dose 1   -1.000 1.468 15.36 -0.6811  0.506 -4.123  2.123 broad

    Sources: Duchateau, Janssen and Rowlands (1998); McLean, Sanders and Stroup
    (1991); Satterthwaite (1946); Giesbrecht and Burns (1985); Fai and Cornelius
    (1996). Full references: vlm_cite(x).

Model 3 lets each treatment have its own slope on the PCV at treatment,
and compares the treatments for an animal with PCV1 = 18:

``` r

m3 <-
  vlm_fit(
      fixed    = PCV2 ~ drug + drug:dose + PCV1:drug:dose
    , data     = ex31
    , random   = ~ drug:herd
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = "kr"
    , type     = 3
    , class    = c("herd", "dose")
    , bound    = TRUE
    , control  = list()
    )
vlm_lsmeans(
    fit    = m3
  , specs  = ~ drug:dose
  , at     = list(PCV1 = 18)
  , diff   = FALSE
  , adjust = c("none", "tukey", "bonferroni", "sidak")
  , level  = 0.95
  )
```

    Least-squares means (denominator df: kr; 95% limits)

    Least squares means
        drug dose estimate    se    df     t      p lower upper
     BERENIL    1    24.20 1.987 29.16 12.18 <1e-04 20.14 28.27
     BERENIL    2    24.79 1.174 13.62 21.11 <1e-04 22.27 27.32
     SAMORIN    1    25.26 2.169 26.49 11.64 <1e-04 20.80 29.71

    Sources: Duchateau, Janssen and Rowlands (1998); Searle, Speed and Milliken
    (1980); Kenward and Roger (1997). Full references: vlm_cite(x).

## 3 Example 3.2: heritability and sire predictions

``` r

f32 <-
  vlm_fit(
      fixed    = Ww ~ sex + agew + breed
    , data     = ex32
    , random   = ~ breed:sire_id
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = "satterth"
    , type     = 3
    , class    = "breed"
    , bound    = TRUE
    , control  = list()
    )
f32$covariance
```

           parameter subject estimate       se        z            p
              <char>  <char>    <num>    <num>    <num>        <num>
    1: breed:sire_id         0.000000       NA       NA           NA
    2:      Residual         5.447347 1.020382 5.338539 4.684922e-08

``` r

vlm_lsmeans(
    fit    = f32
  , specs  = ~ breed
  , at     = NULL
  , diff   = TRUE
  , adjust = "tukey"
  , level  = 0.95
  )$lsmeans
```

        breed  estimate        se    df        t            p     lower    upper
       <char>     <num>     <num> <num>    <num>        <num>     <num>    <num>
    1:      1 13.123981 0.6055657    57 21.67227 3.343968e-29 11.911357 14.33661
    2:      2 12.396055 0.7201282    57 17.21368 3.012048e-24 10.954023 13.83809
    3:      3 10.598945 0.8773799    57 12.08022 2.364957e-17  8.842022 12.35587
    4:      4 12.740250 0.6569679    57 19.39250 8.957490e-27 11.424695 14.05581
    5:      5  9.722305 0.8625235    57 11.27193 3.896394e-16  7.995131 11.44948
    6:      6 10.050959 0.9686565    57 10.37618 9.546083e-15  8.111258 11.99066

On this part of the data the sire variance is estimated as zero, so the
heritability \\h^2 = 4\sigma_s^2/ (\sigma_s^2 + \sigma^2)\\ is zero;
with the complete data the book finds 0.49.

## 4 Example 3.3: covariance structures for repeated measures

Model 1 (a random animal effect, equivalently compound symmetry), Model
2 (first-order autoregressive errors) and Model 3 (a random intercept
and slope per animal):

``` r

cs <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[2]
        , subject = ~ animal_id:breed
        , order   = NULL
        )
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
ar <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = NULL
    , repeated = vlm_repeated(
          type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
        , subject = ~ animal_id:breed
        , order   = NULL
        )
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
rc <-
  vlm_fit(
      fixed    = PCV ~ breed + breed:time
    , data     = ex33
    , random   = vlm_random(
          effects = ~ 1 + time
        , subject = ~ animal_id:breed
        , type    = c("vc", "un")[2]
        )
    , repeated = NULL
    , method   = c("REML", "ML", "Type3")
    , ddfm     = c("default", "contain", "residual", "betwithin", "satterth", "kr")
    , type     = 3
    , class    = NULL
    , bound    = TRUE
    , control  = list()
    )
rc$covariance
```

       parameter         subject     estimate          se         z            p
          <char>          <char>        <num>       <num>     <num>        <num>
    1:   UN(1,1) animal_id:breed 12.464572630 6.049874059  2.060303 1.968480e-02
    2:   UN(2,1) animal_id:breed -0.255121593 0.142828341 -1.786211 7.406506e-02
    3:   UN(2,2) animal_id:breed  0.005758072 0.003777797  1.524188 6.373091e-02
    4:  Residual                  4.353042151 0.513010930  8.485282 1.075986e-17

``` r

cmp <-
  vlm_compare(
      CS   = cs
    , AR1  = ar
    , RC   = rc
    , test = TRUE
    )
cmp
```

    Comparison of 3 models; smallest AIC: RC

    Models
     model method cov_parms   m2ll    AIC   AICC    BIC  chisq df      p p_boundary
        CS   REML         2 783.45 787.45 787.53 788.42         .      .          .
       AR1   REML         2 793.14 797.14 797.21 798.11         .      .          .
        RC   REML         4 767.56 775.56 775.81 777.50 25.583  2 <1e-04          .

    Sources: Duchateau, Janssen and Rowlands (1998); Akaike (1974); Schwarz (1978).
    Full references: vlm_cite(x).

``` r

plot(cmp)
```

![](data:image/webp;base64,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)

The book compared Models 1 and 2 only (the restricted log-likelihoods
\\-391.73\\ and \\-396.57\\ favour compound symmetry); the random
coefficients model has a much smaller AIC still, as the negative
covariance of the intercepts and slopes (animals that start higher fall
faster) suggests.

``` r

knitr::kable(x = ref[, c("source", "quantity", "value", "computed", "agrees")], digits = 4,
             col.names = c("Source", "Quantity", "Book", "Computed", "Agrees"))
```

| Source | Quantity | Book | Computed | Agrees |
|:---|:---|---:|---:|:---|
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | animal variance | 5.4780 | 5.4785 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | residual variance | 4.9650 | 4.9649 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | fixed effect, row 1 | 35.0600 | 35.0602 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | standard error, row 1 | 1.0560 | 1.0558 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | containment df, row 1 | 10.0000 | 10.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | fixed effect, row 2 | -0.8420 | -0.8420 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | standard error, row 2 | 1.4930 | 1.4931 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | containment df, row 2 | 10.0000 | 10.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | fixed effect, row 4 | -0.4130 | -0.4134 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | standard error, row 4 | 0.0225 | 0.0225 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | containment df, row 4 | 154.0000 | 154.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | fixed effect, row 5 | -0.2760 | -0.2761 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | standard error, row 5 | 0.0225 | 0.0225 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | containment df, row 5 | 154.0000 | 154.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 3 | -0.6720 | -0.6720 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 4 | -2.4970 | -2.4967 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 5 | -2.3830 | -2.3827 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 2 | 3.0380 | 3.0379 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 6 | 0.0324 | 0.0324 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 1 | 2.4810 | 2.4811 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 7 | -1.6670 | -1.6671 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 8 | 2.6260 | 2.6264 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 9 | -1.6670 | -1.6671 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 10 | -0.3720 | -0.3723 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 11 | -1.7540 | -1.7543 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | prediction of animal 12 | 2.8340 | 2.8344 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | standard error of prediction | 1.0910 | 1.0912 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | df of the predictions | 154.0000 | 154.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | -2 restricted log-likelihood, compound symmetry | 783.4510 | 783.4514 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | Akaike’s criterion (SAS 6) | -393.7300 | -393.7257 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | Schwarz’s criterion (SAS 6) | -396.8300 | -396.8255 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | null model likelihood ratio chi-square | 80.8450 | 80.8447 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | Type 3 F, row 1 | 470.0500 | 470.0533 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | denominator df, row 1 | 154.0000 | 154.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | Type 3 F, row 2 | 0.3200 | 0.3180 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | denominator df, row 2 | 10.0000 | 10.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | Type 3 F, row 3 | 18.6200 | 18.6168 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 1 | denominator df, row 3 | 154.0000 | 154.0000 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | AR(1) correlation | 0.6210 | 0.6214 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | residual variance | 10.1900 | 10.1898 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | -2 restricted log-likelihood | 793.1390 | 793.1394 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | Akaike’s criterion (SAS 6) | -398.5700 | -398.5697 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | Schwarz’s criterion (SAS 6) | -401.6700 | -401.6696 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 2 | null model likelihood ratio chi-square | 71.1560 | 71.1566 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | UN(1,1) | 12.4600 | 12.4646 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | UN(2,1) | -0.2550 | -0.2551 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | UN(2,2) | 0.0058 | 0.0058 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | residual variance | 4.3530 | 4.3530 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | standard error of the intercept | 1.5010 | 1.5014 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | standard error of breed BO | 2.1230 | 2.1233 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | standard error of a slope | 0.0370 | 0.0375 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | random intercept of BO241 | -1.8360 | -1.8358 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | random slope of BO241 | 0.0563 | 0.0563 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | standard error of a random intercept | 1.6400 | 1.6376 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | standard error of a random slope | 0.0417 | 0.0417 | TRUE |
| Duchateau, Janssen and Rowlands (1998), Example 3.3, Model 3 | df of the predictions | 144.0000 | 144.0000 | TRUE |
