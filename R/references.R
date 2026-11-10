#-------------------------------------------------------------------------------------------------------------------
# The sources of every method: one registry gives the short citation printed under each result, the references of
# the interpretations and the application, vlm_cite(), inst/CITATION and inst/REFERENCES.bib (written from it by
# tools/write-citation.R).
#-------------------------------------------------------------------------------------------------------------------

.vlm_ref <- function(key, short, text, ...) list(key = key, short = short, text = text, bib = utils::bibentry(key = key, ...))

.vlm_refs_list <- function() {
  p <- function(given, family) utils::person(given = given, family = family)
  refs <- list(
    .vlm_ref("Duchateau1998", "Duchateau, Janssen and Rowlands (1998)",
             paste("Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). Linear Mixed Models. An Introduction with",
                   "Applications in Veterinary Research. International Livestock Research Institute, Nairobi.",
                   "ISBN 92-9146-038-9."),
             bibtype = "Book",
             title = "Linear Mixed Models. An Introduction with Applications in Veterinary Research",
             author = c(p("Luc", "Duchateau"), p("Paul", "Janssen"), p(c("G.", "John"), "Rowlands")),
             publisher = "International Livestock Research Institute", address = "Nairobi", year = "1998",
             isbn = "92-9146-038-9"),
    .vlm_ref("Patterson1971", "Patterson and Thompson (1971)",
             paste("Patterson, H. D. and Thompson, R. (1971). Recovery of inter-block information when block sizes are",
                   "unequal. Biometrika, 58(3), 545-554. doi:10.1093/biomet/58.3.545"),
             bibtype = "Article", title = "Recovery of Inter-Block Information when Block Sizes are Unequal",
             author = c(p(c("H.", "D."), "Patterson"), p("Robin", "Thompson")), journal = "Biometrika",
             year = "1971", volume = "58", number = "3", pages = "545--554", doi = "10.1093/biomet/58.3.545"),
    .vlm_ref("Harville1977", "Harville (1977)",
             paste("Harville, D. A. (1977). Maximum likelihood approaches to variance component estimation and to",
                   "related problems. Journal of the American Statistical Association, 72(358), 320-338.",
                   "doi:10.1080/01621459.1977.10480998"),
             bibtype = "Article",
             title = "Maximum Likelihood Approaches to Variance Component Estimation and to Related Problems",
             author = p(c("David", "A."), "Harville"), journal = "Journal of the American Statistical Association",
             year = "1977", volume = "72", number = "358", pages = "320--338",
             doi = "10.1080/01621459.1977.10480998"),
    .vlm_ref("Gilmour1995", "Gilmour, Thompson and Cullis (1995)",
             paste("Gilmour, A. R., Thompson, R. and Cullis, B. R. (1995). Average information REML: an efficient",
                   "algorithm for variance parameter estimation in linear mixed models. Biometrics, 51(4), 1440-1450.",
                   "doi:10.2307/2533274"),
             bibtype = "Article",
             title = paste("Average Information {REML}: An Efficient Algorithm for Variance Parameter Estimation in",
                           "Linear Mixed Models"),
             author = c(p(c("Arthur", "R."), "Gilmour"), p("Robin", "Thompson"), p(c("Brian", "R."), "Cullis")),
             journal = "Biometrics", year = "1995", volume = "51", number = "4", pages = "1440--1450",
             doi = "10.2307/2533274"),
    .vlm_ref("Littell1996", "Littell, Milliken, Stroup and Wolfinger (1996)",
             paste("Littell, R. C., Milliken, G. A., Stroup, W. W. and Wolfinger, R. D. (1996). SAS System for Mixed",
                   "Models. SAS Institute, Cary, NC."),
             bibtype = "Book", title = "{SAS} System for Mixed Models",
             author = c(p(c("Ramon", "C."), "Littell"), p(c("George", "A."), "Milliken"), p(c("Walter", "W."), "Stroup"),
                        p(c("Russell", "D."), "Wolfinger")),
             publisher = "SAS Institute", address = "Cary, NC", year = "1996"),
    .vlm_ref("Satterthwaite1946", "Satterthwaite (1946)",
             paste("Satterthwaite, F. E. (1946). An approximate distribution of estimates of variance components.",
                   "Biometrics Bulletin, 2(6), 110-114. doi:10.2307/3002019"),
             bibtype = "Article", title = "An Approximate Distribution of Estimates of Variance Components",
             author = p(c("F.", "E."), "Satterthwaite"), journal = "Biometrics Bulletin", year = "1946",
             volume = "2", number = "6", pages = "110--114", doi = "10.2307/3002019"),
    .vlm_ref("Giesbrecht1985", "Giesbrecht and Burns (1985)",
             paste("Giesbrecht, F. G. and Burns, J. C. (1985). Two-stage analysis based on a mixed model: large-sample",
                   "asymptotic theory and small-sample simulation results. Biometrics, 41(2), 477-486.",
                   "doi:10.2307/2530872"),
             bibtype = "Article",
             title = paste("Two-Stage Analysis Based on a Mixed Model: Large-Sample Asymptotic Theory and Small-Sample",
                           "Simulation Results"),
             author = c(p(c("Francis", "G."), "Giesbrecht"), p(c("Joseph", "C."), "Burns")), journal = "Biometrics",
             year = "1985", volume = "41", number = "2", pages = "477--486", doi = "10.2307/2530872"),
    .vlm_ref("Fai1996", "Fai and Cornelius (1996)",
             paste("Fai, A. H.-T. and Cornelius, P. L. (1996). Approximate F-tests of multiple degree of freedom",
                   "hypotheses in generalized least squares analyses of unbalanced split-plot experiments. Journal of",
                   "Statistical Computation and Simulation, 54(4), 363-378. doi:10.1080/00949659608811740"),
             bibtype = "Article",
             title = paste("Approximate F-Tests of Multiple Degree of Freedom Hypotheses in Generalized Least Squares",
                           "Analyses of Unbalanced Split-Plot Experiments"),
             author = c(p(c("Alex", "Hrong-Tai"), "Fai"), p(c("Paul", "L."), "Cornelius")),
             journal = "Journal of Statistical Computation and Simulation", year = "1996", volume = "54",
             number = "4", pages = "363--378", doi = "10.1080/00949659608811740"),
    .vlm_ref("Kenward1997", "Kenward and Roger (1997)",
             paste("Kenward, M. G. and Roger, J. H. (1997). Small sample inference for fixed effects from restricted",
                   "maximum likelihood. Biometrics, 53(3), 983-997. doi:10.2307/2533558"),
             bibtype = "Article", title = "Small Sample Inference for Fixed Effects from Restricted Maximum Likelihood",
             author = c(p(c("Michael", "G."), "Kenward"), p(c("James", "H."), "Roger")), journal = "Biometrics",
             year = "1997", volume = "53", number = "3", pages = "983--997", doi = "10.2307/2533558"),
    .vlm_ref("Henderson1975", "Henderson (1975)",
             paste("Henderson, C. R. (1975). Best linear unbiased estimation and prediction under a selection model.",
                   "Biometrics, 31(2), 423-447. doi:10.2307/2529430"),
             bibtype = "Article", title = "Best Linear Unbiased Estimation and Prediction under a Selection Model",
             author = p(c("Charles", "R."), "Henderson"), journal = "Biometrics", year = "1975", volume = "31",
             number = "2", pages = "423--447", doi = "10.2307/2529430"),
    .vlm_ref("McLean1991", "McLean, Sanders and Stroup (1991)",
             paste("McLean, R. A., Sanders, W. L. and Stroup, W. W. (1991). A unified approach to mixed linear models.",
                   "The American Statistician, 45(1), 54-64. doi:10.1080/00031305.1991.10475767"),
             bibtype = "Article", title = "A Unified Approach to Mixed Linear Models",
             author = c(p(c("Robert", "A."), "McLean"), p(c("William", "L."), "Sanders"), p(c("Walter", "W."), "Stroup")),
             journal = "The American Statistician", year = "1991", volume = "45", number = "1", pages = "54--64",
             doi = "10.1080/00031305.1991.10475767"),
    .vlm_ref("Searle1980", "Searle, Speed and Milliken (1980)",
             paste("Searle, S. R., Speed, F. M. and Milliken, G. A. (1980). Population marginal means in the linear",
                   "model: an alternative to least squares means. The American Statistician, 34(4), 216-221.",
                   "doi:10.1080/00031305.1980.10483031"),
             bibtype = "Article",
             title = "Population Marginal Means in the Linear Model: An Alternative to Least Squares Means",
             author = c(p(c("Shayle", "R."), "Searle"), p(c("F.", "M."), "Speed"), p(c("George", "A."), "Milliken")),
             journal = "The American Statistician", year = "1980", volume = "34", number = "4", pages = "216--221",
             doi = "10.1080/00031305.1980.10483031"),
    .vlm_ref("Kramer1956", "Kramer (1956)",
             paste("Kramer, C. Y. (1956). Extension of multiple range tests to group means with unequal numbers of",
                   "replications. Biometrics, 12(3), 307-310. doi:10.2307/3001469"),
             bibtype = "Article",
             title = "Extension of Multiple Range Tests to Group Means with Unequal Numbers of Replications",
             author = p(c("Clyde", "Young"), "Kramer"), journal = "Biometrics", year = "1956", volume = "12",
             number = "3", pages = "307--310", doi = "10.2307/3001469"),
    .vlm_ref("Searle1992", "Searle, Casella and McCulloch (1992)",
             "Searle, S. R., Casella, G. and McCulloch, C. E. (1992). Variance Components. Wiley, New York.",
             bibtype = "Book", title = "Variance Components",
             author = c(p(c("Shayle", "R."), "Searle"), p("George", "Casella"), p(c("Charles", "E."), "McCulloch")),
             publisher = "Wiley", address = "New York", year = "1992"),
    .vlm_ref("Akaike1974", "Akaike (1974)",
             paste("Akaike, H. (1974). A new look at the statistical model identification. IEEE Transactions on",
                   "Automatic Control, 19(6), 716-723. doi:10.1109/TAC.1974.1100705"),
             bibtype = "Article", title = "A New Look at the Statistical Model Identification",
             author = p("Hirotugu", "Akaike"), journal = "IEEE Transactions on Automatic Control", year = "1974",
             volume = "19", number = "6", pages = "716--723", doi = "10.1109/TAC.1974.1100705"),
    .vlm_ref("Schwarz1978", "Schwarz (1978)",
             paste("Schwarz, G. (1978). Estimating the dimension of a model. The Annals of Statistics, 6(2), 461-464.",
                   "doi:10.1214/aos/1176344136"),
             bibtype = "Article", title = "Estimating the Dimension of a Model", author = p("Gideon", "Schwarz"),
             journal = "The Annals of Statistics", year = "1978", volume = "6", number = "2", pages = "461--464",
             doi = "10.1214/aos/1176344136")
  )
  stats::setNames(refs, vapply(refs, `[[`, "", "key"))
}

