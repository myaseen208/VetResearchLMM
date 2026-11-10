#' Compare fitted models
#'
#' @description
#' Compares several fits of \code{\link{vlm_fit}()} by their (restricted) log-likelihoods and information criteria,
#' and tests each model against the one before it by a likelihood ratio test: the comparison of covariance
#' structures of Example 3.3 of the book (compound symmetry, first-order autoregressive, random coefficients).
#'
#' @details
#' With \eqn{\ell} the maximised (restricted) log-likelihood and \eqn{d} the number of covariance parameters (plus
#' the rank of \eqn{\mathbf{X}} for ML), \eqn{AIC = -2\ell + 2d}, \eqn{AICC = -2\ell + 2dn^*/(n^* - d - 1)} and
#' \eqn{BIC = -2\ell + d\log s}, where \eqn{n^* = N - \mathrm{rank}(\mathbf{X})} for REML (\eqn{N} for ML) and
#' \eqn{s} is the number of subjects. The likelihood ratio statistic of two nested models is
#' \eqn{-2(\ell_0 - \ell_1)}, referred to \eqn{\chi^2_{d_1 - d_0}}; when the larger model adds one variance
#' component, the null value lies on the boundary and \code{p_boundary} gives the p-value of the 50:50 mixture of
#' \eqn{\chi^2_0} and \eqn{\chi^2_1} (Self and Liang 1987). REML likelihoods are comparable only between models with
#' the same fixed effects; the test is then left out.
#'
#' @param ... two or more results of \code{\link{vlm_fit}()}, optionally named.
#' @param test logical; add likelihood ratio tests of each model against the previous one (default \code{TRUE}).
#' @return A list of class \code{c("vlm_compare", "vlm_result", "list")} with \code{models} (one row per model:
#'   method, number of covariance parameters, -2 log-likelihood, AIC, AICC, BIC and the test against the previous
#'   model).
#' @references
#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Section 3.4.
#'
#' Self, S. G. and Liang, K.-Y. (1987). Asymptotic properties of maximum likelihood estimators and likelihood ratio
#' tests under nonstandard conditions. \emph{Journal of the American Statistical Association}, 82, 605-610.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}
#' @family VetResearchLMM models
#' @examples
#' cs <-
#'   vlm_fit(
#'       fixed    = PCV ~ breed + breed:time
#'     , data     = ex33
#'     , random   = NULL
#'     , repeated = vlm_repeated(
#'           type    = c("vc", "cs", "ar1", "sp_pow", "un")[2]
#'         , subject = ~ animal_id:breed
#'         , order   = NULL
#'         )
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' ar <-
#'   vlm_fit(
#'       fixed    = PCV ~ breed + breed:time
#'     , data     = ex33
#'     , random   = NULL
#'     , repeated = vlm_repeated(
#'           type    = c("vc", "cs", "ar1", "sp_pow", "un")[3]
#'         , subject = ~ animal_id:breed
#'         , order   = NULL
#'         )
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' rc <-
#'   vlm_fit(
#'       fixed    = PCV ~ breed + breed:time
#'     , data     = ex33
#'     , random   = vlm_random(
#'           effects = ~ 1 + time
#'         , subject = ~ animal_id:breed
#'         , type    = c("vc", "un")[2]
#'         )
#'     , repeated = NULL
#'     , method   = "REML"
#'     , ddfm     = "default"
#'     , type     = 3
#'     , class    = NULL
#'     , bound    = TRUE
#'     , control  = list()
#'     )
#' vlm_compare(
#'     CS   = cs
#'   , AR1  = ar
#'   , RC   = rc
#'   , test = TRUE
#'   )
#' @export
vlm_compare <- function(..., test = TRUE) UseMethod("vlm_compare")

#' @rdname vlm_compare
#' @export
vlm_compare.default <- function(..., test = TRUE) {
  fn <- "vlm_compare"
  fits <- list(...)
  .vlm_check_flag(test, "test", fn)
  if (length(fits) < 2L) .vlm_stop(fn, "give at least two fits of vlm_fit().")
  if (!all(vapply(fits, inherits, logical(1), "vlm_fit"))) .vlm_stop(fn, "every model must be a result of vlm_fit().")
  nm <- names(fits)
  if (is.null(nm)) nm <- rep("", length(fits))
  nm[!nzchar(nm)] <- paste0("model", which(!nzchar(nm)))
  engs <- lapply(fits, attr, "engine")
  methods <- vapply(engs, `[[`, "", "method")
  if (any(methods == "Type3")) .vlm_stop(fn, "models fitted by method \"Type3\" have no likelihood.")
  if (length(unique(methods)) > 1L) .vlm_stop(fn, "every model must use the same method (REML or ML).")
  stat <- function(f, s) f$fit$value[match(s, f$fit$statistic)]
  lab <- if (methods[1L] == "REML") "Res " else ""
  m2ll <- vapply(fits, stat, 1, s = paste0("-2 ", lab, "Log Likelihood"))
  d <- vapply(engs, function(e) length(e$theta) - sum(!e$active), 1)
  fx <- vapply(engs, function(e) paste(sort(colnames(e$spec$Xo)), collapse = "|"), "")
  ys <- vapply(engs, function(e) paste(e$spec$yname, e$spec$n), "")
  if (length(unique(ys)) > 1L) .vlm_stop(fn, "the models must have the same response and observations.")
  tab <- data.table::data.table(
      model      = nm
    , method     = methods
    , cov_parms  = d
    , m2ll       = m2ll
    , AIC        = vapply(fits, stat, 1, s = "AIC (smaller is better)")
    , AICC       = vapply(fits, stat, 1, s = "AICC (smaller is better)")
    , BIC        = vapply(fits, stat, 1, s = "BIC (smaller is better)")
    , chisq      = NA_real_
    , df         = NA_real_
    , p          = NA_real_
    , p_boundary = NA_real_
    )
  if (test) {
    for (i in 2:length(fits)) {
      if (methods[1L] == "REML" && fx[i] != fx[i - 1L]) next
      ddf <- abs(d[i] - d[i - 1L])
      if (ddf == 0) next
      ch <- abs(m2ll[i - 1L] - m2ll[i])
      p <- stats::pchisq(ch, ddf, lower.tail = FALSE)
      data.table::set(tab, i, c("chisq", "df", "p", "p_boundary"), list(ch, ddf, p, if (ddf == 1) p / 2 else NA_real_))
    }
  }
  best <- nm[which.min(tab$AIC)]
  .vlm_result(list(models = tab), "compare", label = sprintf("%d models; smallest AIC: %s", length(fits), best),
              call = match.call(), meta = list(method = methods[1L]))
}
