# The methods of VetResearchLMM

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

This vignette states the methods that
[`vlm_fit()`](https://myaseen208.com/VetResearchLMM/reference/vlm_fit.md)
and the functions that use a fit implement: the linear mixed model,
restricted and full maximum likelihood, the generalised least-squares
solution in the overparameterised coding, estimability, Type 3 and Type
1 tests, the five methods for the denominator degrees of freedom, the
broad and narrow inference spaces, best linear unbiased prediction,
expected mean squares, covariance structures and fit statistics. The
notation follows the book: scalars upper case, vectors lower-case bold,
matrices upper-case bold.

## 2 The model

With \\N\\ observations, \\ \vy = \mX\vbeta + \mZ\vu + \ve, \qquad \vu
\sim N(\mathbf{0}, \mG), \quad \ve \sim N(\mathbf{0}, \mR), \quad
\Var(\vy) = \mV(\vtheta) = \mZ\mG\mZ^{\top} + \mR, \\ where \\\vtheta\\
holds the covariance parameters. \\\mX\\ is overparameterised, as in
SAS: one column for every level (or observed cell) of a classification
effect, so that its rank \\P\\ is smaller than its number of columns.

**Random effects.** A term of `random = ~ Region + Region:Drug`
contributes \\\sigma_k^2\mZ_k\mZ_k^{\top}\\ to \\\mV\\, with \\\mZ_k\\
the indicators of its levels.
`vlm_random(effects = ~ 1 + time, subject = ~ animal, type = "un")`
gives every subject \\s\\ a vector \\\vb_s \sim N(\mathbf{0}, \mG_0)\\
of coefficients; `type = "un"` leaves \\\mG_0\\ unstructured, with
parameters \\UN(1,1), UN(2,1), UN(2,2)\\, and `type = "vc"` makes it
diagonal.

**Residual structures** within a subject
([`vlm_repeated()`](https://myaseen208.com/VetResearchLMM/reference/vlm_random.md)),
with \\t_i\\ the time and \\r_i\\ the rank of the time of observation
\\i\\: \\ \mathrm{CS}: \sigma_1 + \sigma^2\delta\_{ij}, \qquad
\mathrm{AR(1)}: \sigma^2\rho^{\|r_i - r_j\|}, \qquad \mathrm{SP(POW)}:
\sigma^2\rho^{\|t_i - t_j\|}, \qquad \mathrm{UN}: \sigma\_{t_i t_j}. \\

## 3 Estimation

### 3.1 Likelihoods

With \\\vr = \vy - \mX\widehat{\vbeta}\\ the generalised least-squares
residuals, the restricted (REML) and full (ML) log-likelihoods are \\
\ell_R(\vtheta) = -\tfrac{1}{2}\left\\(N - P)\log 2\pi + \log\|\mV\| +
\log\|\mX^{\top}\mV^{-1}\mX\| + \vr^{\top}\mV^{-1}\vr\right\\, \qquad
\ell(\vtheta) = -\tfrac{1}{2}\left\\N\log 2\pi + \log\|\mV\| +
\vr^{\top}\mV^{-1}\vr\right\\, \\ where \\\mX\\ is restricted to its
\\P\\ non-aliased columns (Patterson and Thompson 1971; Harville 1977).
REML accounts for the degrees of freedom used by the fixed effects; ML
underestimates the variances (Table 2.4.2.1 of the book).

### 3.2 Maximisation

With \\\mV_i = \partial\mV/\partial\theta_i\\ and \\\mP = \mV^{-1} -
\mV^{-1}\mX(\mX^{\top}\mV^{-1}\mX)^{-}\mX^{\top}\mV^{-1}\\ (for ML,
\\\mP = \mV^{-1}\\), the score and the average information (Gilmour,
Thompson and Cullis 1995) are \\ \frac{\partial\ell_R}{\partial\theta_i}
= -\tfrac{1}{2}\tr(\mP\mV_i) + \tfrac{1}{2}\vy^{\top}\mP\mV_i\mP\vy,
\qquad \mathcal{I}\_{ij} = \tfrac{1}{2}\vy^{\top}\mP\mV_i\mP\mV_j\mP\vy.
\\ Newton steps \\\vtheta \leftarrow \vtheta +
\mathcal{I}^{-1}\nabla\ell_R\\ are halved until the likelihood
increases; variances stay non-negative (parameters on the bound leave
the step), as in SAS. The standard errors of \\\widehat{\vtheta}\\ come
from the observed information, the Hessian of \\-\ell_R\\, computed from
the analytic score.

### 3.3 Method of moments

`method = "Type3"` equates the Type 3 mean squares of the random effects
and the residual to their expectations (next section but one) and solves
for the variance components; negative solutions are set to zero.

## 4 Fixed effects

The generalised least-squares solution is \\ \widehat{\vbeta} =
\mC\mX^{\top}\mV^{-1}\vy, \qquad \mC = (\mX^{\top}\mV^{-1}\mX)^{-}, \\
with the generalised inverse that sets aliased columns (in model order)
to zero: the G2 inverse of the SAS sweep operator, which gives the last
level of each effect the value 0. A combination \\\vl^{\top}\vbeta\\ is
*estimable* when \\\vl\\ lies in the row space of \\\mX\\; then
\\\vl^{\top}\widehat{\vbeta}\\ and \\\Var(\vl^{\top}\widehat{\vbeta}) =
\vl^{\top}\mC\vl\\ do not depend on the generalised inverse.
Non-estimable combinations are returned as `NA`.

**Least-squares means** use \\\vl\\ with 1 for the intercept and the
matching level, equal weights over the levels of the other factors of
each effect, and the means of the covariates (or the values of `at`).

**Type 3 tests** use the sum-to-zero (Sigma-restricted) coding of every
effect, in which effects nested in another sum to zero within it: the
test of an effect is the Wald test that its coefficients are zero. This
is the SAS Type 3 hypothesis whenever every cell is observed. **Type 1
tests** are sequential: after whitening with \\\mV^{-1/2}\\, the rows of
the triangular factor of the QR decomposition of \\\mX\\ that belong to
the effect.

For \\\mL\\ of rank \\Q\\, \\ F =
\frac{(\mL\widehat{\vbeta})^{\top}(\mL\mC\mL^{\top})^{-1}(\mL\widehat{\vbeta})}{Q}.
\\

## 5 Denominator degrees of freedom

- **Containment**: the rank contribution of the random effects that
  contain the fixed effect (all its variables, covariates included), the
  smallest one if several do; \\N - \mathrm{rank}\[\mX\\ \mZ\]\\ if none
  does.
- **Residual**: \\N - \mathrm{rank}\[\mX\\ \mZ\]\\.
- **Between-within**: for effects constant within subjects, the number
  of subjects minus the rank of those effects; for the others, \\N -
  \mathrm{rank}\[\mX\\ \mZ_s\]\\ with \\\mZ_s\\ the subject indicators.
- **Satterthwaite** (Satterthwaite 1946; Giesbrecht and Burns 1985):
  with \\\mathbf{A}\\ the asymptotic covariance of \\\widehat{\vtheta}\\
  and \\g_i = \partial(\vl^{\top}\mC\vl)/\partial\theta_i =
  -\vl^{\top}\mC\mX^{\top}\mV^{-1} \mV_i\mV^{-1}\mX\mC\vl\\, \\ \nu =
  \frac{2(\vl^{\top}\mC\vl)^2}{\vg^{\top}\mathbf{A}\vg}. \\ For \\Q \>
  1\\ rows, \\\mL\mC\mL^{\top}\\ is decomposed into \\Q\\ independent
  rows with \\\nu_m\\ each, and \\\nu = 2E/(E - Q)\\ with \\E = \sum_m
  \nu_m/(\nu_m - 2)\\ (Fai and Cornelius 1996).
- **Kenward-Roger** (Kenward and Roger 1997): the covariance of
  \\\widehat{\vbeta}\\ is inflated for the uncertainty in
  \\\widehat{\vtheta}\\, \\ \mPhi_A = \mC + 2\mC\Big\\\sum\_{i,j}
  W\_{ij}\big(\mQ\_{ij} - \mP_i\mC\mP_j -
  \tfrac{1}{4}\mR\_{ij}\big)\Big\\\mC, \\ with \\\mP_i =
  -\mX^{\top}\mV^{-1}\mV_i\mV^{-1}\mX\\, \\\mQ\_{ij} =
  \mX^{\top}\mV^{-1}\mV_i\mV^{-1}\mV_j\mV^{-1}\mX\\, \\\mR\_{ij} =
  \mX^{\top}\mV^{-1}(\partial^2\mV/\partial\theta_i\partial\theta_j)\mV^{-1}\mX\\
  and \\\mW\\ the inverse expected information; the F statistic is
  scaled and its degrees of freedom matched to the first two moments.

## 6 Inference spaces and prediction

Henderson’s mixed model equations give the best linear unbiased
predictions \\\widehat{\vu} = \mG\mZ^{\top}\mV^{-1}(\vy -
\mX\widehat{\vbeta})\\ and the covariance of the errors \\
\Var\begin{pmatrix}\widehat{\vbeta} - \vbeta\\ \widehat{\vu} -
\vu\end{pmatrix} = \begin{pmatrix}\mC & -\mC\mX^{\top}\mV^{-1}\mZ\mG\\
\cdot & \mG - \mG\mZ^{\top}\mP\mZ\mG\end{pmatrix}. \\ An estimate
\\\vl^{\top}\vbeta\\ is in the **broad** inference space (valid for the
population of regions, herds, ); adding \\\vk^{\top}\vu\\ (argument
`random` of
[`vlm_estimate()`](https://myaseen208.com/VetResearchLMM/reference/vlm_estimate.md))
restricts it to the observed levels, the **narrow** space (Example
2.5.4.1 of the book; McLean, Sanders and Stroup 1991).

## 7 Expected mean squares

A sum of squares is a quadratic form \\\vy^{\top}\mA\vy\\ of rank
\\DF\\. For random effects of design \\\mZ_k\\, \\ \E(MS) = \sigma^2 +
\sum_k \frac{\tr(\mZ_k^{\top}\mA\mZ_k)}{DF}\sigma_k^2 + Q(\text{fixed}),
\\ which with one observation deleted from Example 1.2.4 gives the
coefficients 9.7143 and 9.7222 of Table 1.3.2.3.
[`vlm_ems()`](https://myaseen208.com/VetResearchLMM/reference/vlm_ems.md)
builds the error term of each test as the combination of mean squares
with the same expectation under the null hypothesis, with Satterthwaite
degrees of freedom.

## 8 Fit statistics

With \\d\\ covariance parameters (plus \\P\\ for ML), \\N^\* = N - P\\
for REML (\\N\\ for ML) and \\s\\ subjects: \\ AIC = -2\ell + 2d, \qquad
AICC = -2\ell + \frac{2dN^\*}{N^\* - d - 1}, \qquad BIC = -2\ell + d\log
s, \\ smaller is better. SAS version 6, which the book used, printed the
“larger is better” forms \\\ell - d\\ and \\\ell - \tfrac{d}{2}\log
N^\*\\; both are given. The null model likelihood ratio statistic
compares the model with the one with independent errors only.

## 9 Notation

``` r

nt <-
  vlm_notation(
      format = c("table", "path", "tex")[1]
    )
knitr::kable(nt[, c("text", "meaning", "argument")])
```

| text | meaning | argument |
|:---|:---|:---|
| N | number of observations | data |
| P | rank of the fixed-effects design matrix | fixed |
| y | response (observations) | fixed |
| X | design matrix of the fixed effects (overparameterised: one column per level) | fixed |
| beta | fixed effects | fixed |
| Z | design matrix of the random effects | random |
| u | random effects | random |
| e | residual errors |  |
| G | covariance matrix of the random effects | random |
| R | covariance matrix of the residuals | repeated |
| V | covariance matrix of the observations: Z G Z’ + R |  |
| theta | covariance parameters (variance components, covariances, correlations) |  |
| V_i | derivative of V with respect to the i-th covariance parameter |  |
| P | V^-1 - V^-1 X (X’ V^-1 X)^- X’ V^-1 |  |
| C | (X’ V^-1 X)^-: covariance matrix of the fixed-effects solution |  |
| l | restricted and full log-likelihood | method |
| L | coefficients of an estimate or contrast of fixed effects | L |
| k | coefficients of random effects in a narrow-space estimate | random |
| nu | denominator degrees of freedom | ddfm |
| A | asymptotic covariance matrix of the covariance-parameter estimates |  |
| Phi_A | Kenward-Roger adjusted covariance matrix of the fixed effects | ddfm |
| sigma2 | residual variance |  |
| sigma2_k | variance of the k-th random effect | random |
| rho | correlation of the first-order autoregressive or spatial power structure | repeated |
| EMS | expected mean square | type |
| d | number of covariance parameters |  |
| s | number of subjects | repeated |

## 10 References

Fai, A. H.-T. and Cornelius, P. L. (1996). Approximate F-tests of
multiple degree of freedom hypotheses in generalized least squares
analyses of unbalanced split-plot experiments. *Journal of Statistical
Computation and Simulation*, 54, 363-378.

Giesbrecht, F. G. and Burns, J. C. (1985). Two-stage analysis based on a
mixed model. *Biometrics*, 41, 477-486.

Gilmour, A. R., Thompson, R. and Cullis, B. R. (1995). Average
information REML. *Biometrics*, 51, 1440-1450.

Harville, D. A. (1977). Maximum likelihood approaches to variance
component estimation. *Journal of the American Statistical Association*,
72, 320-338.

Kenward, M. G. and Roger, J. H. (1997). Small sample inference for fixed
effects from restricted maximum likelihood. *Biometrics*, 53, 983-997.

McLean, R. A., Sanders, W. L. and Stroup, W. W. (1991). A unified
approach to mixed linear models. *The American Statistician*, 45, 54-64.

Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block
information when block sizes are unequal. *Biometrika*, 58, 545-554.

Satterthwaite, F. E. (1946). An approximate distribution of estimates of
variance components. *Biometrics Bulletin*, 2, 110-114.
