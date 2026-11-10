#' Analysis of variance with expected mean squares
#'
#' @description
#' The analysis of variance of a linear model fitted by ordinary least squares, with the expected mean squares of
#' each source when some effects are random, F tests built from the appropriate (synthesised) error terms with
#' Satterthwaite degrees of freedom, and the method-of-moments (Type 3) estimates of the variance components. This is
#' SAS PROC GLM with a RANDOM statement and the TEST option (Examples 1.3.2 and 2.5.3.1 of the book).
#'
#' @details
#' The sum of squares of a source is a quadratic form \eqn{SS = \mathbf{y}^{\top}\mathbf{A}\mathbf{y}}: for Type 3,
#' \eqn{\mathbf{A} = \mathbf{X}\mathbf{C}\mathbf{L}^{\top}(\mathbf{L}\mathbf{C}\mathbf{L}^{\top})^{-1}\mathbf{L}
#' \mathbf{C}\mathbf{X}^{\top}} with \eqn{\mathbf{C} = (\mathbf{X}^{\top}\mathbf{X})^{-1}} in the sum-to-zero coding
#' and \eqn{\mathbf{L}} selecting the columns of the source; for Type 1, the projection on the columns added by the
#' source. With random effects \eqn{\mathbf{u}_k \sim N(\mathbf{0}, \sigma_k^2\mathbf{I})} of design
#' \eqn{\mathbf{Z}_k},
#' \deqn{E(MS) = \sigma^2 + \sum_k \frac{\mathrm{tr}(\mathbf{Z}_k^{\top}\mathbf{A}\mathbf{Z}_k)}{DF}\,\sigma_k^2 +
#' Q(\mathrm{fixed}).}
#' The error term of a source is the combination \eqn{\sum_r a_r MS_r} of mean squares of other random sources and
#' the residual whose expectation equals that of the source under the null hypothesis; its degrees of freedom are
#' \eqn{(\sum_r a_r MS_r)^2 / \sum_r (a_r MS_r)^2 / DF_r} (Satterthwaite 1946). Equating the mean squares of the
#' random sources and the error to their expectations gives the Type 3 estimates of the variance components.
#'
#' @param fixed two-sided formula with every effect of the model, random effects included, in SAS MODEL order
#'   (for example \code{PCVdif ~ drug + drug:herd + dose + dose:drug}).
#' @param data a data frame with the variables.
#' @param random one-sided formula of the effects of \code{fixed} that are random (for example
#'   \code{~ drug:herd}); \code{NULL} for a fixed-effects analysis.
#' @param type type of sums of squares: 3 (default) or 1.
#' @param class optional character vector of numeric variables to treat as classification variables.
#' @return A list of class \code{c("vlm_ems", "vlm_result", "list")} with \code{anova} (source, df, sum of
#'   squares, mean square, expected mean square, F, error degrees of freedom and p-value),
#'   \code{coefficients} (the coefficients of the variance components in each expected mean square),
#'   \code{error_terms} (the combination of mean squares used as the error of each test) and
#'   \code{components} (Type 3 estimates of the variance components).
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Section 1.3.2 and
#' Appendix G.
#'
#' Satterthwaite, F. E. (1946). An approximate distribution of estimates of variance components. \emph{Biometrics
#' Bulletin}, 2, 110-114.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}
#' @family VetResearchLMM models
#' @examples
#' # Example 1.3.2: PROC GLM; CLASS herd dose drug; MODEL PCVdif = drug herd(drug) dose dose*drug;
#' # RANDOM herd(drug) / TEST;
#' em <-
#'   vlm_ems(
#'       fixed  = PCVdif ~ drug + drug:herd + dose + dose:drug
#'     , data   = ex124
#'     , random = ~ drug:herd
#'     , type   = 3
#'     , class  = "herd"
#'     )
#' em
#'
#' # one observation deleted: the expected mean squares of drug and herd(drug) no longer match
#' # (Table 1.3.2.3)
#' em1 <-
#'   vlm_ems(
#'       fixed  = PCVdif ~ drug + drug:herd + dose + dose:drug
#'     , data   = ex124[-1, ]
#'     , random = ~ drug:herd
#'     , type   = 3
#'     , class  = "herd"
#'     )
#' em1$coefficients
#' @export
vlm_ems <- function(fixed, data, random = NULL, type = 3, class = NULL) UseMethod("vlm_ems")

