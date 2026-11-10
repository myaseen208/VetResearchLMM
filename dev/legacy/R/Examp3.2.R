#' @title    Examp3.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp3.2
#' @docType  data
#' @keywords datasets
#' @description Examp3.2 is used for inspecting probability distribution and to define a plausible process through
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
#' ## Example 3.3 p-88
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex32;
#' # CLASS sex sire_id breed;
#' # MODEL ww = sex agew breed/SOLUTION DDFM=SATTERTH;
#' # RANDOM sire_id(breed)/SOLUTION;
#' # LSMEANS breed/ADJUST = TUKEY;
#' # RUN;
#'
#' str(ex32)
#' ex32$sire_id1 <- factor(ex32$sire_id)
#' ex32$breed1   <- factor(ex32$breed)
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm3.4 <-
#'     lmerTest::lmer(
#'            formula    = Ww ~ sex + agew + breed1 + (1 | sire_id1:breed1)
#'          , data       = ex32
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(sex = "contr.SAS", breed1 = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.4 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     emm3.4 <- emmeans::emmeans(fm3.4, ~ breed1, lmer.df = "asymptotic")
#'     print(emm3.4)
#'     print(emmeans::contrast(emm3.4, method = "pairwise", adjust = "tukey"))
#'   }
#'   summary(fm3.4)
#'   anova(object = fm3.4, ddf = "Satterthwaite")
#' }
NULL
