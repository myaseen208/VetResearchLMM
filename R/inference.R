#-------------------------------------------------------------------------------------------------------------------
# Inference for the fixed effects: generalised least squares in the overparameterised ("o") and the Sigma-restricted
# ("s") codings, estimability, Wald t and F statistics with containment, residual, between-within, Satterthwaite and
# Kenward-Roger denominator degrees of freedom, and the mixed-model-equation quantities for the random effects.
#-------------------------------------------------------------------------------------------------------------------

# GLS quantities in one coding, cached in the engine environment
.vlm_coords <- function(eng, which = c("o", "s")) {
  which <- match.arg(which)
  key <- paste0("coords_", which)
  if (!is.null(eng[[key]])) return(eng[[key]])
  sp <- eng$spec
  X <- if (which == "o") sp$Xo else sp$Xs
  S <- if (which == "o") sp$So else sp$Ss
  XS <- X[, S, drop = FALSE]
  Vi <- eng$core$Vi
  W <- Vi %*% XS
  CS <- chol2inv(chol(crossprod(XS, W)))
  bS <- as.numeric(CS %*% crossprod(W, sp$y))
  M <- lapply(eng$dV, function(D) crossprod(W, D %*% W))
  out <- list(X = X, S = S, XS = XS, W = W, CS = CS, bS = bS, M = M, p = ncol(X))
  eng[[key]] <- out
  out
}

# Kenward-Roger adjusted covariance Phi_A and the P_i matrices, in one coding
.vlm_kr <- function(eng, which) {
  key <- paste0("kr_", which)
  if (!is.null(eng[[key]])) return(eng[[key]])
  co <- .vlm_coords(eng, which)
  Phi <- co$CS
  k <- length(eng$dV)
  act <- which(eng$active)
  Wm <- eng$A_exp
  P <- lapply(seq_len(k), function(i) -co$M[[i]])
  Vi <- eng$core$Vi
  DW <- lapply(eng$dV, function(D) D %*% co$W)
  Q <- function(i, j) crossprod(DW[[i]], Vi %*% DW[[j]])
  d2 <- eng$d2V
  Rm <- function(i, j) {
    for (e in d2) if (e$i == i && e$j == j) return(crossprod(co$W, e$M %*% co$W))
    NULL
  }
  S <- matrix(0, ncol(Phi), ncol(Phi))
  for (i in act) for (j in act) {
    if (Wm[i, j] == 0) next
    term <- Q(i, j) - P[[i]] %*% Phi %*% P[[j]]
    r <- Rm(i, j)
    if (!is.null(r)) term <- term - 0.25 * r
    S <- S + Wm[i, j] * term
  }
  PhiA <- Phi + 2 * Phi %*% S %*% Phi
  out <- list(Phi = Phi, PhiA = (PhiA + t(PhiA)) / 2, P = P, act = act, W = Wm)
  eng[[key]] <- out
  out
}

# is each row of L (in the overparameterised coding) estimable?
.vlm_estimable <- function(eng, L) {
  if (is.null(eng$qr_rows)) eng$qr_rows <- qr(t(eng$spec$Xo), tol = 1e-7)
  res <- qr.resid(eng$qr_rows, t(L))
  scale <- pmax(apply(abs(L), 1L, max), 1)
  apply(abs(matrix(res, ncol = nrow(L))), 2L, max) / scale < 1e-6
}

# Satterthwaite degrees of freedom of the variance l' C l of one row (in S coordinates)
.vlm_satt1 <- function(eng, co, lS) {
  v <- as.numeric(crossprod(lS, co$CS %*% lS))
  Cl <- co$CS %*% lS
  g <- vapply(co$M, function(M) -as.numeric(crossprod(Cl, M %*% Cl)), 1)
  vg <- as.numeric(crossprod(g, eng$A_obs %*% g))
  if (!is.finite(vg) || vg <= 0) return(Inf)
  2 * v^2 / vg
}

