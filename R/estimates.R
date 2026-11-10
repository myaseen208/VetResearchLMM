#-------------------------------------------------------------------------------------------------------------------
# Least-squares means, ESTIMATE and CONTRAST statements, and best linear unbiased predictions
#-------------------------------------------------------------------------------------------------------------------

# a coefficient row in the overparameterised coding from a numeric vector or a SAS-like list term -> coefficients
.vlm_L_row <- function(eng, x, fn, what = "L") {
  sp <- eng$spec
  p <- ncol(sp$Xo)
  if (is.numeric(x) && is.null(names(x))) {
    if (length(x) != p) .vlm_stop(fn, "a numeric row of `", what, "` must have ", p, " coefficients (one per column ",
                                  "of the fixed-effects solution).")
    return(x)
  }
  if (is.numeric(x)) x <- as.list(x)
  if (!is.list(x) || is.null(names(x))) {
    .vlm_stop(fn, "each row of `", what, "` must be a numeric vector or a named list such as ",
              "list(Drug = c(-1, 1), \"Drug:dose\" = c(-0.5, -0.5, 0.5, 0.5)).")
  }
  out <- numeric(p)
  for (nm in names(x)) {
    e <- .vlm_match_effect(sp, nm)
    if (is.na(e)) .vlm_stop(fn, "no fixed effect \"", nm, "\"; effects: ", paste(sp$labels, collapse = ", "), ".")
    cols <- which(sp$assign_o == e)
    v <- as.numeric(x[[nm]])
    if (length(v) > length(cols)) .vlm_stop(fn, "effect \"", nm, "\" has ", length(cols), " levels but ", length(v),
                                            " coefficients were given.")
    out[cols[seq_along(v)]] <- v
  }
  out
}

# the index of a fixed effect from its name: "(Intercept)", "intercept", "Drug:dose" or "dose*Drug"
.vlm_match_effect <- function(sp, nm) {
  if (tolower(nm) %in% c("(intercept)", "intercept")) return(match("(Intercept)", sp$labels))
  vars <- .vlm_term_vars(gsub("*", ":", nm, fixed = TRUE))
  hit <- which(vapply(sp$effvars, function(v) length(v) == length(vars) && all(vars %in% v), logical(1)))
  if (length(hit)) hit[1L] else NA_integer_
}

# a matrix of rows from a list of rows (or a single row, or a matrix)
.vlm_L_matrix <- function(eng, x, fn, what) {
  if (is.matrix(x)) {
    if (ncol(x) != ncol(eng$spec$Xo)) .vlm_stop(fn, "a matrix in `", what, "` must have ", ncol(eng$spec$Xo),
                                                " columns.")
    return(x)
  }
  rows <- if (is.list(x) && !is.null(names(x))) list(x) else if (is.list(x)) x else list(x)
  do.call(rbind, lapply(rows, .vlm_L_row, eng = eng, fn = fn, what = what))
}

.vlm_ci <- function(tab, level) {
  q <- stats::qt(1 - (1 - level) / 2, tab$df)
  tab[, `:=`(lower = estimate - q * se, upper = estimate + q * se)]
  tab
}

