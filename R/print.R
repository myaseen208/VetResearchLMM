#-------------------------------------------------------------------------------------------------------------------
# Printing of the results, in the order and with the names of the SAS output that the book shows
#-------------------------------------------------------------------------------------------------------------------

.vlm_fmt_table <- function(d, digits = 4L) {
  d <- as.data.frame(d, stringsAsFactors = FALSE)
  for (j in names(d)) {
    v <- d[[j]]
    if (!is.numeric(v)) { d[[j]] <- ifelse(is.na(v), "", as.character(v)); next }
    if (j %in% c("p", "p_adjusted", "p_boundary")) {
      d[[j]] <- ifelse(is.na(v), ".", format.pval(v, digits = 3L, eps = 1e-4))
    } else if (j %in% c("num_df", "df_num")) {
      d[[j]] <- ifelse(is.na(v), ".", format(v))
    } else if (all(is.na(v) | abs(v - round(v)) < 1e-9)) {
      d[[j]] <- ifelse(is.na(v), ".", format(round(v), scientific = FALSE))
    } else {
      d[[j]] <- ifelse(is.na(v), ".", formatC(signif(v, digits), digits = digits, format = "fg", flag = "#"))
      d[[j]] <- sub("\\.$", "", d[[j]])
    }
  }
  d
}

.vlm_print_tab <- function(title, d, digits = 4L) {
  if (is.null(d) || !nrow(d)) return(invisible(NULL))
  cat("\n", title, "\n", sep = "")
  print(.vlm_fmt_table(d, digits), row.names = FALSE, right = TRUE)
  invisible(NULL)
}

.vlm_print_fit <- function(x, digits = 4L, ...) {
  m <- attr(x, "meta")
  eng <- attr(x, "engine")
  cat(sprintf("Linear mixed model: %s\n", attr(x, "label")))
  cat(sprintf("Estimation: %s; denominator df: %s; %s after %d iteration%s\n", m$method, m$ddfm,
              if (isTRUE(m$converged)) "converged" else "NOT converged", m$iterations,
              if (identical(m$iterations, 1L)) "" else "s"))
  if (is.environment(eng)) {
    sp <- eng$spec
    rnd <- vapply(sp$random, function(r) if (is.null(r$subject)) r$label else
      sprintf("%s (%s, subject %s)", paste(r$effects, collapse = " + "), toupper(r$kind), r$label), "")
    if (length(rnd)) cat("Random: ", paste(rnd, collapse = "; "), "\n", sep = "")
    if (sp$residual$type != "vc") cat(sprintf("Residual: %s, subject %s\n", toupper(sp$residual$type),
                                              sp$residual$label))
  }
  .vlm_print_tab("Covariance parameter estimates", x$covariance, digits)
  fs <- x$fit[c(1L, 2L, 3L, 4L)]
  .vlm_print_tab("Fit statistics", fs, digits + 2L)
  .vlm_print_tab("Solution for fixed effects", x$fixed, digits)
  .vlm_print_tab(sprintf("Type %d tests of fixed effects", if (is.environment(eng)) eng$type else 3L), x$tests,
                 digits)
}

.vlm_print_lsmeans <- function(x, digits = 4L, ...) {
  m <- attr(x, "meta")
  cat(sprintf("Least-squares means (denominator df: %s; %g%% limits)\n", m$ddfm, 100 * m$level))
  .vlm_print_tab("Least squares means", x$lsmeans, digits)
  if (!is.null(x$diffs)) {
    .vlm_print_tab(sprintf("Differences of least squares means (adjustment: %s)", m$adjust), x$diffs, digits)
  }
}

.vlm_print_estimate <- function(x, digits = 4L, ...) {
  cat(sprintf("Estimates (denominator df: %s)\n", attr(x, "meta")$ddfm))
  .vlm_print_tab("Estimates", x$estimates, digits)
}

.vlm_print_contrast <- function(x, digits = 4L, ...) {
  cat(sprintf("Contrasts (denominator df: %s)\n", attr(x, "meta")$ddfm))
  d <- data.table::copy(x$contrasts)
  if (all(!nzchar(d$note))) d[, note := NULL]
  .vlm_print_tab("Contrasts", d, digits)
}

.vlm_print_blup <- function(x, digits = 4L, ...) {
  cat("Best linear unbiased predictions of the random effects\n")
  d <- data.table::copy(x$blup)
  if (all(!nzchar(d$subject))) d[, subject := NULL]
  .vlm_print_tab("Solution for random effects", d, digits)
}

.vlm_print_ems <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n", sep = "")
  .vlm_print_tab("Analysis of variance", x$anova, digits)
  e <- x$error_terms[!is.na(x$error_terms$error)]
  .vlm_print_tab("Error terms of the tests", e, digits)
  if (nrow(x$components) > 1L) .vlm_print_tab("Type 3 estimates of the variance components", x$components, digits)
}

.vlm_print_compare <- function(x, digits = 4L, ...) {
  cat(sprintf("Comparison of %s\n", attr(x, "label")))
  .vlm_print_tab("Models", x$models, digits + 1L)
}

utils::globalVariables(c("note", "subject"))