# Wald F test of the rows of L (q x p, in the coding `which`); returns est, se (q = 1), F, ndf, ddf, p
.vlm_wald <- function(eng, L, which = "o", ddf = NULL) {
  co <- .vlm_coords(eng, which)
  if (!is.matrix(L)) L <- matrix(L, nrow = 1L)
  LS <- L[, co$S, drop = FALSE]
  est <- as.numeric(LS %*% co$bS)
  ddfm <- eng$ddfm
  if (ddfm == "kr") {
    kr <- .vlm_kr(eng, which)
    LC <- LS %*% kr$PhiA %*% t(LS)
  } else {
    LC <- LS %*% co$CS %*% t(LS)
  }
  # rank of L'CL (independent rows)
  ev <- eigen((LC + t(LC)) / 2, symmetric = TRUE)
  q <- sum(ev$values > max(ev$values) * 1e-8)
  if (q == 0L) return(list(est = est, se = rep(NA_real_, nrow(L)), F = NA_real_, ndf = 0L, ddf = NA_real_,
                           p = NA_real_))
  U <- ev$vectors[, seq_len(q), drop = FALSE]
  D <- ev$values[seq_len(q)]
  z <- as.numeric(crossprod(U, est))
  Fst <- sum(z^2 / D) / q
  se <- sqrt(pmax(diag(LC), 0))
  if (ddfm == "kr") {
    kr <- .vlm_kr(eng, which)
    # the KR scaling of the F statistic (Kenward and Roger 1997), on q independent rows
    Lq <- crossprod(U, LS)
    Phi <- kr$Phi
    Theta <- t(Lq) %*% solve(Lq %*% Phi %*% t(Lq)) %*% Lq
    act <- kr$act
    tr1 <- vapply(act, function(i) sum(diag(Theta %*% Phi %*% kr$P[[i]] %*% Phi)), 1)
    TPP <- lapply(act, function(i) Theta %*% Phi %*% kr$P[[i]] %*% Phi)
    A1 <- 0
    A2 <- 0
    for (a in seq_along(act)) for (b in seq_along(act)) {
      w <- kr$W[act[a], act[b]]
      A1 <- A1 + w * tr1[a] * tr1[b]
      A2 <- A2 + w * sum(diag(TPP[[a]] %*% TPP[[b]]))
    }
    B <- (A1 + 6 * A2) / (2 * q)
    g <- ((q + 1) * A1 - (q + 4) * A2) / ((q + 2) * A2)
    c1 <- g / (3 * q + 2 * (1 - g))
    c2 <- (q - g) / (3 * q + 2 * (1 - g))
    c3 <- (q + 2 - g) / (3 * q + 2 * (1 - g))
    Estar <- 1 / (1 - A2 / q)
    Vstar <- (2 / q) * (1 + c1 * B) / ((1 - c2 * B)^2 * (1 - c3 * B))
    rho <- Vstar / (2 * Estar^2)
    m <- 4 + (q + 2) / (q * rho - 1)
    lam <- m / (Estar * (m - 2))
    if (!is.finite(m) || m <= 0 || A2 <= 0) { m <- Inf; lam <- 1 }
    FA <- as.numeric(t(est) %*% .vlm_safe_solve(LC) %*% est) / q
    return(list(est = est, se = se, F = lam * FA, Fraw = FA, ndf = q, ddf = m,
                p = stats::pf(lam * FA, q, m, lower.tail = FALSE)))
  }
  if (is.null(ddf)) {
    if (ddfm == "satterth") {
      nus <- vapply(seq_len(q), function(m) .vlm_satt1(eng, co, as.numeric(crossprod(LS, U[, m]))), 1)
      if (q == 1L) {
        ddf <- nus
      } else {
        Ev <- sum(ifelse(nus > 2, nus / (nus - 2), 0))
        ddf <- if (Ev > q) 2 * Ev / (Ev - q) else min(nus)
      }
    } else {
      ddf <- eng$df_resid
    }
  }
  list(est = est, se = se, F = Fst, ndf = q, ddf = ddf, p = stats::pf(Fst, q, ddf, lower.tail = FALSE))
}

