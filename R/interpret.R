#' Plain-language interpretation of a result
#'
#' @description
#' \code{vlm_interpret()} turns a result of the package into a short report: a headline, findings, recommendations
#' and cautions, computed from its numbers, with the sources of the method. It covers \code{\link{vlm_fit}()},
#' \code{\link{vlm_lsmeans}()}, \code{\link{vlm_estimate}()}, \code{\link{vlm_contrast}()},
#' \code{\link{vlm_blup}()}, \code{\link{vlm_ems}()} and \code{\link{vlm_compare}()}.
#'
#' @param x a result of a function of the package.
#' @param alpha significance level used in the sentences (default 0.05).
#' @param top number of levels named in the findings (default 3).
#' @param ... unused.
#' @param style \code{"text"} (default) or \code{"markdown"}.
#' @param width line width of the text (default \code{getOption("width")}).
#' @return An object of class \code{"vlm_interpretation"}: a list with \code{analysis}, \code{title},
#'   \code{headline}, \code{findings}, \code{recommendations}, \code{cautions}, \code{facts} (the numbers behind the
#'   sentences), \code{guide} (how to read the method) and \code{sources}. \code{format()} gives it as text or
#'   Markdown.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_cite}}, \code{\link{vlm_app}}
#' @family VetResearchLMM utilities
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
#' vlm_interpret(
#'     x     = fm
#'   , alpha = 0.05
#'   , top   = 3
#'   )
#' @export
vlm_interpret <- function(x, alpha = 0.05, top = 3L, ...) UseMethod("vlm_interpret")

#' @rdname vlm_interpret
#' @export
vlm_interpret.default <- function(x, alpha = 0.05, top = 3L, ...) {
  fn <- "vlm_interpret"
  alpha <- .vlm_check_number(alpha, "alpha", fn, min = 1e-6, max = 0.5)
  top <- .vlm_check_number(top, "top", fn, min = 1, integer = TRUE)
  if (!inherits(x, "vlm_result")) .vlm_stop(fn, "`x` must be a result of a function of the VetResearchLMM package.")
  cls <- .vlm_cls(x)
  f <- get0(paste0(".vlm_int_", cls), envir = asNamespace("VetResearchLMM"), inherits = FALSE)
  if (is.null(f)) .vlm_stop(fn, "no interpretation is defined for ", cls, " results.")
  out <- f(x, list(alpha = alpha, top = top))
  out$analysis <- cls
  out$guide <- .vlm_guides[[cls]]
  out$sources <- unname(vapply(.vlm_refs_list()[unique(.vlm_sources_of(x))], `[[`, "", "text"))
  structure(out[c("analysis", "title", "headline", "findings", "recommendations", "cautions", "facts", "guide",
                  "sources")], class = "vlm_interpretation")
}

#' @rdname vlm_interpret
#' @export
print.vlm_interpretation <- function(x, ...) {
  cat(format(x, style = "text"), sep = "\n")
  invisible(x)
}

#' @rdname vlm_interpret
#' @export
format.vlm_interpretation <- function(x, style = c("text", "markdown"), width = getOption("width", 80L), ...) {
  style <- .vlm_check_choice(style[1L], c("text", "markdown"), "style", "format")
  wrap <- function(s, prefix) {
    if (!length(s)) return(character(0))
    unlist(lapply(s, function(z) {
      w <- strwrap(z, width = max(40L, width - 2L) - nchar(prefix))
      c(paste0(prefix, w[1L]), if (length(w) > 1L) paste0(strrep(" ", nchar(prefix)), w[-1L]))
    }))
  }
  sec <- function(h, s) if (length(s)) c("", if (style == "markdown") paste("###", h) else paste0(h, ":"),
                                          wrap(s, "- ")) else character(0)
  c(if (style == "markdown") paste("##", x$title) else x$title,
    "", wrap(x$headline, ""),
    sec("Findings", x$findings), sec("Recommendations", x$recommendations), sec("Cautions", x$cautions),
    sec("Sources", x$sources))
}

# interpretations --------------------------------------------------------------------------------------------------

.vlm_num <- function(v, d = 3L) formatC(v, format = "g", digits = d)
.vlm_pv <- function(p) if (is.na(p)) "p not available" else if (p < 1e-4) "p < 0.0001" else sprintf("p = %s",
                                                                                                    formatC(p, format = "g", digits = 2))

