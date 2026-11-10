#-------------------------------------------------------------------------------------------------------------------
# Model specification: random-effects and residual (repeated) structures, and the design matrices of a model.
#
# Fixed effects use the overparameterised design of SAS PROC MIXED: one column for every observed level (or cell) of a
# classification effect, aliased columns set to zero by a generalised inverse (the G2 inverse of the sweep operator).
# Type 3 tests use the sum-to-zero (Sigma-restricted) coding of the same effects.
#-------------------------------------------------------------------------------------------------------------------

#' Random-effects and residual covariance structures
#'
#' @description
#' \code{vlm_random()} declares random coefficients for a subject (the \code{RANDOM ... / SUBJECT= TYPE=} statement
#' of SAS PROC MIXED), and \code{vlm_repeated()} declares the covariance structure of the residuals within a subject
#' (the \code{REPEATED / SUBJECT= TYPE=} statement). Both are passed to \code{\link{vlm_fit}()}.
#'
#' @details
#' A random coefficient specification adds, for subject \eqn{s} with design rows \eqn{\mathbf{z}_{si}^{\top}} (the
#' values of \code{effects} for observation \eqn{i}), the term \eqn{\mathbf{z}_{si}^{\top}\mathbf{b}_s} with
#' \eqn{\mathbf{b}_s \sim N(\mathbf{0}, \mathbf{G}_0)} independent between subjects. With \code{type = "vc"},
#' \eqn{\mathbf{G}_0} is diagonal (one variance per effect); with \code{type = "un"} it is unstructured and its
#' parameters are reported as \eqn{UN(1,1)}, \eqn{UN(2,1)}, \eqn{UN(2,2)}, \dots, as in SAS.
#'
#' The residual structures for the observations of one subject, with \eqn{t_i} the order (or time) of observation
#' \eqn{i}, are
#' \deqn{\mathrm{vc}:\ \sigma^2\mathbf{I},\qquad \mathrm{cs}:\ \sigma_1\mathbf{J} + \sigma^2\mathbf{I},\qquad
#' \mathrm{ar1}:\ \sigma^2\rho^{|r_i - r_j|},\qquad \mathrm{sp\_pow}:\ \sigma^2\rho^{|t_i - t_j|},\qquad
#' \mathrm{un}:\ \sigma_{t_i t_j},}
#' where \eqn{r_i} is the rank of \eqn{t_i} among the distinct times in the data, \eqn{\mathbf{J}} a matrix of ones
#' and \eqn{\sigma_1} the compound-symmetry covariance. Observations of different subjects are independent.
#'
#' @param effects one-sided formula of the random coefficients, such as \code{~ 1 + time} (random intercept and
#'   slope) or \code{~ 1}.
#' @param subject one-sided formula of the subject, such as \code{~ animal_id:breed}; its variables are treated as
#'   classification variables and their combination identifies a subject.
#' @param type \code{"vc"} (variance components, independent coefficients; the default of \code{vlm_random()}) or
#'   \code{"un"} (unstructured) for \code{vlm_random()}; \code{"vc"}, \code{"cs"}, \code{"ar1"}, \code{"sp_pow"} or
#'   \code{"un"} for \code{vlm_repeated()}.
#' @param order one-sided formula of the time (or order) variable within a subject, such as \code{~ time}; required
#'   for \code{"sp_pow"} and \code{"un"}; for \code{"ar1"} the data order within a subject is used when it is
#'   \code{NULL}.
#' @return An object of class \code{vlm_random} or \code{vlm_repeated}: a list with the arguments.
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Section 3.4.
#'
#' Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D. (1996). \emph{SAS System for Mixed Models}.
#' SAS Institute, Cary, NC.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}
#' @family VetResearchLMM models
#' @examples
#' # random intercept and slope per animal, unstructured covariance (Example 3.3, Model 3)
#' ri <-
#'   vlm_random(
#'       effects = ~ 1 + time
#'     , subject = ~ animal_id:breed
#'     , type    = "un"
#'     )
#' ri
#'
#' # first-order autoregressive residuals within an animal (Example 3.3, Model 2)
#' ar <-
#'   vlm_repeated(
#'       type    = "ar1"
#'     , subject = ~ animal_id:breed
#'     , order   = ~ time
#'     )
#' ar
#' @name vlm_random
#' @export
vlm_random <- function(effects = ~ 1, subject, type = c("vc", "un")) {
  fn <- "vlm_random"
  type <- match.arg(type)
  if (!inherits(effects, "formula") || length(effects) != 2L) .vlm_stop(fn, "`effects` must be a one-sided formula.")
  if (missing(subject) || !inherits(subject, "formula") || length(subject) != 2L) {
    .vlm_stop(fn, "`subject` must be a one-sided formula such as ~ animal_id.")
  }
  structure(list(effects = effects, subject = subject, type = type), class = "vlm_random")
}