.vlm_safe_solve <- function(A) tryCatch(solve(A), error = function(e) .vlm_svd_ginv(A))

# one estimate per row of L: estimate, standard error, df, t and p (each row on its own)
.vlm_est_rows <- function(eng, L, which = "o", ddf = NULL) {
  if (!is.matrix(L)) L <- matrix(L, nrow = 1L)
  rows <- lapply(seq_len(nrow(L)), function(i) {
    w <- .vlm_wald(eng, L[i, , drop = FALSE], which, if (length(ddf) >= i && !is.na(ddf[i])) ddf[i] else NULL)
    se <- w$se
    if (eng$ddfm == "kr") se <- sqrt(w$est^2 / max(w$F, 1e-300))
    tval <- w$est / se
    data.table::data.table(estimate = w$est, se = se, df = w$ddf, t = tval,
                           p = 2 * stats::pt(abs(tval), w$ddf, lower.tail = FALSE))
  })
  data.table::rbindlist(rows)
}

#-------------------------------------------------------------------------------------------------------------------
# denominator degrees of freedom
#-------------------------------------------------------------------------------------------------------------------

.vlm_rank <- function(M) if (!ncol(M)) 0L else qr(M, tol = 1e-7)$rank

# random effects as SAS sees them for containment: one entry per random effect (a VC term, or an effect of a
# vlm_random() specification crossed with its subject), with its design and its variables
.vlm_random_effects <- function(spec) {
  out <- list()
  for (r in spec$random) {
    if (is.null(r$subject)) {
      out[[length(out) + 1L]] <- list(Z = r$Z[[1L]], vars = r$vars, label = r$label)
    } else {
      for (a in seq_along(r$Z)) {
        out[[length(out) + 1L]] <- list(Z = r$Z[[a]], vars = unique(c(r$vars, r$evars[[a]])),
                                        label = paste0(r$effects[a], " (", r$label, ")"))
      }
    }
  }
  out
}

.vlm_df_setup <- function(eng) {
  sp <- eng$spec
  re <- .vlm_random_effects(sp)
  Xo <- sp$Xo
  rk <- .vlm_rank(Xo)
  contrib <- numeric(length(re))
  M <- Xo
  for (i in seq_along(re)) {
    M2 <- cbind(M, re[[i]]$Z)
    r2 <- .vlm_rank(M2)
    contrib[i] <- r2 - rk
    rk <- r2
    M <- M2
  }
  eng$df_resid <- max(sp$n - rk, 1)
  eng$re <- re
  eng$re_contrib <- contrib
  # containment df of every fixed effect
  eng$df_contain <- vapply(seq_along(sp$labels), function(e) {
    fv <- sp$effvars[[e]]
    cont <- vapply(re, function(r) all(fv %in% r$vars), logical(1))
    if (any(cont)) max(min(contrib[cont]), 1) else eng$df_resid
  }, 1)
  # between-within df: the subject of the residual structure, else of the first random coefficient specification
  sub <- sp$residual$subject
  if (is.null(sub)) for (r in sp$random) if (!is.null(r$subject)) { sub <- r$subject; break }
  if (is.null(sub)) {
    eng$df_bw <- rep(eng$df_resid, length(sp$labels))
  } else {
    Zs <- stats::model.matrix(~ sub - 1)
    within_df <- max(sp$n - .vlm_rank(cbind(Xo, Zs)), 1)
    const <- vapply(seq_len(ncol(Xo)), function(j) {
      v <- Xo[, j]
      all(tapply(v, sub, function(z) max(z) - min(z)) < 1e-10)
    }, logical(1))
    between_eff <- vapply(seq_along(sp$labels), function(e) all(const[sp$assign_o == e]), logical(1))
    Xb <- Xo[, const, drop = FALSE]
    between_df <- max(nlevels(sub) - .vlm_rank(Xb), 1)
    eng$df_bw <- ifelse(between_eff, between_df, within_df)
  }
  invisible(eng)
}

