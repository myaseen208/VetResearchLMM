#-------------------------------------------------------------------------------------------------------------------
# Estimation engine: the covariance matrix V(theta) = Z G Z' + R and its derivatives, the (restricted) likelihood,
# its score and information, and the optimisation by average-information (Newton-type) steps with step halving and
# bounds, as in SAS PROC MIXED.
#-------------------------------------------------------------------------------------------------------------------

# covariance structure of a specification: parameters, linear components V = sum theta_i K_i, and at most one
# non-linear residual component sigma2 * M * rho^D (ar1, sp_pow)
.vlm_struct <- function(spec) {
  n <- spec$n
  par <- list()
  lin <- list()
  addp <- function(name, subject, lower, upper, kind, scale = 1) {
    par[[length(par) + 1L]] <<- list(name = name, subject = subject, lower = lower, upper = upper, kind = kind,
                                     scale = scale)
    length(par)
  }
  for (r in spec$random) {
    if (r$kind == "vc" && is.null(r$subject)) {
      Z <- r$Z[[1L]]
      i <- addp(r$label, "", 0, Inf, "var")
      lin[[length(lin) + 1L]] <- list(i = i, K = tcrossprod(Z))
    } else if (r$kind == "vc") {
      for (a in seq_along(r$Z)) {
        Z <- r$Z[[a]]
        i <- addp(sub("^\\(Intercept\\)$", "Intercept", r$effects[a]), r$label, 0, Inf, "var",
                  scale = 1 / max(mean(rowSums(Z^2)), 1e-12))
        lin[[length(lin) + 1L]] <- list(i = i, K = tcrossprod(Z))
      }
    } else {
      m <- length(r$Z)
      for (a in seq_len(m)) for (b in seq_len(a)) {
        Za <- r$Z[[a]]
        Zb <- r$Z[[b]]
        K <- if (a == b) tcrossprod(Za) else tcrossprod(Za, Zb) + tcrossprod(Zb, Za)
        sc <- 1 / sqrt(max(mean(rowSums(Za^2)), 1e-12) * max(mean(rowSums(Zb^2)), 1e-12))
        i <- addp(sprintf("UN(%d,%d)", a, b), r$label, if (a == b) 0 else -Inf, Inf, if (a == b) "var" else "cov",
                  scale = if (a == b) sc else 0)
        lin[[length(lin) + 1L]] <- list(i = i, K = K)
      }
    }
  }
  res <- spec$residual
  nl <- NULL
  if (res$type == "vc") {
    i <- addp("Residual", "", 0, Inf, "var")
    lin[[length(lin) + 1L]] <- list(i = i, K = diag(n))
  } else {
    same <- outer(as.integer(res$subject), as.integer(res$subject), `==`)
    if (res$type == "cs") {
      i <- addp("CS", res$label, -Inf, Inf, "cov", scale = 0.5)
      lin[[length(lin) + 1L]] <- list(i = i, K = same * 1)
      i <- addp("Residual", "", 0, Inf, "var", scale = 0.5)
      lin[[length(lin) + 1L]] <- list(i = i, K = diag(n))
    } else if (res$type %in% c("ar1", "sp_pow")) {
      tv <- res$time
      if (res$type == "ar1") tv <- match(tv, sort(unique(tv)))
      D <- abs(outer(tv, tv, `-`))
      D[!same] <- 0
      ir <- addp(if (res$type == "ar1") "AR(1)" else "SP(POW)", res$label, if (res$type == "ar1") -0.999 else 1e-6,
                 0.999, "rho")
      is <- addp("Residual", "", 0, Inf, "var")
      nl <- list(i_rho = ir, i_s2 = is, D = D, M = same * 1)
    } else if (res$type == "un") {
      pos <- match(res$time, sort(unique(res$time)))
      tl <- sort(unique(res$time))
      for (a in seq_along(tl)) for (b in seq_len(a)) {
        K <- same * ((outer(pos == a, pos == b) | outer(pos == b, pos == a)) * 1)
        i <- addp(sprintf("UN(%d,%d)", a, b), res$label, if (a == b) 0 else -Inf, Inf, if (a == b) "var" else "cov",
                  scale = if (a == b) 1 else 0)
        lin[[length(lin) + 1L]] <- list(i = i, K = K)
      }
    }
  }
  pt <- data.table::rbindlist(lapply(par, as.list))
  list(par = pt, lin = lin, nl = nl, n = n, k = nrow(pt))
}

.vlm_V <- function(theta, st) {
  V <- matrix(0, st$n, st$n)
  for (c in st$lin) V <- V + theta[c$i] * c$K
  if (!is.null(st$nl)) {
    nl <- st$nl
    V <- V + theta[nl$i_s2] * nl$M * theta[nl$i_rho]^nl$D
  }
  V
}

