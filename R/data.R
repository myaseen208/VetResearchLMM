#' Example 1.2.1: comparing three doses of a drug
#'
#' @description Packed cell volume (PCV, \%) of trypanosome-infected animals before and one month after a low,
#' medium or high dose of Berenil: a completely randomised design (Table 1.2.1 and Appendix A of the book).
#' @format A data frame with 14 rows and 5 variables:
#' \describe{
#'   \item{animals}{animal number within its dose group.}
#'   \item{dose}{dose: \code{H} (high), \code{L} (low) or \code{M} (medium).}
#'   \item{PCV1}{PCV at treatment.}
#'   \item{PCV2}{PCV one month after treatment.}
#'   \item{PCVdiff}{change in PCV, \code{PCV2 - PCV1}.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.2.1.7}}
#' @family VetResearchLMM data
#' @examples
#' str(ex121)
#' tapply(X = ex121$PCVdiff, INDEX = ex121$dose, FUN = mean)
"ex121"

#' Example 1.2.2: comparing two doses of a drug in a randomised block design
#'
#' @description Change in packed cell volume (PCV, \%) one month after a low or high dose of Berenil, five animals per
#' dose in each of three herds; the herds are blocks (Table 1.2.2 and Appendix A of the book). New in version 2.0.0.
#' @format A data frame with 30 rows and 3 variables:
#' \describe{
#'   \item{herd}{herd (block): 1 to 3.}
#'   \item{dose}{dose: \code{H} (high) or \code{L} (low).}
#'   \item{PCVdif}{change in PCV.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.3.2}}
#' @family VetResearchLMM data
#' @examples
#' str(ex122)
"ex122"

#' Example 1.2.3: comparing two drugs with herds as experimental units
#'
#' @description Change in packed cell volume (PCV, \%) of seven animals in each of four herds; Berenil was given to
#' two herds and Samorin to the other two, so herds are nested in drug (Table 1.2.3 and Appendix A of the book). New
#' in version 2.0.0.
#' @format A data frame with 28 rows and 3 variables:
#' \describe{
#'   \item{herd}{herd: 1 to 4.}
#'   \item{drug}{drug: \code{Berenil} or \code{Samorin}.}
#'   \item{PCVdif}{change in PCV.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.3.2}}
#' @family VetResearchLMM data
#' @examples
#' str(ex123)
"ex123"

#' Example 1.2.4: two drugs at two doses with two sizes of experimental units
#'
#' @description Change in packed cell volume (PCV, \%) of animals in four herds: the drug is given to whole herds (two
#' herds per drug) and the dose to animals within a herd (Table 1.2.4 and Appendix A of the book).
#' @format A data frame with 40 rows and 4 variables:
#' \describe{
#'   \item{herd}{herd: 1 to 4 (nested in drug).}
#'   \item{drug}{drug: \code{Berenil} or \code{Samorin}.}
#'   \item{dose}{dose: \code{h} (high) or \code{l} (low).}
#'   \item{PCVdif}{change in PCV.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp1.3.2}}
#' @family VetResearchLMM data
#' @examples
#' str(ex124)
"ex124"

#' Example 1.2.5: two drugs at two doses in a split-plot design
#'
#' @description Average packed cell volume (PCV, \%) of animals in six regions; in each region one herd received
#' Berenil and one Samorin (main plots), and within a herd one group of animals received the high and one the low
#' dose (subplots) (Table 1.2.5 and Appendix A of the book).
#' @format A data frame with 24 rows and 4 variables:
#' \describe{
#'   \item{Region}{region: 1 to 6.}
#'   \item{Drug}{drug: \code{BERENIL} or \code{samorin}.}
#'   \item{dose}{dose: \code{h} (high) or \code{l} (low).}
#'   \item{Pcv}{average PCV.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.4.2.2}}, \code{\link{Examp2.5.1.1}}, \code{\link{Examp2.6.1}}
#' @family VetResearchLMM data
#' @examples
#' str(ex125)
"ex125"