# df of each fixed effect for the fixed-df methods
.vlm_effect_df <- function(eng) {
  switch(eng$ddfm
    , contain    = eng$df_contain
    , betwithin = eng$df_bw
    , residual       = rep(eng$df_resid, length(eng$spec$labels))
    , rep(NA_real_, length(eng$spec$labels))
    )
}

# df of a row of L (overparameterised coding) for the fixed-df methods: the smallest df of the effects it involves
.vlm_row_df <- function(eng, L) {
  edf <- .vlm_effect_df(eng)
  if (all(is.na(edf))) return(rep(NA_real_, nrow(L)))
  a <- eng$spec$assign_o
  apply(L, 1L, function(l) {
    e <- unique(a[abs(l) > 1e-12])
    if (!length(e)) eng$df_resid else min(edf[e])
  })
}

#-------------------------------------------------------------------------------------------------------------------
# random effects: G, Z and the mixed-model-equation quantities
#-------------------------------------------------------------------------------------------------------------------

.vlm_ZG <- function(spec, theta, st) {
  Zl <- list()
  blocks <- list()
  pi <- 0L
  info <- list()
  for (r in spec$random) {
    if (is.null(r$subject)) {
      pi <- pi + 1L
      Zl[[length(Zl) + 1L]] <- r$Z[[1L]]
      blocks[[length(blocks) + 1L]] <- diag(theta[pi], ncol(r$Z[[1L]]))
      info[[length(info) + 1L]] <- data.table::data.table(effect = r$label,
                                                          level = do.call(paste, r$levels),
                                                          subject = "")
    } else {
      m <- ncol(r$Z[[1L]])
      ne <- length(r$Z)
      G0 <- matrix(0, ne, ne)
      if (r$kind == "vc") {
        for (a in seq_len(ne)) { pi <- pi + 1L; G0[a, a] <- theta[pi] }
      } else {
        for (a in seq_len(ne)) for (b in seq_len(a)) { pi <- pi + 1L; G0[a, b] <- G0[b, a] <- theta[pi] }
      }
      Zl[[length(Zl) + 1L]] <- do.call(cbind, r$Z)
      blocks[[length(blocks) + 1L]] <- kronecker(G0, diag(m))
      lev <- do.call(paste, r$levels)
      info[[length(info) + 1L]] <- data.table::data.table(effect = rep(sub("^\\(Intercept\\)$", "Intercept",
                                                                           r$effects), each = m),
                                                          level = rep(lev, ne), subject = r$label)
    }
  }
  if (!length(Zl)) return(NULL)
  q <- sum(vapply(blocks, nrow, 1L))
  G <- matrix(0, q, q)
  o <- 0L
  for (b in blocks) { i <- o + seq_len(nrow(b)); G[i, i] <- b; o <- o + nrow(b) }
  list(Z = do.call(cbind, Zl), G = G, info = data.table::rbindlist(info))
}

# BLUPs and the prediction-error covariance (C22) and the covariance with the fixed effects (C12), at theta
.vlm_mme <- function(eng, theta = eng$theta, core = eng$core) {
  zg <- .vlm_ZG(eng$spec, theta, eng$st)
  if (is.null(zg)) return(NULL)
  sp <- eng$spec
  XS <- sp$Xo[, sp$So, drop = FALSE]
  Vi <- core$Vi
  ViX <- Vi %*% XS
  C <- chol2inv(chol(crossprod(XS, ViX)))
  P <- Vi - ViX %*% C %*% t(ViX)
  GZt <- zg$G %*% t(zg$Z)
  u <- as.numeric(GZt %*% core$Py)
  C22 <- zg$G - GZt %*% P %*% t(GZt)
  C12 <- -C %*% t(ViX) %*% t(GZt)
  list(u = u, C11 = C, C12 = C12, C22 = (C22 + t(C22)) / 2, info = zg$info, Z = zg$Z, G = zg$G)
}
