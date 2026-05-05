#' Report a Fitted Mixed Model
#'
#' @description
#' Create an easystats-style narrative report for a fitted linear mixed model.
#'
#' @param model A fitted model object, typically from \code{lme4::lmer()},
#'   \code{lmerTest::lmer()}, or \code{nlme::lme()}.
#' @param ... Additional arguments passed to \code{report::report()}.
#'
#' @return
#' A report object returned by \code{report::report()}.
#'
#' @details
#' This helper keeps the \pkg{report} package optional. It checks that a fitted
#' model was supplied, verifies that \pkg{report} is installed, and then
#' delegates the model interpretation to \code{report::report()}. This provides
#' a stable package-level entry point for readers who want easystats-style
#' interpretation of the fitted mixed models used throughout the book examples.
#'
#' The helper does not change the fitted model, refit the model, or alter any
#' estimates. It only formats and interprets the model object produced by the
#' modelling package.
#'
#' @examples
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("report", quietly = TRUE)) {
#'   data(ex127, package = "VetResearchLMM")
#'   fit <- lme4::lmer(Ww ~ 1 + (1 | sire), data = ex127, REML = TRUE)
#'   report_mixed_model(fit)
#' }
#'
#' @references
#' Duchateau, L., Janssen, P., and Rowlands, G. J. (1998).
#' \emph{Linear Mixed Models: An Introduction with Applications in Veterinary
#' Research}. International Livestock Research Institute.
#'
#' See \code{utils::citation("report")} for the citation for the optional
#' easystats reporting package.
#'
#' @seealso
#' \code{\link[lme4:lmer]{lme4::lmer}}, \code{\link[nlme:lme]{nlme::lme}}.
#'
#' @export
report_mixed_model <- function(model, ...) {
  if (missing(model) || is.null(model)) {
    stop("`model` must be a fitted model object.", call. = FALSE)
  }

  if (!requireNamespace("report", quietly = TRUE)) {
    stop(
      "The optional package `report` is required. Install it with install.packages(\"report\").",
      call. = FALSE
    )
  }

  report_fun <- getExportedValue("report", "report")
  report_fun(model, ...)
}