#' @rdname vlm_random
#' @export
vlm_repeated <- function(type = c("vc", "cs", "ar1", "sp_pow", "un"), subject, order = NULL) {
  fn <- "vlm_repeated"
  type <- match.arg(type)
  if (missing(subject) || !inherits(subject, "formula") || length(subject) != 2L) {
    .vlm_stop(fn, "`subject` must be a one-sided formula such as ~ animal_id.")
  }
  if (!is.null(order) && (!inherits(order, "formula") || length(order) != 2L)) {
    .vlm_stop(fn, "`order` must be NULL or a one-sided formula such as ~ time.")
  }
  if (type %in% c("sp_pow", "un") && is.null(order)) .vlm_stop(fn, "type \"", type, "\" needs `order`.")
  structure(list(type = type, subject = subject, order = order), class = "vlm_repeated")
}

#' @export
print.vlm_random <- function(x, ...) {
  cat(sprintf("Random coefficients %s, subject %s, type %s\n", .vlm_deparse(x$effects), .vlm_deparse(x$subject),
              toupper(x$type)))
  invisible(x)
}

#' @export
print.vlm_repeated <- function(x, ...) {
  cat(sprintf("Residual structure %s, subject %s%s\n", toupper(x$type), .vlm_deparse(x$subject),
              if (is.null(x$order)) "" else paste0(", order ", .vlm_deparse(x$order))))
  invisible(x)
}

.vlm_deparse <- function(f) paste(deparse(f, width.cutoff = 500L), collapse = " ")

#-------------------------------------------------------------------------------------------------------------------
# variables: evaluate an expression of a term (a name or a call such as log(x)) in the data
#-------------------------------------------------------------------------------------------------------------------

.vlm_eval_var <- function(expr, data, fn) {
  v <- tryCatch(eval(str2lang(expr), envir = data, enclos = globalenv()), error = function(e) NULL)
  if (is.null(v) || length(v) != nrow(data)) .vlm_stop(fn, "cannot evaluate \"", expr, "\" in `data`.")
  v
}

# a classification variable as a factor with SAS-like level order (factor levels kept; otherwise sorted values)
.vlm_as_class <- function(v) {
  if (is.factor(v)) return(droplevels(v))
  u <- sort(unique(v))
  factor(v, levels = u, labels = as.character(u))
}

.vlm_is_class <- function(v) is.factor(v) || is.character(v) || is.logical(v)

# a term label such as "Drug:dose" split into its variable expressions
.vlm_term_vars <- function(label) {
  if (label == "(Intercept)") return(character())
  tt <- stats::terms(stats::as.formula(paste("~", label)))
  rownames(attr(tt, "factors"))
}

# the variables of an effect: class (factor) variables and covariate (numeric) variables
.vlm_split_vars <- function(vars, vals) {
  cls <- vars[vapply(vars, function(v) is.factor(vals[[v]]), logical(1))]
  list(class = cls, cov = setdiff(vars, cls))
}

#-------------------------------------------------------------------------------------------------------------------
# overparameterised design of one effect: a column for every observed cell, levels in SAS order (last variable fastest)
#-------------------------------------------------------------------------------------------------------------------

