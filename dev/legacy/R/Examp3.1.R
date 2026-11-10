#' @title    Examp3.1 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp3.1
#' @docType  data
#' @keywords datasets
#' @description Examp3.1 is.
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
#' ## Example 3.1 Model 1 p-80
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex31;
#' # CLASS drug dose herd;
#' # MODEL PCV2=drug dose(drug)/solution ddfm=satterth;
#' # RANDOM herd(drug);
#' # ESTIMATE 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;
#' # ESTIMATE 'Berenil 2 doses' dose(drug) 1 -1 0;
#' # ESTIMATE 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -1;
#' # CONTRAST 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;
#' # CONTRAST 'Berenil dif 2 doses' dose(drug) 1 -1 0;
#' # CONTRAST 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -l;
#' # CONTRAST 'some difference' drug 1 -1 dose(drug) 0.5 0.5 -1,
#' #           drug 0 0 dose(drug) 1 -1 0;
#' # LSMEANS dose(drug);
#' # RUN;
#'
#' str(ex31)
#' ex31$herd1 <- factor(ex31$herd)
#' ex31$drug1 <- factor(ex31$drug)
#' ex31$dose1 <- factor(ex31$dose)
#' ex31$ber   <- as.integer(ex31$drug == "BERENIL")
#' ex31$ber1  <- as.integer(ex31$drug == "BERENIL" & ex31$dose == 1L)
#' ex31$pcv_ber1 <- ex31$PCV1 * as.integer(ex31$drug == "BERENIL" & ex31$dose == 1L)
#' ex31$pcv_ber2 <- ex31$PCV1 * as.integer(ex31$drug == "BERENIL" & ex31$dose == 2L)
#'
#' if (requireNamespace("lme4", quietly = TRUE) &&
#'     requireNamespace("lmerTest", quietly = TRUE)) {
#'   fm3.1 <-
#'     lmerTest::lmer(
#'            formula    = PCV2 ~ drug1 + dose1:drug1 + (1 | herd1:drug1)
#'          , data       = ex31
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.1 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     emm3.1 <- emmeans::emmeans(fm3.1, ~ dose1 | drug1, lmer.df = "asymptotic")
#'     print(emm3.1)
#'     print(emmeans::contrast(emm3.1, method = "pairwise"))
#'   }
#'   summary(fm3.1)
#'   anova(object = fm3.1, ddf = "Satterthwaite")
#'
#' #-------------------------------------------------------------
#' ## Example 3.1 Model 2 p-84
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex31;
#' # CLASS drug dose herd;
#' # MODEL PCV2=PCV1 drug dose(drug)/solution ddfm=satterth;
#' # RANDOM herd(drug);
#' # RUN;
#'
#'   fm3.2 <-
#'     lmerTest::lmer(
#'            formula    = PCV2 ~ PCV1 + drug1 + dose1:drug1 + (1 | herd1:drug1)
#'          , data       = ex31
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.2 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     emm3.2 <- emmeans::emmeans(fm3.2, ~ dose1 | drug1, lmer.df = "asymptotic")
#'     print(emm3.2)
#'     print(emmeans::contrast(emm3.2, method = "pairwise"))
#'   }
#'   summary(fm3.2)
#'   anova(object = fm3.2, ddf = "Satterthwaite")
#'
#' #-------------------------------------------------------------
#' ## Example 3.1 Model 3 p-86
#' #-------------------------------------------------------------
#' # PROC MIXED DATA=ex31;
#' # CLASS drug dose herd;
#' # MODEL PCV2=drug dose(drug) PCV1*dose(drug)/solution ddfm=satterth;
#' # RANDOM herd(drug);
#' # RUN;
#'
#'   fm3.3 <-
#'     lmerTest::lmer(
#'            formula    = PCV2 ~ drug1 + PCV1 * dose1:drug1 + (1 | herd1:drug1)
#'          , data       = ex31
#'          , REML       = TRUE
#'          , control    = lme4::lmerControl()
#'          , start      = NULL
#'          , verbose    = 0L
#'          , contrasts  = list(dose1 = "contr.SAS", drug1 = "contr.SAS")
#'          , devFunOnly = FALSE
#'          )
#'   if (requireNamespace("report", quietly = TRUE)) {
#'     fm3.3 |>
#'       report::report()
#'   }
#'   if (requireNamespace("emmeans", quietly = TRUE)) {
#'     emm3.3 <- emmeans::emmeans(fm3.3, ~ dose1 | drug1, lmer.df = "asymptotic")
#'     print(emm3.3)
#'     print(emmeans::contrast(emm3.3, method = "pairwise"))
#'   }
#'   summary(fm3.3)
#'   anova(object = fm3.3, ddf = "Satterthwaite")
#' }
NULL