#' @rdname vlm_ems
#' @export
vlm_ems.default <- function(fixed, data, random = NULL, type = 3, class = NULL) {
  fn <- "vlm_ems"
  .vlm_check_data(data, fn)
  type <- .vlm_check_number(type, "type", fn, min = 1, max = 3, integer = TRUE)
  if (type == 2L) .vlm_stop(fn, "`type` must be 1 or 3.")
  if (!is.null(random) && (!inherits(random, "formula") || length(random) != 2L)) {
    .vlm_stop(fn, "`random` must be NULL or a one-sided formula.")
  }
  # random variables must be classification variables: declare them so
  rvars <- if (is.null(random)) character() else all.vars(random)
  spec <- .vlm_spec(fixed, data, NULL, NULL, unique(c(class, rvars)), fn)
  rlab <- if (is.null(random)) character() else attr(stats::terms(random, keep.order = TRUE), "term.labels")
  rsets <- lapply(rlab, .vlm_term_vars)
  is_rand <- vapply(spec$effvars, function(v) {
    length(v) > 0L && any(vapply(rsets, function(s) length(s) == length(v) && all(s %in% v), logical(1)))
  }, logical(1))
  missing_r <- vapply(rsets, function(s) !any(vapply(spec$effvars, function(v) length(s) == length(v) &&
                                                       all(s %in% v), logical(1))), logical(1))
  if (any(missing_r)) .vlm_stop(fn, "random effects not in `fixed`: ", paste(rlab[missing_r], collapse = ", "), ".")
  out <- .vlm_ems_core(spec, is_rand, type)
  .vlm_result(out, "ems", label = sprintf("Type %d analysis of variance of %s", type, spec$yname),
              call = match.call(), meta = list(type = type))
}