.vlm_effect_design <- function(label, vars, vals, n) {
  if (!length(vars)) {
    return(list(X = matrix(1, n, 1L, dimnames = list(NULL, "(Intercept)")), levels = data.table::data.table(),
                class = character(), cov = character(), cell = rep(1L, n)))
  }
  sp <- .vlm_split_vars(vars, vals)
  covprod <- if (length(sp$cov)) Reduce(`*`, lapply(sp$cov, function(v) as.numeric(vals[[v]]))) else rep(1, n)
  if (!length(sp$class)) {
    return(list(X = matrix(covprod, n, 1L, dimnames = list(NULL, label)), levels = data.table::data.table(),
                class = character(), cov = sp$cov, cell = rep(1L, n)))
  }
  codes <- lapply(sp$class, function(v) as.integer(vals[[v]]))
  dt <- data.table::as.data.table(stats::setNames(codes, sp$class))
  cells <- unique(dt)
  data.table::setorderv(cells, sp$class)
  key <- do.call(paste, c(dt, sep = "\r"))
  ckey <- do.call(paste, c(cells, sep = "\r"))
  cell <- match(key, ckey)
  X <- matrix(0, n, nrow(cells))
  X[cbind(seq_len(n), cell)] <- covprod
  lev <- data.table::as.data.table(lapply(sp$class, function(v) levels(vals[[v]])[cells[[v]]]))
  data.table::setnames(lev, sp$class)
  colnames(X) <- paste(label, do.call(paste, lev))
  list(X = X, levels = lev, class = sp$class, cov = sp$cov, cell = cell)
}

# Sigma-restricted (sum-to-zero) coding of one effect: a classification variable is "crossed" when the effect
# without it is in the model, and "nesting" otherwise (as in model.matrix()). Within every observed combination of
# the nesting variables, each crossed variable is coded by sum-to-zero contrasts over the levels it takes there, so
# that nested effects sum to zero within their nest; aliased columns are dropped later.
.vlm_effect_sigma <- function(label, vars, vals, n, term_sets, intercept) {
  if (!length(vars)) return(matrix(1, n, 1L))
  sp <- .vlm_split_vars(vars, vals)
  covprod <- if (length(sp$cov)) Reduce(`*`, lapply(sp$cov, function(v) as.numeric(vals[[v]]))) else rep(1, n)
  if (!length(sp$class)) return(matrix(covprod, n, 1L))
  has <- function(set) {
    if (!length(set)) return(intercept)
    any(vapply(term_sets, function(s) length(s) == length(set) && all(set %in% s), logical(1)))
  }
  crossed <- sp$class[vapply(sp$class, function(v) has(setdiff(vars, v)), logical(1))]
  nesting <- setdiff(sp$class, crossed)
  grp <- if (length(nesting)) {
    interaction(lapply(nesting, function(v) vals[[v]]), drop = TRUE, lex.order = TRUE)
  } else factor(rep(1L, n))
  if (!length(crossed)) return(stats::model.matrix(~ grp - 1) * covprod)
  blocks <- lapply(levels(grp), function(g) {
    rows <- which(grp == g)
    codes <- lapply(crossed, function(v) {
      f <- droplevels(vals[[v]][rows])
      k <- nlevels(f)
      if (k < 2L) return(NULL)
      stats::contr.sum(k)[as.integer(f), , drop = FALSE]
    })
    if (any(vapply(codes, is.null, logical(1)))) return(NULL)
    M <- codes[[1L]]
    if (length(codes) > 1L) {
      for (b in codes[-1L]) M <- do.call(cbind, lapply(seq_len(ncol(M)), function(j) M[, j] * b))
    }
    out <- matrix(0, n, ncol(M))
    out[rows, ] <- M
    out
  })
  blocks <- blocks[!vapply(blocks, is.null, logical(1))]
  if (!length(blocks)) return(matrix(0, n, 0L))
  do.call(cbind, blocks) * covprod
}

#-------------------------------------------------------------------------------------------------------------------
# the full specification of a model on its data
#-------------------------------------------------------------------------------------------------------------------

