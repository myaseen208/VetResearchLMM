#' @title    Examp2.5.4.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp2.5.4.1
#' @docType  data
#' @keywords datasets
#' @description Examp2.5.4.1 is used for inspecting probability distribution and to define a plausible process through
#' linear models and generalized linear models.
#' @author \enumerate{
#'          \item  Muhammad Yaseen (\email{myaseen208@@gmail.com})
#'          }
#' @references \enumerate{
#' \item Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}.
#'              International Livestock Research Institute.
#'  }
#' @seealso
#'    \code{\link{ex124}}
#' @examples
#' #-------------------------------------------------------------
#' ## Example 2.5.4.1 p-74
#' #-------------------------------------------------------------
#'  # PROC MIXED DATA=ex125;
#'  # CLASS drug dose region;
#'  # MODEL pcv=drug dose drug*dose / ddfm=satterth;
#'  # RANDOM region drug*region;
#'  # ESTIMATE 'Samorin mean' INTERCEPT 1 drug 0 1 dose 0.5 0.5
#'  #                             drug*dose 0 0 0.5 0.5;
#'  # RUN;
#'  
#'  # PROC GLM DATA=ex125;
#'  # CLASS drug dose region;
#'  # MODEL pcv=region drug region*drug dose drug*dose;
#'  # ESTIMATE 'Samorin mean' INTERCEPT 1 drug 0 1 dose 0.5 0.5
#'  #                             drug*dose 0 0 0.5 0.5;
#'  # RUN;
#'   
#' str(ex125)
#' ex125$Region1 <- factor(ex125$Region)
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm2.13 <-
#'     lmerTest::lmer(
#'            formula    = Pcv ~ dose * Drug + (1 | Region / Drug)
#'          , data       = ex125
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(dose = "contr.SAS", Drug = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm2.13 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     emm2.13 <- emmeans::emmeans(fm2.13, ~ dose | Drug, lmer.df = "asymptotic")
#'     print(emm2.13)
#'     print(emmeans::contrast(emm2.13, method = "pairwise"))
#'   }
#'   summary(fm2.13)
#'
#'   if (requireNamespace("multcomp", quietly = TRUE)) {
#'     Contrasts2 <-
#'       matrix(
#'         c(1, 0.5, 0, 0),
#'         ncol = 4,
#'         byrow = TRUE,
#'         dimnames = list(c("C5"), rownames(summary(fm2.13)$coef))
#'       )
#'     Contrasts2
#'     summary(multcomp::glht(fm2.13, linfct = Contrasts2))
#'   }
#' }
#'
NULL
