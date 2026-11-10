#' Fit a linear mixed model
#'
#' @description
#' Fits the linear mixed model \eqn{\mathbf{y} = \mathbf{X}\boldsymbol{\beta} + \mathbf{Z}\mathbf{u} +
#' \mathbf{e}} by restricted maximum likelihood (REML), maximum likelihood (ML) or the method of moments on Type 3
#' mean squares, and gives the results of SAS PROC MIXED: covariance parameter estimates with standard errors, the
#' solution for the fixed effects in the overparameterised coding, Type 3 (or Type 1) tests with containment,
#' residual, between-within, Satterthwaite or Kenward-Roger denominator degrees of freedom, and fit statistics. It is
#' the engine behind every analysis of the book of Duchateau, Janssen and Rowlands (1998).
#'
#' @details
#' With \eqn{\mathbf{u} \sim N(\mathbf{0}, \mathbf{G})} and \eqn{\mathbf{e} \sim N(\mathbf{0}, \mathbf{R})}
#' independent, \eqn{\mathbf{V} = \mathbf{Z}\mathbf{G}\mathbf{Z}^{\top} + \mathbf{R}} depends on the covariance
#' parameters \eqn{\boldsymbol{\theta}}. With \eqn{P = \mathrm{rank}(\mathbf{X})} and \eqn{N} observations, the
#' REML log-likelihood is
#' \deqn{\ell_R(\boldsymbol{\theta}) = -\frac{1}{2}\left\{(N - P)\log(2\pi) + \log|\mathbf{V}| +
#' \log|\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{X}| + \mathbf{r}^{\top}\mathbf{V}^{-1}\mathbf{r}\right\},}
#' with \eqn{\mathbf{r} = \mathbf{y} - \mathbf{X}\widehat{\boldsymbol{\beta}}}; the ML log-likelihood drops the
#' third term and uses \eqn{N} in the first. It is maximised by Newton steps with the average-information matrix
#' \eqn{\frac{1}{2}\mathbf{y}^{\top}\mathbf{P}\mathbf{V}_i\mathbf{P}\mathbf{V}_j\mathbf{P}\mathbf{y}}, where
#' \eqn{\mathbf{V}_i = \partial\mathbf{V}/\partial\theta_i} and \eqn{\mathbf{P} = \mathbf{V}^{-1} -
#' \mathbf{V}^{-1}\mathbf{X}(\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{X})^{-}\mathbf{X}^{\top}\mathbf{V}^{-1}},
#' with step halving and variances kept non-negative (unless \code{bound = FALSE}). The fixed effects are the
#' generalised least-squares solution
#' \deqn{\widehat{\boldsymbol{\beta}} = (\mathbf{X}^{\top}\widehat{\mathbf{V}}^{-1}\mathbf{X})^{-}
#' \mathbf{X}^{\top}\widehat{\mathbf{V}}^{-1}\mathbf{y}}
#' in the overparameterised coding (one column per level), with the generalised inverse that sets aliased levels to
#' zero, as SAS does. Standard errors of the covariance parameters come from the observed information.
#'
#' Type 3 tests use the sum-to-zero coding of each effect (the SAS Type 3 hypothesis when every cell is observed).
#' The denominator degrees of freedom (\code{ddfm}) are: \code{"contain"}, the rank contribution of the random
#' effects that contain the fixed effect, or \eqn{N - \mathrm{rank}[\mathbf{X}\ \mathbf{Z}]} if none does;
#' \code{"residual"}, \eqn{N - \mathrm{rank}[\mathbf{X}\ \mathbf{Z}]}; \code{"betwithin"}, the between- and
#' within-subject parts of the residual degrees of freedom; \code{"satterth"},
#' \eqn{\nu = 2\{\mathbf{l}^{\top}\mathbf{C}\mathbf{l}\}^2 / \mathbf{g}^{\top}\mathbf{A}\mathbf{g}}, with
#' \eqn{\mathbf{g}} the gradient of \eqn{\mathbf{l}^{\top}\mathbf{C}\mathbf{l}} in \eqn{\boldsymbol{\theta}} and
#' \eqn{\mathbf{A}} the asymptotic covariance of \eqn{\widehat{\boldsymbol{\theta}}} (Giesbrecht and Burns 1985;
#' Fai and Cornelius 1996 for several rows); \code{"kr"}, the adjusted covariance and scaled F of Kenward
#' and Roger (1997). \code{"default"} chooses as SAS: containment with random effects, between-within with a
#' residual structure only, residual otherwise.
#'
#' Method \code{"Type3"} (random variance components only) equates the Type 3 mean squares of the random effects to
#' their expectations (\code{\link{vlm_ems}()}); negative solutions are set to zero.
#'
#' @param fixed two-sided formula of the response and the fixed effects, such as \code{Pcv ~ Drug * dose}; terms
#'   are kept in the order written, as in a SAS MODEL statement (\code{a/b} gives \code{a + a:b}).
#' @param data a data frame (or \code{data.table}) with the variables.
#' @param random \code{NULL}, a one-sided formula of random variance components (each term one component, such as
#'   \code{~ Region + Region:Drug}), a \code{\link{vlm_random}()} specification, or a list of these.
#' @param repeated \code{NULL} or a \code{\link{vlm_repeated}()} specification of the residual covariance.
#' @param method \code{"REML"} (default), \code{"ML"} or \code{"Type3"}.
#' @param ddfm denominator degrees of freedom: \code{"default"}, \code{"contain"}, \code{"residual"},
#'   \code{"betwithin"}, \code{"satterth"} or \code{"kr"}, the DDFM= keywords of SAS.
#' @param type type of the tests of fixed effects: 3 (default) or 1 (sequential).
#' @param class optional character vector of numeric variables to treat as classification variables (factors),
#'   like the SAS CLASS statement. Non-numeric variables and the variables of random effects and subjects are
#'   always classification variables.
#' @param bound logical; keep variance estimates non-negative (default \code{TRUE}; \code{FALSE} is the SAS
#'   NOBOUND option).
#' @param control list with \code{maxit} (default 200), \code{tol} (default \eqn{10^{-12}}) and \code{start}
#'   (starting values of the covariance parameters, in the order of the covariance table).
#' @return A list of class \code{c("vlm_fit", "vlm_result", "list")} with \code{covariance} (covariance
#'   parameter estimates, standard errors and Wald Z tests), \code{fixed} (solution for the fixed effects),
#'   \code{tests} (tests of the fixed effects), \code{fit} (fit statistics) and \code{dimensions}; the call is kept
#'   in \code{attr(, "call")}. Further analyses of the fit: \code{\link{vlm_lsmeans}()},
#'   \code{\link{vlm_estimate}()}, \code{\link{vlm_contrast}()}, \code{\link{vlm_blup}()},
#'   \code{\link{vlm_compare}()} and \code{\link{vlm_interpret}()}.
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi.
#'
#' Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block information when block sizes are unequal.
#' \emph{Biometrika}, 58, 545-554.
#'
#' Kenward, M. G. and Roger, J. H. (1997). Small sample inference for fixed effects from restricted maximum
#' likelihood. \emph{Biometrics}, 53, 983-997.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_random}}, \code{\link{vlm_lsmeans}}, \code{\link{vlm_estimate}},
#'   \code{\link{vlm_ems}}
#' @family VetResearchLMM models
#' @examples
#' # Example 2.5.1.1: PROC MIXED; CLASS drug dose region; MODEL pcv = drug dose drug*dose / SOLUTION;
#' # RANDOM region drug*region;
#' fm <-
#'   vlm_fit(
#'       fixed    = Pcv ~ Drug + dose + Drug:dose
#'     , data     = ex125
#'     , random   = ~ Region + Region:Drug
#'     , repeated = NULL
#'     , method   = "REML"
#'     , ddfm     = "satterth"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' fm
#' fm$covariance
#' fm$fixed
#'
#' # Example 3.3, Model 2: first-order autoregressive residuals within an animal
#' ar <-
#'   vlm_fit(
#'       fixed    = PCV ~ breed + breed:time
#'     , data     = ex33
#'     , random   = NULL
#'     , repeated = vlm_repeated(
#'           type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
#'         , subject = ~ animal_id:breed
#'         , order   = ~ time
#'         )
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' ar$covariance
#' ar$fit
#' @export
vlm_fit <- function(fixed, data, random = NULL, repeated = NULL, method = c("REML", "ML", "Type3"),
                    ddfm = c("default", "contain", "residual", "betwithin", "satterth",
                             "kr"),
                    type = 3, class = NULL, bound = TRUE, control = list()) {
  UseMethod("vlm_fit")
}

