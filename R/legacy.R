#' Estimated marginal means for a fitted mixed model
#'
#' @description
#' Computes estimated marginal means, or pairwise comparisons of them, for a fitted linear mixed model. For a model
#' fitted by \code{lme4::lmer()}, \code{lmerTest::lmer()} or \code{nlme::lme()} the optional package \pkg{emmeans}
#' does the work, as in version 1.1.0; for a result of \code{\link{vlm_fit}()} the least-squares means of
#' \code{\link{vlm_lsmeans}()} are returned.
#'
#' @details
#' Estimated marginal means (least-squares means) average the model predictions over the levels of the other
#' factors with equal weights. For a \code{vlm_fit} result, \code{specs} gives the effect (for example
#' \code{~ dose | Drug} or \code{~ Drug:dose}); \code{pairwise = TRUE} adds all pairwise differences with the
#' adjustment \code{adjust} (\code{"tukey"}, \code{"bonferroni"}, \code{"sidak"} or \code{"none"}).
#'
#' @param model a fitted model: a result of \code{\link{vlm_fit}()}, or a model from \code{lme4::lmer()},
#'   \code{lmerTest::lmer()} or \code{nlme::lme()}.
#' @param specs specifications of the marginal means, such as \code{~ dose} or \code{~ dose | Drug}.
#' @param pairwise logical; \code{FALSE} returns the means, \code{TRUE} the contrasts (pairwise differences).
#' @param method contrast method passed to \code{emmeans::contrast()} (default \code{"pairwise"}); a
#'   \code{vlm_fit} result always uses pairwise differences.
#' @param adjust multiplicity adjustment (default \code{"tukey"}; \code{NULL} leaves it to \pkg{emmeans}).
#' @param ... further arguments passed to \code{emmeans::emmeans()}.
#' @return For a \code{vlm_fit} result, a \code{vlm_lsmeans} result (see \code{\link{vlm_lsmeans}()}); otherwise an
#'   \code{emmGrid} object of \pkg{emmeans}.
#' @references
#' Lenth, R. V. (2024). \emph{emmeans: Estimated Marginal Means, aka Least-Squares Means}. R package.
#'
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_lsmeans}}, \code{\link{report_mixed_model}}
#' @family VetResearchLMM inference
#' @examples
#' fm <-
#'   vlm_fit(
#'       fixed    = Pcv ~ Drug + dose + Drug:dose
#'     , data     = ex125
#'     , random   = ~ Region + Region:Drug
#'     , repeated = NULL
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' emmeans_mixed_model(
#'     model    = fm
#'   , specs    = ~ dose | Drug
#'   , pairwise = TRUE
#'   , method   = "pairwise"
#'   , adjust   = "tukey"
#'   )
#' @export
emmeans_mixed_model <- function(model, specs, pairwise = FALSE, method = "pairwise", adjust = "tukey", ...) {
  UseMethod("emmeans_mixed_model")
}

#' @rdname emmeans_mixed_model
#' @export
emmeans_mixed_model.default <- function(model, specs, pairwise = FALSE, method = "pairwise", adjust = "tukey", ...) {
  if (missing(model) || is.null(model)) stop("`model` must be a fitted model object.", call. = FALSE)
  if (missing(specs) || is.null(specs)) stop("`specs` must be supplied.", call. = FALSE)
  if (!is.logical(pairwise) || length(pairwise) != 1L || is.na(pairwise)) {
    stop("`pairwise` must be a single TRUE or FALSE value.", call. = FALSE)
  }
  if (!requireNamespace("emmeans", quietly = TRUE)) {
    stop("The optional package `emmeans` is required. Install it with install.packages(\"emmeans\").",
         call. = FALSE)
  }
  emmeans_fun <- getExportedValue("emmeans", "emmeans")
  emm <- emmeans_fun(model, specs = specs, ...)
  if (!pairwise) return(emm)
  contrast_fun <- getExportedValue("emmeans", "contrast")
  contrast_args <- list(object = emm, method = method)
  if (!is.null(adjust)) contrast_args$adjust <- adjust
  do.call(contrast_fun, contrast_args)
}

#' @rdname emmeans_mixed_model
#' @export
emmeans_mixed_model.vlm_fit <- function(model, specs, pairwise = FALSE, method = "pairwise", adjust = "tukey", ...) {
  if (missing(specs) || is.null(specs)) stop("`specs` must be supplied.", call. = FALSE)
  if (!is.logical(pairwise) || length(pairwise) != 1L || is.na(pairwise)) {
    stop("`pairwise` must be a single TRUE or FALSE value.", call. = FALSE)
  }
  adj <- if (is.null(adjust)) "none" else adjust
  vlm_lsmeans(fit = model, specs = specs, diff = pairwise, adjust = adj)
}

#' Report a fitted mixed model
#'
#' @description
#' Gives a narrative report of a fitted model. For a result of \code{\link{vlm_fit}()} it is the plain-language
#' interpretation of \code{\link{vlm_interpret}()}; for other models the optional package \pkg{report} writes the
#' report, as in version 1.1.0.
#'
#' @param model a fitted model: a result of \code{\link{vlm_fit}()} or a model supported by \pkg{report}.
#' @param ... further arguments passed to \code{report::report()} or to \code{\link{vlm_interpret}()}.
#' @return A \code{vlm_interpretation} object for a \code{vlm_fit} result; otherwise the object returned by
#'   \code{report::report()}.
#' @references
#' Makowski, D., Ben-Shachar, M. S., Patil, I. and Luedecke, D. (2023). Automated results reporting as a practical
#' tool to improve reproducibility and methodological best practices adoption. R package \pkg{report}.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_interpret}}, \code{\link{emmeans_mixed_model}}
#' @family VetResearchLMM inference
#' @examples
#' fm <-
#'   vlm_fit(
#'       fixed    = Pcv ~ Drug + dose + Drug:dose
#'     , data     = ex125
#'     , random   = ~ Region + Region:Drug
#'     , repeated = NULL
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' report_mixed_model(
#'     model = fm
#'   )
#' @export
report_mixed_model <- function(model, ...) UseMethod("report_mixed_model")

#' @rdname report_mixed_model
#' @export
report_mixed_model.default <- function(model, ...) {
  if (missing(model) || is.null(model)) stop("`model` must be a fitted model object.", call. = FALSE)
  if (!requireNamespace("report", quietly = TRUE)) {
    stop("The optional package `report` is required. Install it with install.packages(\"report\").", call. = FALSE)
  }
  report_fun <- getExportedValue("report", "report")
  report_fun(model, ...)
}

#' @rdname report_mixed_model
#' @export
report_mixed_model.vlm_fit <- function(model, ...) vlm_interpret(model, ...)
