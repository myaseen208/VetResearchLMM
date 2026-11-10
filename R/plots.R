#-------------------------------------------------------------------------------------------------------------------
# plot() of the results (dispatched by plot.vlm_result of common-objects.R)
#-------------------------------------------------------------------------------------------------------------------

# residuals, fitted values and the data of a fit
.vlm_fit_data <- function(eng) {
  sp <- eng$spec
  XS <- sp$Xo[, sp$So, drop = FALSE]
  b <- .vlm_coords(eng, "o")$bS
  marg <- as.numeric(XS %*% b)
  mme <- .vlm_mme(eng)
  cond <- if (is.null(mme)) marg else marg + as.numeric(mme$Z %*% mme$u)
  data.table::data.table(observed = sp$y, marginal = marg, conditional = cond, residual = sp$y - cond,
                         marginal_residual = sp$y - marg)
}

.vlm_plot_fit <- function(x, which = c("residuals", "qq", "observed"), ...) {
  which <- match.arg(which)
  eng <- .vlm_engine(x, "plot")
  d <- .vlm_fit_data(eng)
  r <- d$residual
  d[, std := r / stats::sd(r)]
  g <- switch(which
    , residuals = ggplot2::ggplot(d, ggplot2::aes(x = .data$conditional, y = .data$residual)) +
        ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "grey40") +
        ggplot2::geom_point(colour = .vlm_palette[1L], alpha = 0.8) +
        ggplot2::labs(x = "Fitted value (fixed + random effects)", y = "Conditional residual",
                      title = "Residuals against fitted values")
    , qq = ggplot2::ggplot(d, ggplot2::aes(sample = .data$std)) +
        ggplot2::stat_qq(colour = .vlm_palette[1L]) +
        ggplot2::stat_qq_line(colour = .vlm_palette[2L]) +
        ggplot2::labs(x = "Normal quantile", y = "Standardised conditional residual",
                      title = "Normal quantile plot of the residuals")
    , observed = ggplot2::ggplot(d, ggplot2::aes(x = .data$conditional, y = .data$observed)) +
        ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed", colour = "grey40") +
        ggplot2::geom_point(colour = .vlm_palette[1L], alpha = 0.8) +
        ggplot2::labs(x = "Fitted value (fixed + random effects)", y = paste("Observed", eng$spec$yname),
                      title = "Observed against fitted values")
    )
  g + vlm_theme()
}

.vlm_plot_lsmeans <- function(x, ...) {
  d <- data.table::copy(x$lsmeans)[!is.na(estimate)]
  vars <- setdiff(names(d), c("estimate", "se", "df", "t", "p", "lower", "upper"))
  d[, level := do.call(paste, .SD), .SDcols = vars]
  d[, level := factor(level, levels = level)]
  ggplot2::ggplot(d, ggplot2::aes(x = .data$level, y = .data$estimate)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = .data$lower, ymax = .data$upper), width = 0.15,
                           colour = .vlm_palette[1L]) +
    ggplot2::geom_point(size = 2.5, colour = .vlm_palette[1L]) +
    ggplot2::labs(x = paste(vars, collapse = " x "), y = "Least-squares mean",
                  title = "Least-squares means with confidence limits") +
    vlm_theme()
}

.vlm_plot_blup <- function(x, ...) {
  d <- data.table::copy(x$blup)
  d[, label := trimws(paste(effect, level))]
  d[, label := factor(label, levels = label[order(estimate)])]
  ggplot2::ggplot(d, ggplot2::aes(x = .data$estimate, y = .data$label)) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
    ggplot2::geom_errorbarh(ggplot2::aes(xmin = .data$lower, xmax = .data$upper), height = 0.2,
                            colour = .vlm_palette[1L]) +
    ggplot2::geom_point(size = 2, colour = .vlm_palette[1L]) +
    ggplot2::labs(x = "Prediction with limits", y = NULL, title = "Best linear unbiased predictions") +
    vlm_theme()
}

.vlm_plot_estimate <- function(x, ...) {
  d <- data.table::copy(x$estimates)[!is.na(estimate)]
  d[, label := factor(label, levels = rev(label))]
  ggplot2::ggplot(d, ggplot2::aes(x = .data$estimate, y = .data$label, colour = .data$space)) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", colour = "grey40") +
    ggplot2::geom_errorbarh(ggplot2::aes(xmin = .data$lower, xmax = .data$upper), height = 0.2) +
    ggplot2::geom_point(size = 2) +
    ggplot2::scale_colour_manual(values = c(broad = .vlm_palette[1L], narrow = .vlm_palette[2L], fixed = .vlm_palette[3L]),
                                 name = "Inference space") +
    ggplot2::labs(x = "Estimate with confidence limits", y = NULL, title = "Estimates") +
    vlm_theme()
}

.vlm_plot_compare <- function(x, ...) {
  d <- data.table::melt(x$models[, c("model", "AIC", "AICC", "BIC")], id.vars = "model", variable.name = "criterion",
                        value.name = "value")
  d[, model := factor(model, levels = x$models$model)]
  ggplot2::ggplot(d, ggplot2::aes(x = .data$model, y = .data$value, colour = .data$criterion,
                                  group = .data$criterion)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(size = 2.5) +
    ggplot2::scale_colour_manual(values = .vlm_palette[1:3], name = NULL) +
    ggplot2::labs(x = NULL, y = "Information criterion (smaller is better)", title = "Model comparison") +
    vlm_theme()
}

#' Plot a result
#'
#' @description \code{autoplot()} methods for the results of \pkg{VetResearchLMM}; \code{plot()} draws the same
#' figures. A fit shows its residuals (\code{which = "residuals"}, \code{"qq"} or \code{"observed"}); least-squares
#' means and estimates show their confidence limits; predictions of random effects are drawn as a caterpillar plot;
#' a comparison shows the information criteria.
#' @param object a result of a function of the package.
#' @param which for \code{\link{vlm_fit}()} results, \code{"residuals"} (default), \code{"qq"} or
#'   \code{"observed"}.
#' @param ... not used.
#' @return A \code{ggplot} object.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family VetResearchLMM utilities
#' @examples
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
#' ggplot2::autoplot(
#'     object = vlm_blup(
#'         fit   = fs
#'       , level = 0.95
#'       )
#'   )
#' @rawNamespace S3method(ggplot2::autoplot, vlm_result)
autoplot.vlm_result <- function(object, which = NULL, ...) {
  if (is.null(which)) plot(object, ...) else plot(object, which = which, ...)
}

utils::globalVariables(c("std", "level", "label", "model", "criterion", ".SD"))