.vlm_parse_random <- function(random, fn) {
  if (is.null(random)) return(list())
  if (inherits(random, "vlm_random")) return(list(random))
  if (inherits(random, "formula")) {
    if (length(random) != 2L) .vlm_stop(fn, "`random` must be a one-sided formula such as ~ Region + Region:Drug.")
    return(list(random))
  }
  if (is.list(random) && all(vapply(random, function(r) inherits(r, c("formula", "vlm_random")), logical(1)))) {
    return(random)
  }
  .vlm_stop(fn, "`random` must be NULL, a one-sided formula, a vlm_random() specification or a list of these.")
}

.vlm_spec <- function(fixed, data, random, repeated, class, fn) {
  if (!inherits(fixed, "formula") || length(fixed) != 3L) .vlm_stop(fn, "`fixed` must be a two-sided formula.")
  data <- as.data.frame(data)
  rlist <- .vlm_parse_random(random, fn)
  if (!is.null(repeated) && !inherits(repeated, "vlm_repeated")) {
    .vlm_stop(fn, "`repeated` must be NULL or a vlm_repeated() specification.")
  }
  tt <- stats::terms(fixed, keep.order = TRUE)
  labels <- attr(tt, "term.labels")
  intercept <- attr(tt, "intercept") == 1L
  yexpr <- .vlm_deparse(fixed[[2L]])

  # every variable expression used anywhere
  fvars <- lapply(labels, .vlm_term_vars)
  rterms <- list()
  for (r in rlist) {
    if (inherits(r, "formula")) {
      rt <- stats::terms(r, keep.order = TRUE)
      for (lb in attr(rt, "term.labels")) rterms[[length(rterms) + 1L]] <- list(kind = "vc", label = lb,
                                                                               vars = .vlm_term_vars(lb))
    } else {
      et <- stats::terms(r$effects, keep.order = TRUE)
      eff <- c(if (attr(et, "intercept") == 1L) "(Intercept)", attr(et, "term.labels"))
      if (!length(eff)) .vlm_stop(fn, "a vlm_random() specification has no effects.")
      rterms[[length(rterms) + 1L]] <- list(kind = r$type, effects = eff, subject = .vlm_term_vars(
          .vlm_deparse(r$subject[[2L]])), label = .vlm_deparse(r$subject[[2L]]))
    }
  }
  svars <- unique(unlist(lapply(rterms, function(r) if (is.null(r$subject)) character() else r$subject)))
  evars <- unique(unlist(lapply(rterms, function(r) {
    if (is.null(r$effects)) character() else unlist(lapply(setdiff(r$effects, "(Intercept)"), .vlm_term_vars))
  })))
  vcvars <- unique(unlist(lapply(rterms, function(r) if (r$kind == "vc" && is.null(r$effects)) r$vars)))
  rep_sub <- if (is.null(repeated)) character() else .vlm_term_vars(.vlm_deparse(repeated$subject[[2L]]))
  rep_ord <- if (is.null(repeated) || is.null(repeated$order)) character() else
    .vlm_term_vars(.vlm_deparse(repeated$order[[2L]]))
  allv <- unique(c(yexpr, unlist(fvars), vcvars, svars, evars, rep_sub, rep_ord))
  vals <- lapply(stats::setNames(allv, allv), .vlm_eval_var, data = data, fn = fn)

  # complete cases
  ok <- Reduce(`&`, lapply(vals, function(v) !is.na(v)))
  if (!any(ok)) .vlm_stop(fn, "no complete observations.")
  vals <- lapply(vals, function(v) v[ok])
  n <- sum(ok)
  y <- as.numeric(vals[[yexpr]])
  if (!is.numeric(vals[[yexpr]])) .vlm_stop(fn, "the response \"", yexpr, "\" must be numeric.")

  # classification variables: non-numeric ones, those named in `class`, subjects and variables of random VC effects
  # that are not numeric covariates declared as such
  forced <- unique(c(class, svars, rep_sub))
  for (v in setdiff(allv, yexpr)) {
    if (.vlm_is_class(vals[[v]]) || v %in% forced) vals[[v]] <- .vlm_as_class(vals[[v]])
  }
  # numeric variables in random VC terms are classification variables unless they also act as covariates in the
  # fixed part (as in SAS, where they must be in the CLASS statement)
  for (v in vcvars) if (!is.factor(vals[[v]]) && !(v %in% unlist(fvars))) vals[[v]] <- .vlm_as_class(vals[[v]])
  if (!is.null(class)) {
    bad <- setdiff(class, allv)
    if (length(bad)) .vlm_stop(fn, "`class` names variables not in the model: ", paste(bad, collapse = ", "), ".")
  }

  # fixed effects: overparameterised and Sigma-restricted designs
  efflab <- c(if (intercept) "(Intercept)", labels)
  effvars <- c(if (intercept) list(character()), fvars)
  term_full <- fvars
  des <- lapply(seq_along(efflab), function(i) .vlm_effect_design(efflab[i], effvars[[i]], vals, n))
  Xo <- do.call(cbind, lapply(des, `[[`, "X"))
  assign_o <- rep(seq_along(efflab), vapply(des, function(d) ncol(d$X), 1L))
  sig <- lapply(seq_along(efflab), function(i) .vlm_effect_sigma(efflab[i], effvars[[i]], vals, n, term_full,
                                                                  intercept))
  Xs <- do.call(cbind, sig)
  assign_s <- rep(seq_along(efflab), vapply(sig, ncol, 1L))
  qo <- qr(Xo, tol = 1e-7)
  So <- sort(qo$pivot[seq_len(qo$rank)])
  qs <- qr(Xs, tol = 1e-7)
  Ss <- sort(qs$pivot[seq_len(qs$rank)])

  # random effects: design blocks
  rand <- list()
  for (r in rterms) {
    if (is.null(r$effects)) {
      d <- .vlm_effect_design(r$label, r$vars, vals, n)
      rand[[length(rand) + 1L]] <- list(kind = "vc", label = r$label, Z = list(d$X), levels = d$levels,
                                        vars = r$vars, effects = r$label, subject = NULL)
    } else {
      sid <- interaction(lapply(r$subject, function(v) vals[[v]]), drop = TRUE, lex.order = TRUE)
      sd <- .vlm_effect_design(r$label, r$subject, vals, n)
      Zs <- lapply(r$effects, function(e) {
        w <- if (e == "(Intercept)") rep(1, n) else {
          ev <- .vlm_term_vars(e)
          Reduce(`*`, lapply(ev, function(v) as.numeric(vals[[v]])))
        }
        Z <- sd$X * w
        colnames(Z) <- paste(e, do.call(paste, sd$levels))
        Z
      })
      rand[[length(rand) + 1L]] <- list(kind = r$kind, label = r$label, Z = Zs, levels = sd$levels,
                                        vars = r$subject, effects = r$effects, subject = sid,
                                        evars = lapply(r$effects, function(e) if (e == "(Intercept)") character() else
                                          .vlm_term_vars(e)))
    }
  }

  # residual structure
  res <- list(type = "vc", subject = NULL, time = NULL)
  if (!is.null(repeated)) {
    sid <- interaction(lapply(rep_sub, function(v) vals[[v]]), drop = TRUE, lex.order = TRUE)
    tim <- if (length(rep_ord)) {
      tv <- vals[[rep_ord[1L]]]
      if (is.factor(tv)) as.integer(tv) else as.numeric(tv)
    } else stats::ave(seq_len(n), sid, FUN = seq_along)
    res <- list(type = repeated$type, subject = sid, time = tim, label = .vlm_deparse(repeated$subject[[2L]]),
                order = if (length(rep_ord)) rep_ord[1L] else NULL)
  }

  list(
      y          = y
    , yname      = yexpr
    , n          = n
    , vals       = vals
    , rows       = which(ok)
    , labels     = efflab
    , effvars    = effvars
    , design     = des
    , Xo         = Xo
    , assign_o   = assign_o
    , So         = So
    , Xs         = Xs
    , assign_s   = assign_s
    , Ss         = Ss
    , intercept  = intercept
    , random     = rand
    , residual   = res
    , fixed      = fixed
    , random_arg = random
    , repeated   = repeated
    )
}