.vlm_sources_of <- function(x) {
  m <- attr(x, "meta")
  dd <- function(ddfm) switch(ddfm %||% "", satterth = c("Satterthwaite1946", "Giesbrecht1985", "Fai1996"),
                               kr = "Kenward1997", character(0))
  switch(.vlm_cls(x),
    fit = c("Duchateau1998", if (identical(m$method, "Type3")) "Searle1992" else c("Patterson1971", "Gilmour1995"),
            "Littell1996", dd(m$ddfm)),
    lsmeans = c("Duchateau1998", "Searle1980", if (identical(m$adjust, "tukey")) "Kramer1956", dd(m$ddfm)),
    estimate = , contrast = c("Duchateau1998", "McLean1991", dd(m$ddfm)),
    blup = c("Duchateau1998", "Henderson1975"),
    ems = c("Duchateau1998", "Searle1992", "Satterthwaite1946"),
    compare = c("Duchateau1998", "Akaike1974", "Schwarz1978"),
    character(0))
}

`%||%` <- function(a, b) if (is.null(a)) b else a

.vlm_sources_line <- function(x) {
  k <- unique(.vlm_sources_of(x))
  if (!length(k)) return(invisible(NULL))
  r <- .vlm_refs_list()[k]
  txt <- strwrap(paste0("Sources: ", paste(vapply(r, `[[`, "", "short"), collapse = "; "),
                        ". Full references: vlm_cite(x)."), width = getOption("width", 80L))
  cat("\n", paste(txt, collapse = "\n"), "\n", sep = "")
  invisible(NULL)
}