.vlm_dV <- function(theta, st) {
  out <- vector("list", st$k)
  for (c in st$lin) out[[c$i]] <- c$K
  if (!is.null(st$nl)) {
    nl <- st$nl
    rho <- theta[nl$i_rho]
    A <- nl$M * rho^nl$D
    dA <- nl$M * nl$D * ifelse(nl$D > 0, rho^pmax(nl$D - 1, 0), 0)
    out[[nl$i_s2]] <- A
    out[[nl$i_rho]] <- theta[nl$i_s2] * dA
  }
  out
}

# non-zero second derivatives of V (only the non-linear residual structures have them)
.vlm_d2V <- function(theta, st) {
  if (is.null(st$nl)) return(list())
  nl <- st$nl
  rho <- theta[nl$i_rho]
  D <- nl$D
  dA <- nl$M * D * ifelse(D > 0, rho^pmax(D - 1, 0), 0)
  d2A <- nl$M * D * (D - 1) * ifelse(D > 1, rho^pmax(D - 2, 0), 0)
  list(
      list(i = nl$i_rho, j = nl$i_rho, M = theta[nl$i_s2] * d2A)
    , list(i = nl$i_rho, j = nl$i_s2, M = dA)
    , list(i = nl$i_s2, j = nl$i_rho, M = dA)
    )
}

# the likelihood and the matrices that inference needs, at theta; X is of full column rank
.vlm_core <- function(theta, st, X, y, reml) {
  n <- length(y)
  p <- ncol(X)
  V <- .vlm_V(theta, st)
  R <- tryCatch(chol(V), error = function(e) NULL)
  if (is.null(R)) return(list(ok = FALSE, ll = -Inf))
  Vi <- chol2inv(R)
  ViX <- Vi %*% X
  XtViX <- crossprod(X, ViX)
  RX <- tryCatch(chol(XtViX), error = function(e) NULL)
  if (is.null(RX)) return(list(ok = FALSE, ll = -Inf))
  C <- chol2inv(RX)
  beta <- C %*% crossprod(ViX, y)
  r <- as.numeric(y - X %*% beta)
  Py <- as.numeric(Vi %*% r)
  quad <- sum(r * Py)
  ldV <- 2 * sum(log(diag(R)))
  ldX <- 2 * sum(log(diag(RX)))
  ll <- if (reml) -0.5 * ((n - p) * log(2 * pi) + ldV + ldX + quad) else -0.5 * (n * log(2 * pi) + ldV + quad)
  list(ok = TRUE, ll = ll, V = V, Vi = Vi, ViX = ViX, C = C, beta = as.numeric(beta), r = r, Py = Py, quad = quad,
       ldV = ldV, ldX = ldX)
}

.vlm_P <- function(core, reml) if (reml) core$Vi - core$ViX %*% core$C %*% t(core$ViX) else core$Vi

# score (derivative of the log-likelihood), average information and expected information
.vlm_derivs <- function(theta, st, core, reml, info = c("ai", "expected", "both")) {
  info <- match.arg(info)
  dV <- .vlm_dV(theta, st)
  P <- .vlm_P(core, reml)
  k <- length(dV)
  PD <- lapply(dV, function(D) P %*% D)
  sc <- vapply(seq_len(k), function(i) -0.5 * sum(diag(PD[[i]])) + 0.5 * sum(core$Py * (dV[[i]] %*% core$Py)), 1)
  out <- list(score = sc, dV = dV, P = P, PD = PD)
  if (info %in% c("ai", "both")) {
    DPy <- vapply(dV, function(D) as.numeric(D %*% core$Py), numeric(length(core$Py)))
    DPy <- matrix(DPy, ncol = k)
    out$ai <- 0.5 * crossprod(DPy, P %*% DPy)
  }
  if (info %in% c("expected", "both")) {
    E <- matrix(0, k, k)
    for (i in seq_len(k)) for (j in i:k) E[i, j] <- E[j, i] <- 0.5 * sum(PD[[i]] * t(PD[[j]]))
    out$expected <- E
  }
  out
}

# starting values from the ordinary least-squares residual variance
.vlm_start <- function(st, X, y) {
  q <- qr(X)
  s2 <- sum(qr.resid(q, y)^2) / max(length(y) - q$rank, 1)
  if (!is.finite(s2) || s2 <= 0) s2 <- stats::var(y)
  if (!is.finite(s2) || s2 <= 0) s2 <- 1
  pt <- st$par
  nvar <- sum(pt$kind == "var")
  vapply(seq_len(nrow(pt)), function(i) {
    switch(pt$kind[i]
      , var = s2 / nvar * pt$scale[i]
      , cov = s2 * pt$scale[i] * 0.5 / max(nvar, 1)
      , rho = 0.5
      )
  }, 1)
}