#' Least-squares means
#'
#' @description
#' Least-squares means (estimated marginal means) of a classification effect of a fitted model, with their standard
#' errors, degrees of freedom and confidence limits, and optionally all pairwise differences with a multiple
#' comparison adjustment: the LSMEANS statement of SAS PROC MIXED.
#'
#' @details
#' The least-squares mean of a level combination is \eqn{\mathbf{l}^{\top}\widehat{\boldsymbol{\beta}}}, where
#' \eqn{\mathbf{l}} has 1 for the intercept and the matching levels, equal weights \eqn{1/m} over the \eqn{m}
#' levels (or cells) of the other factors of each effect, and the mean of each covariate (or the value in
#' \code{at}) for covariate columns. Its variance is \eqn{\mathbf{l}^{\top}(\mathbf{X}^{\top}
#' \widehat{\mathbf{V}}^{-1}\mathbf{X})^{-}\mathbf{l}}, the broad-inference-space variance. Non-estimable means are
#' returned as \code{NA}. With \code{adjust = "tukey"}, p-values of the differences come from the studentised range
#' distribution (Tukey-Kramer), \eqn{P(Q_{k,\nu} > \sqrt{2}|t|)}, and the confidence limits use
#' \eqn{q_{k,\nu}(1-\alpha)/\sqrt{2}}.
#'
#' @param fit a result of \code{\link{vlm_fit}()}.
#' @param specs the effect: a character string such as \code{"Drug:dose"} or a one-sided formula such as
#'   \code{~ Drug:dose} (all its variables must be classification variables of the fixed part).
#' @param at optional named list of covariate values (default: the means of the covariates).
#' @param diff logical; also give all pairwise differences (default \code{FALSE}).
#' @param adjust multiple comparison adjustment of the differences: \code{"none"}, \code{"tukey"},
#'   \code{"bonferroni"} or \code{"sidak"}.
#' @param level confidence level (default 0.95).
#' @return A list of class \code{c("vlm_lsmeans", "vlm_result", "list")} with \code{lsmeans}, \code{diffs}
#'   (\code{NULL} unless \code{diff = TRUE}) and \code{L} (the coefficient rows).
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Sections 2.5.2 and
#' 3.3.
#'
#' Searle, S. R., Speed, F. M. and Milliken, G. A. (1980). Population marginal means in the linear model: an
#' alternative to least squares means. \emph{The American Statistician}, 34, 216-221.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}, \code{\link{vlm_estimate}}
#' @family VetResearchLMM inference
#' @examples
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
#' # Example 2.5.2.1: LSMEANS drug*dose
#' lm1 <-
#'   vlm_lsmeans(
#'       fit    = fm
#'     , specs  = ~ Drug:dose
#'     , at     = NULL
#'     , diff   = TRUE
#'     , adjust = "tukey"
#'     , level  = 0.95
#'     )
#' lm1
#' @export
vlm_lsmeans <- function(fit, specs, at = NULL, diff = FALSE, adjust = c("none", "tukey", "bonferroni", "sidak"),
                        level = 0.95) {
  UseMethod("vlm_lsmeans")
}