.vlm_int_fit <- function(x, o) {
  eng <- attr(x, "engine")
  cv <- x$covariance
  tests <- x$tests
  find <- character()
  rec <- character()
  cau <- character()
  vars <- cv[!(parameter %in% c("CS")) & !grepl("^UN\\(([0-9]+),(?!\\1)", parameter, perl = TRUE) &
               !(parameter %in% c("AR(1)", "SP(POW)"))]
  vc_simple <- all(cv$parameter %in% c(vars$parameter))
  if (nrow(vars) > 1L && vc_simple) {
    tot <- sum(vars$estimate)
    sh <- 100 * vars$estimate / tot
    find <- c(find, sprintf("Of the total variance %s, %s.", .vlm_num(tot),
                            paste(sprintf("%s%% is due to %s", formatC(sh, format = "f", digits = 1),
                                          ifelse(vars$parameter == "Residual", "the residual (within) variation",
                                                 vars$parameter)), collapse = ", ")))
    if (nrow(vars) == 2L) {
      find <- c(find, sprintf("The intraclass correlation (two observations sharing %s) is %s.", vars$parameter[1L],
                              formatC(vars$estimate[1L] / tot, format = "f", digits = 3)))
    }
  }
  ar <- cv[parameter %in% c("AR(1)", "SP(POW)")]
  if (nrow(ar)) {
    find <- c(find, sprintf("Observations one step apart on the same subject correlate %s; five steps apart %s.",
                            formatC(ar$estimate, format = "f", digits = 3),
                            formatC(ar$estimate^5, format = "f", digits = 3)))
  }
  if (any(cv$parameter == "CS")) {
    r <- cv$estimate[cv$parameter == "CS"] / sum(cv$estimate[cv$parameter %in% c("CS", "Residual")])
    find <- c(find, sprintf("Any two observations on the same subject correlate %s (compound symmetry).",
                            formatC(r, format = "f", digits = 3)))
  }
  un <- cv[grepl("^UN\\(2,1\\)$", parameter)]
  if (nrow(un) && all(c("UN(1,1)", "UN(2,2)") %in% cv$parameter)) {
    r <- un$estimate / sqrt(cv$estimate[cv$parameter == "UN(1,1)"] * cv$estimate[cv$parameter == "UN(2,2)"])
    find <- c(find, sprintf(paste("The random intercepts and slopes correlate %s: %s."),
                            formatC(r, format = "f", digits = 2),
                            if (r < 0) "subjects that start higher fall faster" else "subjects that start higher rise faster"))
  }
  if (nrow(tests)) {
    sig <- tests[!is.na(p) & p < o$alpha]
    ns <- tests[!is.na(p) & p >= o$alpha]
    if (nrow(sig)) find <- c(find, sprintf("Significant at the %s level: %s.", o$alpha,
                                           paste(sprintf("%s (F = %s on %s and %s df, %s)", sig$effect,
                                                         .vlm_num(sig$F), sig$num_df, .vlm_num(sig$den_df),
                                                         vapply(sig$p, .vlm_pv, "")), collapse = "; ")))
    if (nrow(ns)) find <- c(find, sprintf("Not significant: %s.", paste(sprintf("%s (%s)", ns$effect,
                                                                              vapply(ns$p, .vlm_pv, "")),
                                                                      collapse = "; ")))
    inter <- tests[grepl(":", effect) & !is.na(p) & p < o$alpha]
    if (nrow(inter)) {
      rec <- c(rec, sprintf("The interaction %s is significant: compare the levels of one factor within each level of the other (vlm_lsmeans() of the interaction, or vlm_estimate()) rather than main-effect means.",
                            inter$effect[1L]))
    }
  }
  rec <- c(rec, "Report means with standard errors in the broad inference space (vlm_lsmeans()); use vlm_estimate() with `random` for the narrow space of the observed levels.")
  zero <- cv[parameter != "Residual" & !is.na(estimate) & abs(estimate) < 1e-8]
  if (nrow(zero)) cau <- c(cau, sprintf("The variance of %s is estimated as zero (on its bound); its effect is not distinguishable from the residual variation.",
                                        paste(zero$parameter, collapse = ", ")))
  if (!isTRUE(attr(x, "meta")$converged)) cau <- c(cau, "The estimation did not converge; results are unreliable.")
  if (is.environment(eng)) {
    for (r in eng$spec$random) {
      k <- ncol(r$Z[[1L]])
      if (k < 6L) cau <- c(cau, sprintf("%s has only %d levels: its variance is estimated with few degrees of freedom and is imprecise.",
                                        r$label, k))
    }
    if (eng$ddfm %in% c("contain", "residual", "betwithin") && length(eng$spec$random) &&
        nrow(tests)) {
      cau <- c(cau, sprintf("Denominator df by the %s method; with unbalanced data prefer ddfm = \"satterth\" or \"kr\".",
                            eng$ddfm))
    }
  }
  list(title = "Linear mixed model", headline = sprintf("%s, fitted by %s with %d covariance parameter%s.",
                                                        attr(x, "label"), attr(x, "meta")$method, nrow(cv),
                                                        if (nrow(cv) == 1L) "" else "s"),
       findings = find, recommendations = rec, cautions = cau,
       facts = list(covariance = cv, tests = tests))
}