#' @rdname vlm_fit
#' @export
vlm_fit.default <- function(fixed, data, random = NULL, repeated = NULL, method = c("REML", "ML", "Type3"),
                            ddfm = c("default", "contain", "residual", "betwithin", "satterth",
                                     "kr"),
                            type = 3, class = NULL, bound = TRUE, control = list()) {
  fn <- "vlm_fit"
  .vlm_check_data(data, fn)
  method <- match.arg(method)
  ddfm <- match.arg(ddfm)
  type <- .vlm_check_number(type, "type", fn, min = 1, max = 3, integer = TRUE)
  if (type == 2L) .vlm_stop(fn, "`type` must be 1 or 3.")
  .vlm_check_flag(bound, "bound", fn)
  ctrl <- utils::modifyList(list(maxit = 200L, tol = 1e-12, start = NULL), control)
  spec <- .vlm_spec(fixed, data, random, repeated, class, fn)
  if (ddfm == "default") {
    ddfm <- if (length(spec$random)) "contain" else if (!is.null(repeated)) "betwithin" else "residual"
  }
  st <- .vlm_struct(spec)
  XS <- spec$Xo[, spec$So, drop = FALSE]
  reml <- method != "ML"
  if (method == "Type3") {
    if (!is.null(repeated) || any(vapply(spec$random, function(r) !is.null(r$subject), logical(1)))) {
      .vlm_stop(fn, "method \"Type3\" needs random variance components given as a formula, and no `repeated`.")
    }
    th <- .vlm_type3_theta(fixed, data, random, class)
    core <- .vlm_core(th, st, XS, spec$y, TRUE)
    if (!core$ok) .vlm_stop(fn, "V is not positive definite at the Type 3 estimates.")
    opt <- list(theta = th, core = core, converged = TRUE, iter = 0L, message = "method of moments",
                lower = st$par$lower, upper = st$par$upper)
  } else {
    opt <- .vlm_optimise(st, XS, spec$y, reml, ctrl$start, bound, ctrl$maxit, ctrl$tol)
    if (!opt$core$ok) .vlm_stop(fn, "the covariance matrix is not positive definite; check the model.")
    if (!opt$converged) .vlm_warn(fn, "the estimation did not converge (", opt$message, ").")
  }
  th <- opt$theta
  active <- !(th <= opt$lower + 1e-8 & is.finite(opt$lower) & st$par$kind == "var")
  eng <- new.env(parent = emptyenv())
  eng$spec <- spec
  eng$st <- st
  eng$theta <- th
  eng$reml <- reml
  eng$method <- method
  eng$ddfm <- ddfm
  eng$type <- type
  eng$core <- opt$core
  eng$active <- active
  eng$dV <- .vlm_dV(th, st)
  eng$d2V <- .vlm_d2V(th, st)
  Hobs <- .vlm_hessian(th, st, XS, spec$y, reml, active)
  eng$A_obs <- .vlm_ginv_sub(Hobs, active)
  dd <- .vlm_derivs(th, st, opt$core, reml, "expected")
  eng$A_exp <- .vlm_ginv_sub(dd$expected, active)
  eng$opt <- opt
  .vlm_df_setup(eng)

  res <- list(
      covariance = .vlm_cov_table(eng)
    , fixed      = .vlm_solution(eng)
    , tests      = .vlm_tests(eng, type)
    , fit        = .vlm_fitstats(eng)
    , dimensions = .vlm_dimensions(eng)
    )
  out <- .vlm_result(res, "fit", label = sprintf("%s ~ %s", spec$yname, {
                       lb <- spec$labels[spec$labels != "(Intercept)"]
                       if (length(lb)) paste(lb, collapse = " + ") else "1"
                     }), call = match.call(),
                     meta = list(method = method, ddfm = ddfm, converged = opt$converged, iterations = opt$iter))
  attr(out, "engine") <- eng
  out
}