#' @rdname vlm_lsmeans
#' @export
vlm_lsmeans.default <- function(fit, specs, at = NULL, diff = FALSE,
                                adjust = c("none", "tukey", "bonferroni", "sidak"), level = 0.95) {
  fn <- "vlm_lsmeans"
  eng <- .vlm_engine(fit, fn)
  adjust <- match.arg(adjust)
  .vlm_check_flag(diff, "diff", fn)
  level <- .vlm_check_number(level, "level", fn, min = 0.5, max = 0.9999)
  sp <- eng$spec
  vars <- if (inherits(specs, "formula")) all.vars(specs) else if (is.character(specs) && length(specs) == 1L) {
    .vlm_term_vars(gsub("*", ":", specs, fixed = TRUE))
  } else .vlm_stop(fn, "`specs` must be a character string or a one-sided formula.")
  fixed_vars <- unique(unlist(sp$effvars))
  bad <- vars[!(vars %in% fixed_vars) | !vapply(vars, function(v) is.factor(sp$vals[[v]]), logical(1))]
  if (length(bad)) .vlm_stop(fn, "not classification variables of the fixed part: ", paste(bad, collapse = ", "), ".")
  # covariate values
  covs <- setdiff(fixed_vars, names(Filter(is.factor, sp$vals[fixed_vars])))
  cval <- lapply(stats::setNames(covs, covs), function(v) mean(as.numeric(sp$vals[[v]])))
  if (!is.null(at)) {
    if (!is.list(at) || is.null(names(at))) .vlm_stop(fn, "`at` must be a named list such as list(PCV1 = 18).")
    for (nm in names(at)) {
      if (!nm %in% covs) .vlm_stop(fn, "`at`: \"", nm, "\" is not a covariate of the fixed part.")
      cval[[nm]] <- as.numeric(at[[nm]])[1L]
    }
  }
  # level combinations: the observed cells of the matching effect, or all combinations
  e <- which(vapply(sp$effvars, function(v) length(v) == length(vars) && all(vars %in% v), logical(1)))
  cells <- if (length(e)) data.table::copy(sp$design[[e[1L]]]$levels) else {
    data.table::as.data.table(expand.grid(lapply(stats::setNames(vars, vars), function(v) levels(sp$vals[[v]])),
                                          stringsAsFactors = FALSE))
  }
  data.table::setcolorder(cells, intersect(sp$design[[if (length(e)) e[1L] else 1L]]$class, vars))
  vars <- names(cells)
  L <- t(vapply(seq_len(nrow(cells)), function(i) .vlm_lsm_row(sp, cells[i], vars, cval), numeric(ncol(sp$Xo))))
  if (nrow(cells) == 1L) L <- matrix(L, nrow = 1L)
  est <- .vlm_estimable(eng, L)
  tab <- data.table::data.table(estimate = rep(NA_real_, nrow(L)), se = NA_real_, df = NA_real_, t = NA_real_,
                                p = NA_real_)
  if (any(est)) {
    ddf <- if (length(e) && eng$ddfm %in% c("contain", "betwithin", "residual")) {
      rep(.vlm_effect_df(eng)[e[1L]], sum(est))
    } else .vlm_row_df(eng, L[est, , drop = FALSE])
    r <- .vlm_est_rows(eng, L[est, , drop = FALSE], "o", ddf)
    data.table::set(tab, which(est), names(r), r)
  }
  tab <- cbind(cells, .vlm_ci(tab, level))
  dif <- NULL
  if (diff && nrow(L) > 1L) {
    pr <- utils::combn(nrow(L), 2L)
    Ld <- t(apply(pr, 2L, function(ij) L[ij[1L], ] - L[ij[2L], ]))
    ok <- est[pr[1L, ]] & est[pr[2L, ]]
    dt <- data.table::data.table(estimate = rep(NA_real_, ncol(pr)), se = NA_real_, df = NA_real_, t = NA_real_,
                                 p = NA_real_)
    if (any(ok)) {
      ddf <- if (length(e) && eng$ddfm %in% c("contain", "betwithin", "residual")) {
        rep(.vlm_effect_df(eng)[e[1L]], sum(ok))
      } else .vlm_row_df(eng, Ld[ok, , drop = FALSE])
      r <- .vlm_est_rows(eng, Ld[ok, , drop = FALSE], "o", ddf)
      data.table::set(dt, which(ok), names(r), r)
    }
    lab <- do.call(paste, cells)
    k <- nrow(L)
    m <- ncol(pr)
    q <- switch(adjust
      , none       = stats::qt(1 - (1 - level) / 2, dt$df)
      , tukey      = stats::qtukey(level, k, dt$df) / sqrt(2)
      , bonferroni = stats::qt(1 - (1 - level) / (2 * m), dt$df)
      , sidak      = stats::qt(1 - (1 - level^(1 / m)) / 2, dt$df)
      )
    padj <- switch(adjust
      , none       = dt$p
      , tukey      = stats::ptukey(sqrt(2) * abs(dt$t), k, dt$df, lower.tail = FALSE)
      , bonferroni = pmin(1, dt$p * m)
      , sidak      = 1 - (1 - dt$p)^m
      )
    dif <- data.table::data.table(level_1 = lab[pr[1L, ]], level_2 = lab[pr[2L, ]], dt, p_adjusted = padj,
                                  lower = dt$estimate - q * dt$se, upper = dt$estimate + q * dt$se)
  }
  out <- list(lsmeans = tab, diffs = dif, L = L)
  .vlm_result(out, "lsmeans", label = sprintf("least-squares means of %s", paste(vars, collapse = ":")),
              call = match.call(), meta = list(adjust = adjust, level = level, ddfm = eng$ddfm))
}