#' References of a result or of the package
#'
#' @description
#' \code{vlm_cite()} gives the references of the methods behind a result of the package, or every reference of the
#' package, as text or BibTeX. \code{citation("VetResearchLMM")} cites the package and the book.
#'
#' @param x a result of a function of the package, or \code{NULL} (default) for every reference.
#' @param style \code{"text"} (default) or \code{"bibtex"}.
#' @return An object of class \code{bibentry} (printed in the chosen style).
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @family VetResearchLMM utilities
#' @examples
#' vlm_cite(
#'     x     = NULL
#'   , style = "text"
#'   )
#' @export
vlm_cite <- function(x = NULL, style = c("text", "bibtex")) UseMethod("vlm_cite")

#' @rdname vlm_cite
#' @export
vlm_cite.default <- function(x = NULL, style = c("text", "bibtex")) {
  style <- .vlm_check_choice(style[1L], c("text", "bibtex"), "style", "vlm_cite")
  refs <- .vlm_refs_list()
  keys <- if (is.null(x)) names(refs) else {
    if (!inherits(x, "vlm_result")) .vlm_stop("vlm_cite", "`x` must be a result of the package or NULL.")
    unique(.vlm_sources_of(x))
  }
  out <- do.call(c, lapply(refs[keys], `[[`, "bib"))
  structure(out, vlm_style = style, class = c("vlm_cite", class(out)))
}

#' @export
print.vlm_cite <- function(x, ...) {
  y <- x
  class(y) <- setdiff(class(y), "vlm_cite")
  if (!length(y)) {
    cat("No references.\n")
    return(invisible(x))
  }
  if (identical(attr(x, "vlm_style"), "bibtex")) print(y, style = "Bibtex") else {
    refs <- .vlm_refs_list()
    keys <- vapply(unclass(y), function(e) attr(e, "key"), "")
    cat(paste(vapply(refs[keys], `[[`, "", "text"), collapse = "\n\n"), "\n")
  }
  invisible(x)
}