#' Example 1.2.6: variation in ELISA data
#'
#' @description Optical density (OD) of an ELISA for four untreated animals, measured at 11 times with two blood
#' samples each time: a random effects model for the sources of variation (Table 1.2.6 and Appendix A of the book).
#' New in version 2.0.0.
#' @format A data frame with 88 rows and 4 variables:
#' \describe{
#'   \item{time}{time point: 1 to 11.}
#'   \item{replicat}{blood sample at the time point: 1 or 2.}
#'   \item{anim_id}{animal: 1 to 4.}
#'   \item{OD}{optical density.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.3.2}}
#' @family VetResearchLMM data
#' @examples
#' str(ex126)
"ex126"

#' Example 1.2.7: helminth resistance in sheep
#'
#' @description Weaning weight (kg) of lambs, offspring of eight sires, under high helminth challenge (Table 1.2.7 and
#' Appendix A of the book).
#' @format A data frame with 43 rows and 2 variables:
#' \describe{
#'   \item{sire}{sire: 1 to 8.}
#'   \item{Ww}{weaning weight.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp2.4.3.1}}
#' @family VetResearchLMM data
#' @examples
#' str(ex127)
"ex127"

#' Example 3.1: two drugs and their doses, herds nested in drug (part of the data)
#'
#' @description Packed cell volume (PCV, \%) at treatment and one month later; Berenil (at two doses) and Samorin (one
#' dose) were given to animals in herds nested in drug. The book prints only part of the data (a few animals per
#' herd and dose); these 38 rows are that part, so the analyses of Example 3.1 run but do not reproduce the printed
#' results.
#' @format A data frame with 38 rows and 6 variables:
#' \describe{
#'   \item{herd}{herd within drug: 1 to 4 (herds with the same number but another drug are different herds).}
#'   \item{animal_id}{animal.}
#'   \item{PCV1}{PCV at treatment.}
#'   \item{PCV2}{PCV one month after treatment.}
#'   \item{dose}{dose within drug: 1 or 2 (Samorin has dose 1 only).}
#'   \item{drug}{drug: \code{BERENIL} or \code{SAMORIN}.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp3.1}}
#' @family VetResearchLMM data
#' @examples
#' str(ex31)
"ex31"

#' Example 3.2: weaning weights of lambs by breed and sire (part of the data)
#'
#' @description Weaning weight (kg) of lambs of six breeds, with sex and age at weaning, for the complete offspring
#' of a few sires per breed. The book prints only this part of the data, so the analyses of Example 3.2 run but do
#' not reproduce the printed results.
#' @format A data frame with 65 rows and 5 variables:
#' \describe{
#'   \item{breed}{breed: 1 to 6.}
#'   \item{sire_id}{sire (nested in breed).}
#'   \item{sex}{sex: \code{F} or \code{M}.}
#'   \item{agew}{age at weaning (days).}
#'   \item{Ww}{weaning weight.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp3.2}}
#' @family VetResearchLMM data
#' @examples
#' str(ex32)
"ex32"

#' Example 3.3: breed differences in susceptibility to trypanosomosis
#'
#' @description Packed cell volume (PCV, \%) of six Boran and six N'Dama cattle measured 14 times over 35 days after
#' a trypanosome infection: repeated measures (Example 1.2.8 and Appendix A of the book). Version 2.0.0 corrects three
#' typing errors of version 1.1.0 against the book (two measurement days and one animal identifier).
#' @format A data frame with 168 rows and 4 variables:
#' \describe{
#'   \item{animal_id}{animal.}
#'   \item{breed}{breed: \code{BO} (Boran) or \code{ND} (N'Dama).}
#'   \item{time}{day after infection.}
#'   \item{PCV}{packed cell volume.}
#' }
#' @source Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \emph{Linear Mixed Models. An Introduction with
#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi. Appendix A.
#' @seealso \code{\link{Examp3.3}}
#' @family VetResearchLMM data
#' @examples
#' str(ex33)
"ex33"