.vlm_int_lsmeans <- function(x, o) {
  t <- x$lsmeans
  ok <- t[!is.na(estimate)]
  vars <- setdiff(names(t), c("estimate", "se", "df", "t", "p", "lower", "upper"))
  lab <- do.call(paste, ok[, vars, with = FALSE])
  ord <- order(-ok$estimate)
  find <- sprintf("Highest: %s (%s, SE %s); lowest: %s (%s, SE %s).", lab[ord[1L]], .vlm_num(ok$estimate[ord[1L]], 4),
                  .vlm_num(ok$se[ord[1L]]), lab[ord[length(ord)]], .vlm_num(ok$estimate[ord[length(ord)]], 4),
                  .vlm_num(ok$se[ord[length(ord)]]))
  cau <- character()
  if (nrow(ok) < nrow(t)) cau <- c(cau, sprintf("%d mean%s not estimable.", nrow(t) - nrow(ok),
                                                if (nrow(t) - nrow(ok) == 1L) " is" else "s are"))
  if (!is.null(x$diffs)) {
    d <- x$diffs[!is.na(p_adjusted)]
    s <- d[p_adjusted < o$alpha]
    find <- c(find, sprintf("%d of %d pairwise differences are significant at the %s level (adjustment: %s)%s", nrow(s),
                            nrow(d), o$alpha, attr(x, "meta")$adjust,
                            if (nrow(s)) paste0(": ", paste(utils::head(sprintf("%s vs %s (%s)", s$level_1, s$level_2,
                                                                              .vlm_num(s$estimate)), o$top),
                                                          collapse = "; "), if (nrow(s) > o$top) "; ..." else "", ".")
                            else "."))
  }
  list(title = "Least-squares means", headline = sprintf("%s: %d level%s.", attr(x, "label"), nrow(t),
                                                         if (nrow(t) == 1L) "" else "s"),
       findings = find,
       recommendations = if (is.null(x$diffs)) "Use diff = TRUE with adjust = \"tukey\" to compare all levels." else
         character(), cautions = cau, facts = list(lsmeans = t, diffs = x$diffs))
}

.vlm_int_estimate <- function(x, o) {
  e <- x$estimates
  find <- vapply(seq_len(nrow(e)), function(i) {
    if (is.na(e$estimate[i])) return(sprintf("%s: not estimable.", e$label[i]))
    sprintf("%s = %s (SE %s, %s df, %s; %g%% limits %s to %s; %s inference space).", e$label[i],
            .vlm_num(e$estimate[i], 4), .vlm_num(e$se[i]), .vlm_num(e$df[i]), .vlm_pv(e$p[i]),
            100 * attr(x, "meta")$level, .vlm_num(e$lower[i], 4), .vlm_num(e$upper[i], 4), e$space[i])
  }, "")
  list(title = "Estimates", headline = sprintf("%d estimate%s.", nrow(e), if (nrow(e) == 1L) "" else "s"),
       findings = find, recommendations = character(),
       cautions = if (any(e$space == "narrow")) "Narrow-space standard errors hold only for the observed levels of the random effects." else character(),
       facts = list(estimates = e))
}

.vlm_int_contrast <- function(x, o) {
  c <- x$contrasts
  find <- vapply(seq_len(nrow(c)), function(i) {
    if (is.na(c$F[i])) return(sprintf("%s: not estimable.", c$label[i]))
    sprintf("%s: F = %s on %s and %s df, %s: %s at the %s level.", c$label[i], .vlm_num(c$F[i]), c$num_df[i],
            .vlm_num(c$den_df[i]), .vlm_pv(c$p[i]), if (c$p[i] < o$alpha) "significant" else "not significant",
            o$alpha)
  }, "")
  list(title = "Contrasts", headline = sprintf("%d contrast%s.", nrow(c), if (nrow(c) == 1L) "" else "s"),
       findings = find, recommendations = character(), cautions = character(), facts = list(contrasts = c))
}

