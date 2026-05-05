#' VetResearchLMM: Linear Mixed Models for Veterinary Research Examples
#'
#' @description
#' The \pkg{VetResearchLMM} package provides the datasets and reproducible R
#' examples that accompany Duchateau, Janssen, and Rowlands (1998),
#' \emph{Linear Mixed Models: An Introduction with Applications in Veterinary
#' Research}. The package is intended for readers who want to reproduce,
#' inspect, and adapt the linear mixed model examples from the book using
#' current R tooling.
#'
#' @details
#' The package focuses on small applied veterinary research examples involving
#' fixed effects, random effects, variance components, nested designs,
#' repeated measurements, and basic hypothesis tests for linear mixed models.
#' The package also includes \code{\link{report_mixed_model}()} and
#' \code{\link{emmeans_mixed_model}()}, small helpers that delegate fitted model
#' interpretation and post hoc marginal-mean inference to the optional
#' \pkg{report} and \pkg{emmeans} packages when they are installed. The main
#' user-facing data objects are the book datasets:
#' \describe{
#'   \item{\code{\link{ex121}}}{Dose comparison data for packed cell volume.}
#'   \item{\code{\link{ex124}}}{Herd, drug, and dose packed cell volume data.}
#'   \item{\code{\link{ex125}}}{Region, drug, and dose split-plot data.}
#'   \item{\code{\link{ex127}}}{Sire-level weaning weight data.}
#'   \item{\code{\link{ex31}}}{Designed experiment data for PCV response.}
#'   \item{\code{\link{ex32}}}{Breed, sire, sex, age, and weaning weight data.}
#'   \item{\code{\link{ex33}}}{Longitudinal PCV data by animal and breed.}
#' }
#'
#' The example help pages reproduce the corresponding analyses with modern R
#' packages such as \pkg{lme4}, \pkg{lmerTest}, \pkg{nlme}, \pkg{multcomp},
#' \pkg{collapse}, \pkg{ggplot2}, and \pkg{emmeans} where those packages are
#' available. Numerical results can differ slightly from the book because the
#' book reports SAS output and modern R packages use their own optimizers,
#' parameterizations, and degrees-of-freedom methods.
#'
#' A typical workflow is:
#' \enumerate{
#'   \item Load one of the included datasets with \code{data()}.
#'   \item Inspect the matching example help page, such as
#'     \code{?Examp2.4.2.2}.
#'   \item Fit the fixed effect or mixed model shown in the example.
#'   \item Compare estimates, variance components, and tests with the book.
#'   \item Use \code{\link{report_mixed_model}()} for an optional narrative
#'     model report when \pkg{report} is installed.
#'   \item Use \code{\link{emmeans_mixed_model}()} for optional estimated
#'     marginal means and post hoc comparisons when \pkg{emmeans} is installed.
#'   \item Use the package vignettes for chapter-level narrative examples.
#' }
#'
#' @section Affiliation:
#' School of Mathematical and Statistical Sciences, Clemson University, Clemson, South Carolina, USA.
#'
#' @section Vignettes:
#' The Quarto vignettes provide an introduction, methodology overview,
#' chapter/example walkthrough, and plotting guide:
#' \itemize{
#'   \item \code{vetresearchlmm-introduction}
#'   \item \code{vetresearchlmm-methodology}
#'   \item \code{vetresearchlmm-examples}
#'   \item \code{vetresearchlmm-plotting}
#' }
#'
#' @references
#' Duchateau, L., Janssen, P., and Rowlands, G. J. (1998).
#' \emph{Linear Mixed Models: An Introduction with Applications in Veterinary
#' Research}. International Livestock Research Institute.
#'
#' @author
#' Muhammad Yaseen \email{myaseen208@@gmail.com}
#'
#' @keywords package datasets
#'
"_PACKAGE"