# the LSMEANS coefficient row of one level combination
.vlm_lsm_row <- function(sp, cell, vars, cval) {
  out <- numeric(ncol(sp$Xo))
  for (e in seq_along(sp$labels)) {
    d <- sp$design[[e]]
    cols <- which(sp$assign_o == e)
    covf <- if (length(d$cov)) prod(vapply(d$cov, function(v) cval[[v]], 1)) else 1
    if (!length(d$class)) { out[cols] <- covf; next }
    common <- intersect(d$class, vars)
    match_rows <- if (length(common)) {
      Reduce(`&`, lapply(common, function(v) d$levels[[v]] == cell[[v]]))
    } else rep(TRUE, nrow(d$levels))
    if (any(match_rows)) out[cols[match_rows]] <- covf / sum(match_rows)
  }
  out
}

#' Estimates and contrasts of fixed (and random) effects
#'
#' @description
#' \code{vlm_estimate()} gives estimates of linear combinations \eqn{\mathbf{l}^{\top}\boldsymbol{\beta}} (the
#' ESTIMATE statement of SAS PROC MIXED), optionally including random effects \eqn{\mathbf{k}^{\top}\mathbf{u}}
#' (the narrow or intermediate inference space). \code{vlm_contrast()} gives F tests of sets of linear combinations
#' \eqn{\mathbf{L}\boldsymbol{\beta} = \mathbf{0}} (the CONTRAST statement).
#'
#' @details
#' Coefficients are given per effect as in SAS, in the order of the levels in the solution table
#' (\code{fit$fixed}); missing trailing coefficients are zero. The variance of an estimate is
#' \eqn{\mathbf{l}^{\top}\mathbf{C}_{11}\mathbf{l} + 2\mathbf{l}^{\top}\mathbf{C}_{12}\mathbf{k} +
#' \mathbf{k}^{\top}\mathbf{C}_{22}\mathbf{k}}, where \eqn{\mathbf{C}_{11} = (\mathbf{X}^{\top}\mathbf{V}^{-1}
#' \mathbf{X})^{-}}, \eqn{\mathbf{C}_{12} = -\mathbf{C}_{11}\mathbf{X}^{\top}\mathbf{V}^{-1}\mathbf{Z}\mathbf{G}}
#' and \eqn{\mathbf{C}_{22} = \mathbf{G} - \mathbf{G}\mathbf{Z}^{\top}\mathbf{P}\mathbf{Z}\mathbf{G}} (Henderson's
#' mixed model equations). The F statistic of a contrast is
#' \deqn{F = \frac{(\mathbf{L}\widehat{\boldsymbol{\beta}})^{\top}(\mathbf{L}\mathbf{C}_{11}\mathbf{L}^{\top})^{-1}
#' (\mathbf{L}\widehat{\boldsymbol{\beta}})}{\mathrm{rank}(\mathbf{L})},}
#' with the denominator degrees of freedom of the fit. Rows that are not estimable give \code{NA}.
#'
#' @param fit a result of \code{\link{vlm_fit}()}.
#' @param L for \code{vlm_estimate()}: a named list of estimates, each a named list of effect coefficients (such as
#'   \code{list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))}) or a numeric vector over all columns of
#'   the solution. For \code{vlm_contrast()}: a named list of contrasts, each one such row or a list of rows.
#' @param random optional named list (names as in \code{L}) of random-effect coefficients for the narrow inference
#'   space: each a named list of random effects (as in the \code{effect} column of \code{\link{vlm_blup}()}) with
#'   coefficients over their levels.
#' @param level confidence level (default 0.95).
#' @return A list of class \code{c("vlm_estimate", "vlm_result", "list")} with \code{estimates} (label, estimate,
#'   standard error, df, t, p, confidence limits and inference space) and \code{L}; or of class
#'   \code{c("vlm_contrast", "vlm_result", "list")} with \code{contrasts} (label, numerator and denominator df,
#'   F and p).
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Sections 2.5 and 2.6.
#'
#' McLean, R. A., Sanders, W. L. and Stroup, W. W. (1991). A unified approach to mixed linear models. \emph{The
#' American Statistician}, 45, 54-64.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_lsmeans}}, \code{\link{vlm_fit}}
#' @family VetResearchLMM inference
#' @examples
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
#' # Example 2.5.3.1: ESTIMATE statements (levels: Drug BERENIL samorin, dose h l)
#' es <-
#'   vlm_estimate(
#'       fit    = fm
#'     , L      = list(
#'           "drug dif"     = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
#'         , "Samorin mean" = list(Intercept = 1, Drug = c(0, 1),
#'                                 dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))
#'         , "Samorin HvsL" = list(dose = c(1, -1), "Drug:dose" = c(0, 0, 1, -1))
#'         , "Samorin high" = list(Intercept = 1, Drug = c(0, 1),
#'                                 dose = c(1, 0), "Drug:dose" = c(0, 0, 1, 0))
#'         )
#'     , random = NULL
#'     , level  = 0.95
#'     )
#' es
#'
#' # Example 2.6.1: CONTRAST statements
#' ct <-
#'   vlm_contrast(
#'       fit = fm
#'     , L   = list(
#'           "drug dif" = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))
#'         , "all"      = list(
#'               list(Drug = c(1, -1), "Drug:dose" = c(0.5, 0.5, -0.5, -0.5))
#'             , list(dose = c(1, -1), "Drug:dose" = c(0.5, -0.5, 0.5, -0.5))
#'             , list("Drug:dose" = c(0.5, -0.5, -0.5, 0.5))
#'             )
#'         )
#'     )
#' ct
#' @name vlm_estimate
#' @export
vlm_estimate <- function(fit, L, random = NULL, level = 0.95) UseMethod("vlm_estimate")