#-------------------------------------------------------------------------------------------------------------------
# tables of a fit
#-------------------------------------------------------------------------------------------------------------------

.vlm_cov_table <- function(eng) {
  pt <- eng$st$par
  se <- sqrt(pmax(diag(eng$A_obs), 0))
  se[!eng$active] <- NA_real_
  z <- eng$theta / se
  p <- ifelse(pt$kind == "var", stats::pnorm(z, lower.tail = FALSE), 2 * stats::pnorm(abs(z), lower.tail = FALSE))
  data.table::data.table(parameter = pt$name, subject = pt$subject, estimate = eng$theta, se = se, z = z, p = p)
}

# the levels of every overparameterised column, as text
.vlm_col_levels <- function(spec) {
  unlist(lapply(spec$design, function(d) {
    if (!nrow(d$levels)) return(rep("", ncol(d$X)))
    do.call(paste, d$levels)
  }))
}

.vlm_solution <- function(eng) {
  sp <- eng$spec
  co <- .vlm_coords(eng, "o")
  p <- ncol(sp$Xo)
  b <- numeric(p)
  b[sp$So] <- co$bS
  tab <- data.table::data.table(effect = sp$labels[sp$assign_o], level = .vlm_col_levels(sp), estimate = b,
                                se = NA_real_, df = NA_real_, t = NA_real_, p = NA_real_)
  if (length(sp$So)) {
    L <- diag(p)[sp$So, , drop = FALSE]
    r <- .vlm_est_rows(eng, L, "o", .vlm_row_df(eng, L))
    data.table::set(tab, sp$So, c("se", "df", "t", "p"), r[, c("se", "df", "t", "p")])
  }
  tab
}

