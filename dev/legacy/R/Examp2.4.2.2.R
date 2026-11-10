#' @title    Examp2.4.2.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp2.4.2.2
#' @docType  data
#' @keywords datasets
#' @description Examp2.4.2.2 is used for inspecting probability distribution and to define a plausible process through
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
#' ## Example 2.4.2.2 p-64
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex125 METHOD=ML;
#' # CLASS drug dose region;
#' # MODEL pcv=drug dose drug*dose;
#' # RANDOM region drug*region;
#' # RUN;
#' # 
#' # PROC MIXED DATA=ex125 METHOD=REML;
#' # CLASS drug dose region;
#' # MODEL pcv=drug dose drug*dose;
#' # RANDOM region drug*region;
#' # RUN;
#'  
#'  
#' \donttest{
#' str(ex125)
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   fm2.4 <-
#'     lme4::lmer(
#'            formula    = Pcv ~ dose * Drug + (1 | Region / Drug)
#'          , data       = ex125
#'          , REML       = FALSE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = NULL
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm2.4 |>
#'       report::report()
#'   }
#'   summary(fm2.4)
#'   anova(fm2.4)
#'
#'   fm2.5 <-
#'     lme4::lmer(
#'            formula    = Pcv ~ dose * Drug + (1 | Region / Drug)
#'          , data       = ex125
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = NULL
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm2.5 |>
#'       report::report()
#'   }
#'   summary(fm2.5)
#'   anova(fm2.5)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm2.6 <-
#'     lmerTest::lmer(
#'            formula    = Pcv ~ dose * Drug + (1 | Region / Drug)
#'          , data       = ex125
#'          , REML       = FALSE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = NULL
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm2.6 |>
#'       report::report()
#'   }
#'   summary(fm2.6)
#'   anova(fm2.6)
#'
#'   fm2.7 <-
#'     lmerTest::lmer(
#'            formula    = Pcv ~ dose * Drug + (1 | Region / Drug)
#'          , data       = ex125
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = NULL
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm2.7 |>
#'       report::report()
#'   }
#'   summary(fm2.7)
#'   anova(fm2.7)
#' }
#' }
#'
NULL