#' @rdname vlm_estimate
#' @export
vlm_estimate.default <- function(fit, L, random = NULL, level = 0.95) {
  fn <- "vlm_estimate"
  eng <- .vlm_engine(fit, fn)
  level <- .vlm_check_number(level, "level", fn, min = 0.5, max = 0.9999)
  if (!is.list(L) || is.null(names(L)) || any(!nzchar(names(L)))) {
    .vlm_stop(fn, "`L` must be a named list of estimates.")
  }
  if (!is.null(random) && (!is.list(random) || is.null(names(random)) || !all(names(random) %in% names(L)))) {
    .vlm_stop(fn, "`random` must be NULL or a named list whose names are names of `L`.")
  }
  Lm <- do.call(rbind, lapply(L, .vlm_L_row, eng = eng, fn = fn, what = "L"))
  if (length(L) == 1L) Lm <- matrix(Lm, nrow = 1L)
  rownames(Lm) <- names(L)
  est <- .vlm_estimable(eng, Lm)
  tab <- data.table::data.table(label = names(L), estimate = NA_real_, se = NA_real_, df = NA_real_, t = NA_real_,
                                p = NA_real_)
  if (any(est)) {
    r <- .vlm_est_rows(eng, Lm[est, , drop = FALSE], "o", .vlm_row_df(eng, Lm[est, , drop = FALSE]))
    data.table::set(tab, which(est), names(r), r)
  }
  space <- rep(if (length(eng$spec$random) || eng$spec$residual$type != "vc") "broad" else "fixed", length(L))
  if (!is.null(random)) {
    for (nm in names(random)) {
      i <- match(nm, names(L))
      if (!est[i]) next
      k <- .vlm_K_row(eng, random[[nm]], fn)
      r <- .vlm_narrow(eng, Lm[i, ], k)
      data.table::set(tab, i, c("estimate", "se", "df", "t", "p"), r)
      space[i] <- "narrow"
    }
  }
  tab <- .vlm_ci(tab, level)
  tab[, space := space]
  .vlm_result(list(estimates = tab, L = Lm), "estimate", label = "estimates", call = match.call(),
              meta = list(level = level, ddfm = eng$ddfm))
}