.vlm_int_blup <- function(x, o) {
  b <- x$blup
  ord <- order(-b$estimate)
  lab <- trimws(paste(b$effect, b$level))
  find <- c(sprintf("Largest predictions: %s.", paste(sprintf("%s (%s)", lab[utils::head(ord, o$top)],
                                                              .vlm_num(b$estimate[utils::head(ord, o$top)])),
                                                      collapse = ", ")),
            sprintf("Smallest predictions: %s.", paste(sprintf("%s (%s)", lab[utils::tail(ord, o$top)],
                                                               .vlm_num(b$estimate[utils::tail(ord, o$top)])),
                                                       collapse = ", ")),
            sprintf("%d of %d predictions differ from zero at the %s level.", sum(b$p < o$alpha, na.rm = TRUE),
                    nrow(b), o$alpha))
  list(title = "Best linear unbiased predictions",
       headline = sprintf("%d predicted random effects, shrunk towards zero according to the variance components.",
                          nrow(b)),
       findings = find,
       recommendations = "Rank levels (for example sires for selection) by their predictions, not by their raw means.",
       cautions = character(), facts = list(blup = b))
}

.vlm_int_ems <- function(x, o) {
  a <- x$anova[!is.na(F)]
  find <- sprintf("%s: F = %s on %s and %s df (%s), error term %s.", a$source, .vlm_num(a$F), a$df, .vlm_num(a$den_df),
                  vapply(a$p, .vlm_pv, ""), x$error_terms$error[match(a$source, x$error_terms$source)])
  co <- x$components
  if (nrow(co) > 1L) find <- c(find, sprintf("Type 3 variance components: %s.", paste(sprintf("%s %s", co$component,
                                                                                         .vlm_num(co$estimate)),
                                                                                 collapse = ", ")))
  cau <- character()
  if (any(co$estimate < 0, na.rm = TRUE)) cau <- "A negative Type 3 estimate means the component is small; REML (vlm_fit()) keeps it at zero."
  unb <- x$coefficients[, -ncol(x$coefficients), drop = FALSE]
  if (ncol(unb) && any(abs(unb - round(unb)) > 1e-8)) cau <- c(cau, "The data are unbalanced: the expected mean squares do not match exactly and the F tests are approximate; prefer vlm_fit().")
  list(title = "Analysis of variance with expected mean squares", headline = attr(x, "label"), findings = find,
       recommendations = character(), cautions = cau, facts = list(anova = x$anova))
}

.vlm_int_compare <- function(x, o) {
  m <- x$models
  best <- m$model[which.min(m$AIC)]
  bbic <- m$model[which.min(m$BIC)]
  find <- c(sprintf("Smallest AIC: %s; smallest BIC: %s.", best, bbic))
  tt <- m[!is.na(p)]
  if (nrow(tt)) find <- c(find, sprintf("%s against the previous model: chi-square %s on %s df, %s.", tt$model,
                                        .vlm_num(tt$chisq), tt$df, vapply(tt$p, .vlm_pv, "")))
  list(title = "Model comparison", headline = attr(x, "label"), findings = find,
       recommendations = "Prefer the simplest covariance structure whose information criterion is close to the smallest.",
       cautions = "Likelihood ratio tests are valid for nested models only; REML likelihoods compare models with the same fixed effects.",
       facts = list(models = m))
}

.vlm_guides <- list(
    fit = "Covariance parameters describe the sources of variation; fixed effects are tested with F statistics whose denominator degrees of freedom reflect those sources."
  , lsmeans = "Least-squares means average over the other factors with equal weights; their standard errors include every random source (broad inference space)."
  , estimate = "Each estimate is a linear combination of fixed (and possibly random) effects with its standard error and t test."
  , contrast = "Each contrast tests that a set of linear combinations is zero with an F statistic."
  , blup = "Predictions of random effects are shrunk towards zero: more so for levels with few observations or a small variance component."
  , ems = "Each mean square has an expectation made of variance components; a valid F test divides by a mean square with the same expectation under the null hypothesis."
  , compare = "Information criteria trade fit against the number of covariance parameters: smaller is better."
  )

utils::globalVariables(c("parameter", "p_adjusted", "effect", "F", "p"))