.vlm_ems_core <- function(spec, is_rand, type) {
  n <- spec$n
  y <- spec$y
  eff <- which(spec$labels != "(Intercept)")
  rand_idx <- eff[is_rand[eff]]
  Zr <- lapply(rand_idx, function(e) spec$design[[e]]$X)
  comp <- c(spec$labels[rand_idx], "Residual")
  # quadratic forms
  if (type == 3L) {
    XS <- spec$Xs[, spec$Ss, drop = FALSE]
    asg <- spec$assign_s[spec$Ss]
    C <- chol2inv(chol(crossprod(XS)))
    b <- as.numeric(C %*% crossprod(XS, y))
    A <- lapply(eff, function(e) {
      j <- which(asg == e)
      if (!length(j)) return(NULL)
      K <- XS %*% C[, j, drop = FALSE]
      K %*% solve(C[j, j, drop = FALSE], t(K))
    })
  } else {
    XS <- spec$Xo[, spec$So, drop = FALSE]
    asg <- spec$assign_o[spec$So]
    Q <- qr.Q(qr(XS, LAPACK = FALSE))
    A <- lapply(eff, function(e) {
      j <- which(asg == e)
      if (!length(j)) return(NULL)
      tcrossprod(Q[, j, drop = FALSE])
    })
  }
  H <- XS %*% chol2inv(chol(crossprod(XS))) %*% t(XS)
  dfe <- n - ncol(XS)
  sse <- sum((y - H %*% y)^2)
  keep <- !vapply(A, is.null, logical(1))
  eff <- eff[keep]
  A <- A[keep]
  df <- vapply(A, function(a) round(sum(diag(a))), 1)
  ss <- vapply(A, function(a) as.numeric(crossprod(y, a %*% y)), 1)
  ms <- ss / df
  # coefficients of the variance components in each expected mean square
  coef <- t(vapply(seq_along(A), function(i) {
    c(vapply(Zr, function(Z) sum(diag(crossprod(Z, A[[i]] %*% Z))) / df[i], 1), 1)
  }, numeric(length(comp))))
  coef <- rbind(coef, c(rep(0, length(Zr)), 1))
  coef[abs(coef) < 1e-10] <- 0
  dimnames(coef) <- list(c(spec$labels[eff], "Residual"), comp)
  # fixed effects appearing in each expected mean square
  fixed_in <- lapply(seq_along(A), function(i) {
    fx <- eff[!is_rand[eff]]
    fx[vapply(fx, function(g) {
      Xg <- spec$Xs[, spec$assign_s == g, drop = FALSE]
      max(abs(A[[i]] %*% Xg)) > 1e-8 * max(1, max(abs(Xg)))
    }, logical(1))]
  })
  ems_txt <- vapply(seq_len(nrow(coef)), function(i) {
    cf <- coef[i, ]
    parts <- c(
        "Var(Residual)"
      , vapply(which(cf[-length(cf)] != 0), function(k) {
          sprintf("%s Var(%s)", trimws(formatC(cf[k], digits = 6, format = "g")), comp[k])
        }, "")
      , if (i <= length(fixed_in) && length(fixed_in[[i]])) sprintf("Q(%s)", paste(spec$labels[fixed_in[[i]]],
                                                                                   collapse = ", "))
      )
    paste(parts, collapse = " + ")
  }, "")
  all_ms <- c(ms, sse / dfe)
  all_df <- c(df, dfe)
  rand_row <- c(is_rand[eff], TRUE)
  # error term of each test: a combination of the random rows (other than the source) and the residual
  err <- lapply(seq_along(eff), function(i) {
    target <- coef[i, ]
    if (is_rand[eff[i]]) target[match(spec$labels[eff[i]], comp)] <- 0
    rows <- setdiff(which(rand_row), i)
    rows <- rows[vapply(rows, function(r) r > length(fixed_in) || !length(fixed_in[[r]]), logical(1))]
    M <- coef[rows, , drop = FALSE]
    a <- tryCatch(qr.solve(t(M), target), error = function(e) NULL)
    if (is.null(a) || max(abs(t(M) %*% a - target)) > 1e-6) return(NULL)
    a[abs(a) < 1e-10] <- 0
    list(rows = rows[a != 0], a = a[a != 0])
  })
  Fv <- dfd <- pv <- rep(NA_real_, length(eff))
  etxt <- rep(NA_character_, length(eff))
  for (i in seq_along(eff)) {
    e <- err[[i]]
    if (is.null(e)) next
    den <- sum(e$a * all_ms[e$rows])
    dfd[i] <- den^2 / sum((e$a * all_ms[e$rows])^2 / all_df[e$rows])
    Fv[i] <- ms[i] / den
    pv[i] <- stats::pf(Fv[i], df[i], dfd[i], lower.tail = FALSE)
    nm <- c(spec$labels[eff], "Residual")[e$rows]
    etxt[i] <- paste(sprintf("%s MS(%s)", trimws(formatC(e$a, digits = 6, format = "g")), nm), collapse = " + ")
  }
  anova <- data.table::data.table(
      source  = c(spec$labels[eff], "Residual")
    , df      = c(df, dfe)
    , ss      = c(ss, sse)
    , ms      = all_ms
    , ems     = ems_txt
    , F       = c(Fv, NA_real_)
    , den_df  = c(dfd, NA_real_)
    , p       = c(pv, NA_real_)
    )
  # Type 3 (moment) estimates of the variance components
  rr <- which(rand_row)
  Mr <- coef[rr, , drop = FALSE]
  vc <- tryCatch(solve(Mr, all_ms[rr]), error = function(e) rep(NA_real_, length(comp)))
  list(
      anova        = anova
    , coefficients = coef
    , error_terms  = data.table::data.table(source = spec$labels[eff], error = etxt)
    , components   = data.table::data.table(component = comp, estimate = as.numeric(vc))
    )
}

# Type 3 estimates of the variance components of a vlm_fit() specification (method = "Type3"): the model with the
# random effects added as fixed effects after the fixed ones, as SAS PROC MIXED METHOD=TYPE3
.vlm_type3_theta <- function(fixed, data, random, class) {
  rl <- attr(stats::terms(random, keep.order = TRUE), "term.labels")
  full <- stats::as.formula(paste(.vlm_deparse(fixed), "+", paste(rl, collapse = " + ")))
  rvars <- all.vars(random)
  spec <- .vlm_spec(full, data, NULL, NULL, unique(c(class, rvars)), "vlm_fit")
  rsets <- lapply(rl, .vlm_term_vars)
  is_rand <- vapply(spec$effvars, function(v) {
    length(v) > 0L && any(vapply(rsets, function(s) length(s) == length(v) && all(s %in% v), logical(1)))
  }, logical(1))
  vc <- .vlm_ems_core(spec, is_rand, 3L)$components$estimate
  pmax(vc, 0)
}
