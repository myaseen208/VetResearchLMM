#' @title    Examp1.3.2 from Duchateau, L. and Janssen, P. and Rowlands, G. J. (1998).\emph{Linear Mixed Models. An Introduction with applications in Veterinary Research}. International Livestock Research Institute.
#' @name     Examp1.3.2
#' @description Examp1.3.2 is used for inspecting probability distribution and to define a plausible process through
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
#' ## Example 1.3.2 p-16
#' #-------------------------------------------------------------
#'  # PROC GLM DATA=ex124;
#'  # CLASS herd dose drug;
#'  # MODEL PCVdif=drug herd(drug) dose dose*drug;
#'  # RANDOM herd(drug);
#'  # RUN;
#'
#' str(ex124)
#' summary(ex124)
#'
#' ex124$herd1 <- factor(ex124$herd)
#' ex124$drug1 <- factor(ex124$drug)
#' ex124$dose1 <- factor(ex124$dose)
#'
#' fm1.1 <-
#'   aov(
#'       formula     = PCVdif ~ drug1 + Error(herd1:drug1) + dose1 + dose1:drug1
#'     , data        = ex124
#'     , projections = FALSE
#'     , qr          = TRUE
#'     , contrasts   = NULL
#'   #  , ...
#'     )
#' if (requireNamespace("report", quietly = TRUE)) {
#'   fm1.1 |>
#'     report::report()
#' }
#'summary(fm1.1)
NULL
