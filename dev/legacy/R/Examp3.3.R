#' @title    Examp3.3 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp3.3
#' @docType  data
#' @keywords datasets
#' @description Examp3.3 is used for inspecting probability distribution and to define a plausible process through
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
#' ## Example 3.3 Model 1 p-88
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex33;
#' # CLASS breed animal_id;
#' # MODEL pcv = breed breed*time/SOLUTION;
#' # RANDOM animal_id(breed)/SOLUTION;
#' # RUN;
#'
#' str(ex33)
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   fm3.5 <-
#'     lme4::lmer(
#'            formula    = PCV ~ breed + breed:time + (1 | animal_id:breed)
#'          , data       = ex33
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(breed = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.5 |>
#'       report::report()
#'   }
#'   summary(fm3.5)
#'   anova(fm3.5)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm3.6 <-
#'     lmerTest::lmer(
#'            formula    = PCV ~ breed + breed:time + (1 | animal_id:breed)
#'          , data       = ex33
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(breed = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.6 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     trend3.6 <- emmeans::emtrends(fm3.6, ~ breed, var = "time",
#'                                   lmer.df = "asymptotic")
#'     print(trend3.6)
#'     print(emmeans::contrast(trend3.6, method = "pairwise"))
#'   }
#'   summary(fm3.6)
#'   anova(object = fm3.6, ddf = "Satterthwaite")
#' }
#'
#' if (requireNamespace("nlme", quietly = TRUE)) {
#'   fm3.7 <-
#'     nlme::gls(
#'           model       = PCV ~ breed + breed:time
#'         , data        = ex33
#'         , correlation = nlme::corCompSymm(form = ~ 1 | animal_id / breed)
#'         , weights     = NULL
#'         , method      = "REML"
#'         , na.action   = na.fail
#'         , control     = list()
#'         )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     try(report::report(fm3.7), silent = TRUE)
#'   }
#'   summary(fm3.7)
#'   anova(fm3.7)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   fm3.8 <-
#'     lme4::lmer(
#'            formula    = PCV ~ time + breed + breed:time + (1 | animal_id:breed)
#'          , data       = ex33
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(breed = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.8 |>
#'       report::report()
#'   }
#'   summary(fm3.8)
#'   anova(fm3.8)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm3.9 <-
#'     lmerTest::lmer(
#'            formula    = PCV ~ time + breed + breed:time + (1 | animal_id:breed)
#'          , data       = ex33
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(breed = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.9 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     trend3.9 <- emmeans::emtrends(fm3.9, ~ breed, var = "time",
#'                                   lmer.df = "asymptotic")
#'     print(trend3.9)
#'     print(emmeans::contrast(trend3.9, method = "pairwise"))
#'   }
#'   summary(fm3.9)
#'   anova(object = fm3.9, ddf = "Satterthwaite", type = 3)
#' }
#'
#' if (requireNamespace("nlme", quietly = TRUE)) {
#'   fm3.10 <-
#'     nlme::gls(
#'           model       = PCV ~ breed + breed:time
#'         , data        = ex33
#'         , correlation = nlme::corAR1(form = ~ 1 | animal_id / breed)
#'         , weights     = NULL
#'         , method      = "REML"
#'         , na.action   = na.fail
#'         , control     = list()
#'         )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     try(report::report(fm3.10), silent = TRUE)
#'   }
#'   summary(fm3.10)
#'   anova(fm3.10)
#' }
#'
NULL