#' @rdname vlm_estimate
#' @export
vlm_contrast <- function(fit, L) UseMethod("vlm_contrast")

#' @rdname vlm_estimate
#' @export
vlm_contrast.default <- function(fit, L) {
  fn <- "vlm_contrast"
  eng <- .vlm_engine(fit, fn)
  if (!is.list(L) || is.null(names(L)) || any(!nzchar(names(L)))) {
    .vlm_stop(fn, "`L` must be a named list of contrasts.")
  }
  rows <- lapply(names(L), function(nm) {
    Lm <- .vlm_L_matrix(eng, L[[nm]], fn, "L")
    est <- .vlm_estimable(eng, Lm)
    if (!all(est)) {
      return(data.table::data.table(label = nm, num_df = NA_integer_, den_df = NA_real_, F = NA_real_,
                                    p = NA_real_, note = "not estimable"))
    }
    ddf <- if (eng$ddfm %in% c("contain", "betwithin", "residual")) min(.vlm_row_df(eng, Lm)) else NULL
    w <- .vlm_wald(eng, Lm, "o", ddf)
    data.table::data.table(label = nm, num_df = w$ndf, den_df = w$ddf, F = w$F, p = w$p, note = "")
  })
  .vlm_result(list(contrasts = data.table::rbindlist(rows)), "contrast", label = "contrasts", call = match.call(),
              meta = list(ddfm = eng$ddfm))
}

# a random-effects coefficient row from a list effect -> coefficients over its levels
.vlm_K_row <- function(eng, x, fn) {
  mme <- .vlm_mme(eng)
  if (is.null(mme)) .vlm_stop(fn, "the model has no random effects for `random`.")
  if (is.numeric(x) && is.null(names(x))) {
    if (length(x) != length(mme$u)) .vlm_stop(fn, "a numeric `random` row must have ", length(mme$u),
                                              " coefficients.")
    return(x)
  }
  k <- numeric(length(mme$u))
  for (nm in names(x)) {
    idx <- which(mme$info$effect == nm)
    if (!length(idx)) {
      .vlm_stop(fn, "no random effect \"", nm, "\"; random effects: ", paste(unique(mme$info$effect), collapse = ", "),
                ".")
    }
    v <- as.numeric(x[[nm]])
    if (length(v) > length(idx)) .vlm_stop(fn, "random effect \"", nm, "\" has ", length(idx), " levels.")
    k[idx[seq_along(v)]] <- v
  }
  k
}

# estimate, se, df, t, p of l'beta + k'u (narrow inference space)
.vlm_narrow <- function(eng, l, k) {
  sp <- eng$spec
  S <- sp$So
  f <- function(mme) {
    lS <- l[S]
    as.numeric(crossprod(lS, mme$C11 %*% lS) + 2 * crossprod(lS, mme$C12 %*% k) + crossprod(k, mme$C22 %*% k))
  }
  mme <- .vlm_mme(eng)
  est <- sum(l[S] * .vlm_coords(eng, "o")$bS) + sum(k * mme$u)
  v <- f(mme)
  df <- if (eng$ddfm %in% c("satterth", "kr")) .vlm_satt_num(eng, f) else eng$df_resid
  se <- sqrt(max(v, 0))
  tval <- est / se
  list(est, se, df, tval, 2 * stats::pt(abs(tval), df, lower.tail = FALSE))
}

# Satterthwaite df of a variance function f(mme) by numerical derivatives in theta
.vlm_satt_num <- function(eng, f) {
  th <- eng$theta
  XS <- eng$spec$Xo[, eng$spec$So, drop = FALSE]
  v0 <- f(.vlm_mme(eng))
  g <- vapply(seq_along(th), function(i) {
    if (!eng$active[i]) return(0)
    h <- 1e-5 * max(abs(th[i]), 1e-2)
    val <- function(t) {
      cc <- .vlm_core(t, eng$st, XS, eng$spec$y, eng$reml)
      f(.vlm_mme(eng, t, cc))
    }
    tp <- th
    tm <- th
    tp[i] <- tp[i] + h
    tm[i] <- tm[i] - h
    (val(tp) - val(tm)) / (2 * h)
  }, 1)
  vg <- as.numeric(crossprod(g, eng$A_obs %*% g))
  if (!is.finite(vg) || vg <= 0) return(eng$df_resid)
  2 * v0^2 / vg
}