.vlm_tests <- function(eng, type = 3L) {
  sp <- eng$spec
  eff <- which(sp$labels != "(Intercept)")
  edf <- .vlm_effect_df(eng)
  if (type == 3L) {
    co <- .vlm_coords(eng, "s")
    rows <- lapply(eff, function(e) {
      j <- which(sp$assign_s[co$S] == e)
      if (!length(j)) return(NULL)
      L <- matrix(0, length(j), co$p)
      L[cbind(seq_along(j), co$S[j])] <- 1
      w <- .vlm_wald(eng, L, "s", if (is.na(edf[e])) NULL else edf[e])
      data.table::data.table(effect = sp$labels[e], num_df = w$ndf, den_df = w$ddf, F = w$F, p = w$p)
    })
  } else {
    co <- .vlm_coords(eng, "o")
    Lc <- t(chol(eng$core$V))
    Xw <- forwardsolve(Lc, co$XS)
    R <- qr.R(qr(Xw, LAPACK = FALSE))
    rows <- lapply(eff, function(e) {
      j <- which(sp$assign_o[co$S] == e)
      if (!length(j)) return(NULL)
      L <- matrix(0, length(j), co$p)
      L[, co$S] <- R[j, , drop = FALSE]
      w <- .vlm_wald(eng, L, "o", if (is.na(edf[e])) NULL else edf[e])
      data.table::data.table(effect = sp$labels[e], num_df = w$ndf, den_df = w$ddf, F = w$F, p = w$p)
    })
  }
  out <- data.table::rbindlist(rows)
  if (!nrow(out)) out <- data.table::data.table(effect = character(), num_df = integer(), den_df = numeric(),
                                                F = numeric(), p = numeric())
  out
}

.vlm_fitstats <- function(eng) {
  sp <- eng$spec
  ll <- eng$core$ll
  d <- length(eng$theta) - sum(!eng$active)
  pX <- length(sp$So)
  n <- sp$n
  nstar <- if (eng$reml) n - pX else n
  k <- if (eng$reml) d else d + pX
  sub <- sp$residual$subject
  if (is.null(sub)) for (r in sp$random) if (!is.null(r$subject)) { sub <- r$subject; break }
  s <- if (is.null(sub)) nstar else nlevels(sub)
  # likelihood of the model with independent errors only (the null model of SAS)
  null_ll <- NA_real_
  if (length(sp$random) || sp$residual$type != "vc") {
    XS <- sp$Xo[, sp$So, drop = FALSE]
    rss <- sum(qr.resid(qr(XS), sp$y)^2)
    s2 <- rss / nstar
    st0 <- list(lin = list(list(i = 1L, K = diag(n))), nl = NULL, n = n, k = 1L)
    null_ll <- .vlm_core(s2, st0, XS, sp$y, eng$reml)$ll
  }
  lab <- if (eng$reml) "Res " else ""
  data.table::data.table(
      statistic = c(paste0("-2 ", lab, "Log Likelihood"), "AIC (smaller is better)", "AICC (smaller is better)",
                    "BIC (smaller is better)", paste0(lab, "Log Likelihood"), "AIC (SAS 6, larger is better)",
                    "SBC (SAS 6, larger is better)", "Null model LRT chi-square", "Null model LRT df",
                    "Null model LRT p-value")
    , value     = c(-2 * ll, -2 * ll + 2 * k, -2 * ll + 2 * k * nstar / max(nstar - k - 1, 1), -2 * ll + k * log(s),
                    ll, ll - k, ll - k / 2 * log(nstar), 2 * (ll - null_ll), d - 1,
                    stats::pchisq(2 * (ll - null_ll), max(d - 1, 1), lower.tail = FALSE))
    )
}

.vlm_dimensions <- function(eng) {
  sp <- eng$spec
  sub <- sp$residual$subject
  if (is.null(sub)) for (r in sp$random) if (!is.null(r$subject)) { sub <- r$subject; break }
  zg <- .vlm_ZG(sp, eng$theta, eng$st)
  data.table::data.table(
      item  = c("Covariance parameters", "Columns in X", "Rank of X", "Columns in Z", "Subjects", "Observations",
                "Iterations")
    , value = c(length(eng$theta), ncol(sp$Xo), length(sp$So), if (is.null(zg)) 0L else ncol(zg$Z),
                if (is.null(sub)) 1L else nlevels(sub), sp$n, eng$opt$iter)
    )
}

# engine of a fit (with a clear error for other objects)
.vlm_engine <- function(x, fn) {
  if (!inherits(x, "vlm_fit")) .vlm_stop(fn, "`fit` must be a result of vlm_fit().")
  eng <- attr(x, "engine")
  if (!is.environment(eng)) .vlm_stop(fn, "`fit` has lost its engine; refit the model with vlm_fit().")
  eng
}