# maximise the (restricted) likelihood: Newton steps with the average-information matrix (falling back on the
# expected information), step halving, and an active set for parameters on their bounds
.vlm_optimise <- function(st, X, y, reml, start = NULL, bound = TRUE, maxit = 200L, tol = 1e-12) {
  pt <- st$par
  lower <- if (bound) pt$lower else ifelse(pt$kind == "rho", pt$lower, -Inf)
  upper <- pt$upper
  th <- if (is.null(start)) .vlm_start(st, X, y) else start
  th <- pmin(pmax(th, lower), upper)
  core <- .vlm_core(th, st, X, y, reml)
  if (!core$ok) {
    th <- .vlm_start(st, X, y)
    core <- .vlm_core(th, st, X, y, reml)
    if (!core$ok) return(list(theta = th, core = core, converged = FALSE, iter = 0L, message = "V is not positive definite at the start"))
  }
  conv <- FALSE
  msg <- ""
  it <- 0L
  for (it in seq_len(maxit)) {
    d <- .vlm_derivs(th, st, core, reml, "both")
    H <- d$ai
    if (any(!is.finite(H)) || min(eigen(H, symmetric = TRUE, only.values = TRUE)$values) <= 1e-12 * max(abs(H))) {
      H <- d$expected
    }
    free <- !((th <= lower + 1e-10 & d$score < 0) | (th >= upper - 1e-10 & d$score > 0))
    if (!any(free)) { conv <- TRUE; msg <- "all parameters on bounds"; break }
    Hf <- H[free, free, drop = FALSE]
    step <- rep(0, length(th))
    st_f <- tryCatch(solve(Hf, d$score[free]), error = function(e) NULL)
    if (is.null(st_f) || any(!is.finite(st_f))) {
      Hf <- d$expected[free, free, drop = FALSE] + diag(1e-8, sum(free))
      st_f <- tryCatch(solve(Hf, d$score[free]), error = function(e) d$score[free] * 1e-3)
    }
    step[free] <- st_f
    crit <- sum(d$score[free] * st_f)
    if (is.finite(crit) && abs(crit) < tol * max(1, abs(core$ll))) { conv <- TRUE; break }
    a <- 1
    improved <- FALSE
    for (h in 1:40) {
      cand <- pmin(pmax(th + a * step, lower), upper)
      cc <- .vlm_core(cand, st, X, y, reml)
      if (cc$ok && cc$ll >= core$ll - 1e-12) { improved <- TRUE; break }
      a <- a / 2
    }
    if (!improved) {
      # a gradient step as a last resort
      g <- d$score
      g[!free] <- 0
      a <- 1e-2 / max(abs(g), 1e-12) * max(abs(th), 1)
      for (h in 1:40) {
        cand <- pmin(pmax(th + a * g, lower), upper)
        cc <- .vlm_core(cand, st, X, y, reml)
        if (cc$ok && cc$ll > core$ll) { improved <- TRUE; break }
        a <- a / 2
      }
      if (!improved) { conv <- abs(crit) < 1e-6 * max(1, abs(core$ll)); msg <- "no further improvement"; break }
    }
    dll <- cc$ll - core$ll
    th <- cand
    core <- cc
    if (dll >= 0 && dll < tol * max(1, abs(core$ll)) && max(abs(a * step)) < 1e-8 * max(1, max(abs(th)))) {
      conv <- TRUE
      break
    }
  }
  if (!conv && !nzchar(msg)) msg <- "iteration limit reached"
  list(theta = th, core = core, converged = conv, iter = it, message = if (conv) "converged" else msg,
       lower = lower, upper = upper)
}

# observed information of the covariance parameters (minus the Hessian of the log-likelihood), by central
# differences of the analytic score; parameters on a bound are left out
.vlm_hessian <- function(theta, st, X, y, reml, active) {
  k <- length(theta)
  H <- matrix(0, k, k)
  idx <- which(active)
  sc <- function(t) {
    cc <- .vlm_core(t, st, X, y, reml)
    if (!cc$ok) return(rep(NA_real_, k))
    .vlm_derivs(t, st, cc, reml, "ai")$score
  }
  for (i in idx) {
    h <- 1e-4 * max(abs(theta[i]), 1e-2)
    tp <- theta
    tm <- theta
    tp[i] <- tp[i] + h
    tm[i] <- tm[i] - h
    H[, i] <- -(sc(tp) - sc(tm)) / (2 * h)
  }
  H <- (H + t(H)) / 2
  H[!active, ] <- 0
  H[, !active] <- 0
  H
}

# a generalised inverse of a symmetric matrix that is zero on the rows and columns of `out`
.vlm_ginv_sub <- function(H, keep) {
  A <- matrix(0, nrow(H), ncol(H))
  if (any(keep)) {
    Hk <- H[keep, keep, drop = FALSE]
    inv <- tryCatch(solve(Hk), error = function(e) .vlm_svd_ginv(Hk))
    A[keep, keep] <- inv
  }
  A
}

.vlm_svd_ginv <- function(X, tol = sqrt(.Machine$double.eps)) {
  s <- svd(X)
  pos <- s$d > max(tol * s$d[1L], 0)
  if (!any(pos)) return(array(0, dim(X)[2L:1L]))
  s$v[, pos, drop = FALSE] %*% ((1 / s$d[pos]) * t(s$u[, pos, drop = FALSE]))
}