#' Best linear unbiased predictions of the random effects
#'
#' @description
#' The predictions \eqn{\widehat{\mathbf{u}} = \widehat{\mathbf{G}}\mathbf{Z}^{\top}\widehat{\mathbf{V}}^{-1}
#' (\mathbf{y} - \mathbf{X}\widehat{\boldsymbol{\beta}})} of the random effects of a fitted model, with the standard
#' errors of prediction \eqn{\sqrt{\mathrm{diag}(\mathbf{C}_{22})}}, t tests and prediction limits: the solution
#' for random effects of SAS PROC MIXED.
#'
#' @details
#' For a single random factor with \eqn{n_i} observations on level \eqn{i}, the prediction reduces to
#' \deqn{\widehat{s}_i = \frac{n_i\widehat{\sigma}_s^2}{n_i\widehat{\sigma}_s^2 + \widehat{\sigma}^2}
#' (\bar{y}_{i\cdot} - \widehat{\mu}),}
#' a shrinkage of the level mean towards the overall mean (Example 2.4.3.1 of the book). The degrees of freedom are
#' the residual ones, or Satterthwaite ones (numerical derivatives of the prediction-error variance) with
#' \code{ddfm = "satterth"} or \code{"kr"}.
#'
#' @param fit a result of \code{\link{vlm_fit}()}.
#' @param level confidence level of the prediction limits (default 0.95).
#' @return A list of class \code{c("vlm_blup", "vlm_result", "list")} with \code{blup} (effect, subject, level,
#'   prediction, standard error of prediction, df, t, p and limits).
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Section 2.4.3.
#'
#' Henderson, C. R. (1975). Best linear unbiased estimation and prediction under a selection model.
#' \emph{Biometrics}, 31, 423-447.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}
#' @family VetResearchLMM inference
#' @examples
#' # Example 2.4.3.1: PROC MIXED; CLASS sire; MODEL ww = ; RANDOM sire / SOLUTION;
#' fs <-
#'   vlm_fit(
#'       fixed    = Ww ~ 1
#'     , data     = ex127
#'     , random   = ~ sire
#'     , repeated = NULL
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' bl <-
#'   vlm_blup(
#'       fit   = fs
#'     , level = 0.95
#'     )
#' bl
#' @export
vlm_blup <- function(fit, level = 0.95) UseMethod("vlm_blup")

#' @rdname vlm_blup
#' @export
vlm_blup.default <- function(fit, level = 0.95) {
  fn <- "vlm_blup"
  eng <- .vlm_engine(fit, fn)
  level <- .vlm_check_number(level, "level", fn, min = 0.5, max = 0.9999)
  mme <- .vlm_mme(eng)
  if (is.null(mme)) .vlm_stop(fn, "the model has no random effects.")
  se <- sqrt(pmax(diag(mme$C22), 0))
  df <- rep(eng$df_resid, length(se))
  if (eng$ddfm %in% c("satterth", "kr")) {
    df <- vapply(seq_along(se), function(i) {
      .vlm_satt_num(eng, function(m) m$C22[i, i])
    }, 1)
  }
  tval <- mme$u / se
  tab <- data.table::data.table(effect = mme$info$effect, subject = mme$info$subject, level = mme$info$level,
                                estimate = mme$u, se = se, df = df, t = tval,
                                p = 2 * stats::pt(abs(tval), df, lower.tail = FALSE))
  tab <- .vlm_ci(tab, level)
  .vlm_result(list(blup = tab), "blup", label = "best linear unbiased predictions", call = match.call(),
              meta = list(level = level))
}

utils::globalVariables(c("estimate", "se", "lower", "upper", "space", "."))
