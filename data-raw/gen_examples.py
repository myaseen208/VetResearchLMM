# generates R/examples.R: one help topic per example of the book, every call with all arguments
def fit(name, fixed, data, random="NULL", repeated="NULL", method='"REML"', ddfm='"default"', type="3",
        cls="NULL", bound="TRUE", control="list()"):
    a = [("fixed", fixed), ("data", data), ("random", random), ("repeated", repeated), ("method", method),
         ("ddfm", ddfm), ("type", type), ("class", cls), ("bound", bound), ("control", control)]
    return call(name, "vlm_fit", a)

def call(name, fn, args, indent=""):
    w = max(len(k) for k, _ in args)
    lines = [f"#' {indent}{name} <-", f"#' {indent}  {fn}("]
    for i, (k, v) in enumerate(args):
        lines.append(f"#' {indent}    {' ' if i == 0 else ','} {k.ljust(w)} = {v}")
    lines.append(f"#' {indent}    )")
    return "\n".join(lines)

def show(fn, args):
    w = max(len(k) for k, _ in args)
    lines = [f"#' {fn}("]
    for i, (k, v) in enumerate(args):
        lines.append(f"#'   {' ' if i == 0 else ','} {k.ljust(w)} = {v}")
    lines.append("#'   )")
    return "\n".join(lines)

def lsm(fit, specs, at="NULL", diff="FALSE", adjust='"none"'):
    return show("vlm_lsmeans", [("fit", fit), ("specs", specs), ("at", at), ("diff", diff), ("adjust", adjust),
                                ("level", "0.95")])

def est(fit, L, random="NULL"):
    return show("vlm_estimate", [("fit", fit), ("L", L), ("random", random), ("level", "0.95")])

def ctr(fit, L):
    return show("vlm_contrast", [("fit", fit), ("L", L)])

def blup(fit):
    return show("vlm_blup", [("fit", fit), ("level", "0.95")])

def ems(fixed, data, random, cls="NULL", type="3"):
    return [("fixed", fixed), ("data", data), ("random", random), ("type", type), ("class", cls)]

def topic(name, title, desc, details, sas, body, see, extra_lme=""):
    out = [f"#' {title}", "#'", "#' @description", *[f"#' {l}" for l in desc], "#'"]
    if details:
        out += ["#' @details", *[f"#' {l}" for l in details], "#'"]
    out += ["#' @references",
            "#' Duchateau, L., Janssen, P. and Rowlands, G. J. (1998). \\emph{Linear Mixed Models. An Introduction with",
            "#' Applications in Veterinary Research}. International Livestock Research Institute, Nairobi.",
            "#' @author Muhammad Yaseen (\\email{myaseen208@@gmail.com})",
            f"#' @seealso {see}",
            "#' @family VetResearchLMM examples",
            "#' @examples",
            "#' # SAS program of the book (Appendix B):",
            *[f"#' #   {l}" for l in sas],
            "#'"]
    out += [body]
    if extra_lme:
        out += ["#'", "#' # the same model with lme4 (optional)", extra_lme]
    out += [f"#' @name {name}", "NULL", ""]
    return "\n".join(out)

T = []
lmer = lambda f, d, reml="TRUE": ("#' if (requireNamespace(\"lme4\", quietly = TRUE)) {\n"
    f"#'   lm4 <-\n#\'     lme4::lmer(\n#\'         formula = {f}\n#\'       , data    = {d}\n#\'       , REML    = {reml}\n#\'       )\n"
    "#'   print(lme4::VarCorr(lm4), comp = \"Variance\")\n#\' }")

T.append(topic("Examp1.3.2", "Example 1.3.2: expected mean squares in the fixed and the mixed model",
  ["Drugs are given to whole herds and doses to animals within herds (\\code{\\link{ex124}}). With herd random, drug is",
   "tested against herd within drug (Table 1.3.2.2); with one observation deleted the two expected mean squares no",
   "longer match (Table 1.3.2.3: 9.7143 and 9.7222), so the F test is only approximate."], None,
  ["proc glm data=ex124;", "  class herd dose drug;", "  model PCVdif = drug herd(drug) dose dose*drug;",
   "  random herd(drug) / test;", "run;"],
  "\n".join([call("em", "vlm_ems", ems("PCVdif ~ drug + drug:herd + dose + dose:drug", "ex124", "~ drug:herd", '"herd"')),
             "#' em", "#'", "#' # one observation deleted (Table 1.3.2.3)",
             call("em1", "vlm_ems", ems("PCVdif ~ drug + drug:herd + dose + dose:drug", "ex124[-1, ]", "~ drug:herd", '"herd"')),
             "#' em1$coefficients", "#'", "#' # the mixed model analysis that replaces it",
             fit("fm", "PCVdif ~ drug + dose + drug:dose", "ex124", random="~ drug:herd", ddfm='"satterth"', cls='"herd"'),
             "#' fm$tests"]),
  "\\code{\\link{vlm_ems}}, \\code{\\link{vlm_fit}}, \\code{\\link{ex124}}"))

T.append(topic("Examp2.2.1.7", "Example 2.2.1.7: one-way analysis of variance, an estimate and a contrast",
  ["The three doses of \\code{\\link{ex121}} compared by the fixed effects model: F = 14.36 on 2 and 11 df, and the",
   "low dose against the mean of the medium and high doses, -3.68 with standard error 0.937 (F = 15.44)."], None,
  ["proc glm data=ex121;", "  class dose;", "  model PCVdif = dose;", "  estimate 'l vs mh' dose -0.5 1 -0.5;",
   "  contrast 'l vs mh' dose -0.5 1 -0.5;", "run;"],
  "\n".join([call("em", "vlm_ems", ems("PCVdiff ~ dose", "ex121", "NULL")), "#' em", "#'",
             fit("fm", "PCVdiff ~ dose", "ex121"), "#' # dose levels: H, L, M",
             est("fm", 'list("l vs mh" = list(dose = c(-0.5, 1, -0.5)))'),
             ctr("fm", 'list("l vs mh" = list(dose = c(-0.5, 1, -0.5)))')]),
  "\\code{\\link{vlm_ems}}, \\code{\\link{vlm_estimate}}, \\code{\\link{ex121}}"))

T.append(topic("Examp2.3.2", "Example 2.3.2: the mixed model descriptions of Chapter 2",
  ["The models of Section 2.3.2 for the examples of Chapter 1: a randomised block design with random herds",
   "(\\code{\\link{ex122}}), herds nested in drug (\\code{\\link{ex123}}), two sizes of experimental units",
   "(\\code{\\link{ex124}}) and the random effects model of the ELISA data (\\code{\\link{ex126}}), in which animals and",
   "times are random and the overall mean is the only fixed effect. New in version 2.0.0."], None,
  ["proc mixed data=ex126;", "  class anim_id time;", "  model OD = ;", "  random anim_id time;", "run;"],
  "\n".join([fit("f122", "PCVdif ~ dose", "ex122", random="~ herd"), "#' f122$covariance",
             fit("f123", "PCVdif ~ drug", "ex123", random="~ drug:herd"), "#' f123$tests",
             fit("f126", "OD ~ 1", "ex126", random="~ anim_id + time", cls='"time"'), "#' f126$covariance",
             "#' vlm_interpret(\n#\'     x     = f126\n#\'   , alpha = 0.05\n#\'   , top   = 3\n#\'   )"]),
  "\\code{\\link{vlm_fit}}, \\code{\\link{ex122}}, \\code{\\link{ex123}}, \\code{\\link{ex126}}"))

T.append(topic("Examp2.4.2.2", "Example 2.4.2.2: ML and REML estimates of variance components",
  ["The split-plot data \\code{\\link{ex125}}: REML gives 5.151 (region), 0.387 (herd within region) and 2.096",
   "(residual); ML gives the smaller 4.292, 0.322 and 1.747 (Table 2.4.2.1), because it ignores the degrees of",
   "freedom used by the fixed effects. The Type 3 (moment) estimates equal REML here, as the data are balanced."], None,
  ["proc mixed data=ex125 method=ml;   * and method=reml;", "  class drug dose region;",
   "  model pcv = drug dose drug*dose;", "  random region drug*region;", "run;"],
  "\n".join([fit("ml", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug", method='"ML"'),
             fit("reml", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug"),
             fit("mom", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug", method='"Type3"'),
             "#' cbind(ML = ml$covariance$estimate, REML = reml$covariance$estimate, Type3 = mom$covariance$estimate)"]),
  "\\code{\\link{vlm_fit}}, \\code{\\link{ex125}}",
  lmer("Pcv ~ Drug * dose + (1 | Region / Drug)", "ex125")))

T.append(topic("Examp2.4.3.1", "Example 2.4.3.1: best linear unbiased prediction of sire effects",
  ["The random sire model of \\code{\\link{ex127}}: REML variances 3.685 (sire) and 3.542 (residual), overall mean",
   "13.97, and the prediction 3.16 for sire 4, a shrunken version of its mean deviation 17.63 - 13.97."], None,
  ["proc mixed data=ex127;", "  class sire;", "  model ww = ;", "  random sire / solution;", "run;"],
  "\n".join([fit("fs", "Ww ~ 1", "ex127", random="~ sire"), "#' fs$fixed", blup("fs")]),
  "\\code{\\link{vlm_blup}}, \\code{\\link{ex127}}",
  lmer("Ww ~ 1 + (1 | sire)", "ex127")))

T.append(topic("Examp2.5.1.1", "Example 2.5.1.1: generalised least-squares estimates of the fixed effects",
  ["The solution for the fixed effects of \\code{\\link{ex125}} with the last level of each effect set to zero:",
   "17.13, 7.15, 4.35 and -3.18, with the variances 1.27, 0.83, 0.70 and 1.40 of their estimates (the COVB matrix)."], None,
  ["proc mixed data=ex125;", "  class drug dose region;", "  model pcv = drug dose drug*dose / solution covb;",
   "  random region drug*region;", "run;"],
  "\n".join([fit("fm", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug"), "#' fm$fixed",
             "#' fm$fixed$se^2"]),
  "\\code{\\link{vlm_fit}}, \\code{\\link{ex125}}"))

T.append(topic("Examp2.5.2.1", "Example 2.5.2.1: cell means as estimable functions",
  ["The four drug-by-dose means of \\code{\\link{ex125}} (25.45, 24.28, 21.48 and 17.13) and their variance 1.27,",
   "as least-squares means."], None,
  ["proc mixed data=ex125;", "  class drug dose region;", "  model pcv = drug dose drug*dose;",
   "  random region drug*region;", "  lsmeans drug*dose;", "run;"],
  "\n".join([fit("fm", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug"),
             lsm("fm", "~ Drug:dose")]),
  "\\code{\\link{vlm_lsmeans}}, \\code{\\link{ex125}}"))

L4 = ('list(\n#\'           "drug dif"     = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))\n'
      '#\'         , "Samorin mean" = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))\n'
      '#\'         , "Samorin HvsL" = list(dose = c(1, -1), "Drug:dose" = c(0, 0, 1, -1))\n'
      '#\'         , "Samorin high" = list(Intercept = 1, Drug = c(0, 1), dose = c(1, 0), "Drug:dose" = c(0, 0, 1, 0))\n'
      '#\'         )')
T.append(topic("Examp2.5.3.1", "Example 2.5.3.1: confidence intervals with Satterthwaite degrees of freedom",
  ["Four linear combinations of the fixed effects of \\code{\\link{ex125}}: their variances 0.478, 1.0975, 0.698 and",
   "1.272 combine the variance components, and their Satterthwaite degrees of freedom (5, 6.2, 10 and 8.2) the",
   "degrees of freedom of the mean squares of Table 2.5.3.1."], None,
  ["proc mixed data=ex125;", "  class drug dose region;", "  model pcv = drug dose drug*dose / ddfm=satterth;",
   "  random region drug*region;", "  estimate 'drug dif' drug -1 1 drug*dose -0.5 -0.5 0.5 0.5;",
   "  estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;",
   "  estimate 'Samorin HvsL' dose 1 -1 drug*dose 0 0 1 -1;",
   "  estimate 'Samorin high' intercept 1 drug 0 1 dose 1 0 drug*dose 0 0 1 0;", "run;"],
  "\n".join([fit("fm", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug", ddfm='"satterth"'),
             est("fm", L4), "#'", "#' # the mean squares and their expectations (Table 2.5.3.1)",
             call("em", "vlm_ems", ems("Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose", "ex125", "~ Region + Region:Drug")),
             "#' em"]),
  "\\code{\\link{vlm_estimate}}, \\code{\\link{vlm_ems}}, \\code{\\link{ex125}}"))

T.append(topic("Examp2.5.4.1", "Example 2.5.4.1: broad and narrow inference spaces",
  ["The mean of Samorin in \\code{\\link{ex125}}: its variance is 1.0975 when regions and herds are random (broad",
   "space) and 0.175 for the six regions and herds of the study (narrow space), as in the fixed effects model."],
  ["The narrow-space estimate adds the random effects averaged over the observed levels (the part of an ESTIMATE",
   "statement after the vertical bar in SAS); the fixed effects model with regions and herds fixed gives the same",
   "standard error."],
  ["proc mixed data=ex125;", "  class drug dose region;", "  model pcv = drug dose drug*dose / ddfm=satterth;",
   "  random region drug*region;", "  estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;",
   "run;", "proc glm data=ex125;", "  class drug dose region;", "  model pcv = region drug drug*region dose drug*dose;",
   "  estimate 'Samorin mean' intercept 1 drug 0 1 dose 0.5 0.5 drug*dose 0 0 0.5 0.5;", "run;"],
  "\n".join([fit("fm", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug", ddfm='"satterth"'),
             est("fm", 'list(\n#\'           "broad"  = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))\n#\'         , "narrow" = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), "Drug:dose" = c(0, 0, 0.5, 0.5))\n#\'         )',
                 'list(\n#\'           "narrow" = list(Region = rep(1 / 6, 6), "Region:Drug" = rep(c(0, 1 / 6), 6))\n#\'         )'),
             "#'", "#' # the fixed effects model: regions and herds fixed",
             fit("ff", "Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose", "ex125", cls='"Region"'),
             est("ff", 'list(\n#\'           "Samorin mean" = list(Intercept = 1, Region = rep(1 / 6, 6), Drug = c(0, 1),\n#\'                                 "Region:Drug" = rep(c(0, 1 / 6), 6), dose = c(0.5, 0.5),\n#\'                                 "Drug:dose" = c(0, 0, 0.5, 0.5))\n#\'         )')]),
  "\\code{\\link{vlm_estimate}}, \\code{\\link{ex125}}"))

T.append(topic("Examp2.6.1", "Example 2.6.1: F tests of general linear hypotheses",
  ["The drug difference of \\code{\\link{ex125}} (estimate -5.56, variance 0.478, F on 1 and 5 df) and the joint test",
   "that the four cell means are equal: F = 31.2 on 3 and 7.14 df, p = 0.0002."], None,
  ["proc mixed data=ex125;", "  class drug dose region;", "  model pcv = drug dose drug*dose / ddfm=satterth;",
   "  random region drug*region;", "  contrast 'drug dif' drug -1 1 drug*dose -0.5 -0.5 0.5 0.5;",
   "  contrast 'all' drug 1 -1 dose 0 0 drug*dose 0.5 0.5 -0.5 -0.5,",
   "                 drug 0 0 dose 1 -1 drug*dose 0.5 -0.5 0.5 -0.5,",
   "                 drug 0 0 dose 0 0 drug*dose 0.5 -0.5 -0.5 0.5;", "run;"],
  "\n".join([fit("fm", "Pcv ~ Drug + dose + Drug:dose", "ex125", random="~ Region + Region:Drug", ddfm='"satterth"'),
             ctr("fm", 'list(\n#\'           "drug dif" = list(Drug = c(-1, 1), "Drug:dose" = c(-0.5, -0.5, 0.5, 0.5))\n#\'         , "all"      = list(\n#\'               list(Drug = c(1, -1), "Drug:dose" = c(0.5, 0.5, -0.5, -0.5))\n#\'             , list(dose = c(1, -1), "Drug:dose" = c(0.5, -0.5, 0.5, -0.5))\n#\'             , list("Drug:dose" = c(0.5, -0.5, -0.5, 0.5))\n#\'             )\n#\'         )')]),
  "\\code{\\link{vlm_contrast}}, \\code{\\link{ex125}}"))

T.append(topic("Examp3.1", "Example 3.1: a designed experiment with doses nested in drug and a covariate",
  ["Berenil at two doses and Samorin at one dose, given to animals in herds nested in drug (\\code{\\link{ex31}}).",
   "Model 1 compares the three treatments; Model 2 adds the PCV at treatment as a covariate with a common slope;",
   "Model 3 allows a slope per treatment and compares the treatments at PCV1 = 18. The book prints only part of the",
   "data, so the numbers differ from those of the book."], None,
  ["proc mixed data=ex31;", "  class drug dose herd;", "  model PCV2 = drug dose(drug) / solution ddfm=satterth;",
   "  random herd(drug);", "  estimate 'Mean Samorin' intercept 1 drug 0 1 dose(drug) 0 0 1;",
   "  estimate 'Berenil 2 doses' dose(drug) 1 -1 0;", "  estimate 'Ber vs Sam at dose 1' drug 1 -1 dose(drug) 1 0 -1;",
   "  contrast 'some difference' drug 1 -1 dose(drug) 0.5 0.5 -1, drug 0 0 dose(drug) 1 -1 0;",
   "  lsmeans dose(drug);", "run;", "* Model 3: model PCV2 = drug dose(drug) PCV1*dose(drug); lsmeans dose(drug) / at PCV1=18;"],
  "\n".join([fit("m1", "PCV2 ~ drug + drug:dose", "ex31", random="~ drug:herd", ddfm='"satterth"', cls='c("herd", "dose")'),
             "#' m1$tests",
             est("m1", 'list(\n#\'           "Mean Samorin"         = list(Intercept = 1, drug = c(0, 1), "drug:dose" = c(0, 0, 1))\n#\'         , "Berenil 2 doses"      = list("drug:dose" = c(1, -1, 0))\n#\'         , "Ber vs Sam at dose 1" = list(drug = c(1, -1), "drug:dose" = c(1, 0, -1))\n#\'         )'),
             ctr("m1", 'list(\n#\'           "some difference" = list(\n#\'               list(drug = c(1, -1), "drug:dose" = c(0.5, 0.5, -1))\n#\'             , list("drug:dose" = c(1, -1, 0))\n#\'             )\n#\'         )'),
             lsm("m1", "~ drug:dose"),
             fit("m2", "PCV2 ~ PCV1 + drug + drug:dose", "ex31", random="~ drug:herd", ddfm='"satterth"', cls='c("herd", "dose")'),
             "#' m2$fixed",
             fit("m3", "PCV2 ~ drug + drug:dose + PCV1:drug:dose", "ex31", random="~ drug:herd", ddfm='"satterth"', cls='c("herd", "dose")'),
             lsm("m3", "~ drug:dose", at="list(PCV1 = 18)")]),
  "\\code{\\link{vlm_fit}}, \\code{\\link{vlm_lsmeans}}, \\code{\\link{ex31}}"))

T.append(topic("Examp3.2", "Example 3.2: sires nested in breed, heritability and breed comparisons",
  ["Weaning weights of lambs (\\code{\\link{ex32}}) with sex, age and breed fixed and sires within breed random: the",
   "heritability \\eqn{h^2 = 4\\sigma_s^2/(\\sigma_s^2 + \\sigma^2)}, Tukey-Kramer comparisons of the breeds and the",
   "predicted breeding values of the sires. The book prints only part of the data, so the numbers differ from those",
   "of the book (for this part the sire variance is estimated as zero)."], None,
  ["proc mixed data=ex32;", "  class sex sire_id breed;", "  model ww = sex agew breed / solution ddfm=satterth;",
   "  random sire_id(breed) / solution;", "  lsmeans breed / adjust=tukey;", "run;"],
  "\n".join([fit("fm", "Ww ~ sex + agew + breed", "ex32", random="~ breed:sire_id", ddfm='"satterth"', cls='"breed"'),
             "#' v <- fm$covariance$estimate",
             "#' h2 <- 4 * v[1] / sum(v)",
             "#' h2",
             lsm("fm", "~ breed", diff="TRUE", adjust='"tukey"'),
             blup("fm")]),
  "\\code{\\link{vlm_lsmeans}}, \\code{\\link{vlm_blup}}, \\code{\\link{ex32}}"))

T.append(topic("Examp3.3", "Example 3.3: covariance structures for repeated measures",
  ["PCV of 12 animals of two breeds measured 14 times (\\code{\\link{ex33}}). Model 1 has a random animal effect,",
   "equivalent to compound symmetry (variances 5.478 and 4.965; -2 restricted log-likelihood 783.451); Model 2 has",
   "first-order autoregressive errors (rho = 0.621, residual 10.191; 793.139); Model 3 has a random intercept and",
   "slope per animal with an unstructured covariance (12.46, -0.2551, 0.005758 and residual 4.353)."], None,
  ["proc mixed data=ex33; class breed anim_id; model pcv = breed breed*time / solution;",
   "  random anim_id(breed) / solution;                               * Model 1;",
   "  repeated / type=cs sub=anim_id(breed) r;                         * Model 1, second form;",
   "  repeated / type=ar(1) sub=anim_id(breed) r;                      * Model 2;",
   "  random intercept time / type=un sub=anim_id(breed) solution;     * Model 3;", "run;"],
  "\n".join([fit("m1", "PCV ~ breed + breed:time", "ex33", random="~ animal_id:breed"), "#' m1$fixed",
             blup("m1"),
             fit("cs", "PCV ~ breed + breed:time", "ex33", repeated='vlm_repeated(type = "cs", subject = ~ animal_id:breed, order = NULL)'),
             "#' cs$fit",
             fit("m1c", "PCV ~ time + breed + breed:time", "ex33", random="~ animal_id:breed"), "#' m1c$tests",
             fit("ar", "PCV ~ breed + breed:time", "ex33", repeated='vlm_repeated(type = "ar1", subject = ~ animal_id:breed, order = ~ time)'),
             "#' ar$covariance",
             fit("rc", "PCV ~ breed + breed:time", "ex33", random='vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = "un")'),
             "#' rc$covariance",
             show("vlm_compare", [("CS", "cs"), ("AR1", "ar"), ("RC", "rc"), ("test", "TRUE")])]),
  "\\code{\\link{vlm_random}}, \\code{\\link{vlm_repeated}}, \\code{\\link{vlm_compare}}, \\code{\\link{ex33}}",
  lmer("PCV ~ breed + breed:time + (1 | animal_id)", "ex33")))

hdr = ("#-------------------------------------------------------------------------------------------------------------------\n"
       "# The examples of the book: one help topic per example, with the SAS program of Appendix B and the same analysis\n"
       "# with the functions of the package (generated by data-raw/gen_examples.py).\n"
       "#-------------------------------------------------------------------------------------------------------------------\n\n")
import sys
open(sys.argv[1], "w").write(hdr + "\n".join(T))

# wrap example lines wider than 100 characters before " dose = c(" (Rd line width)
def wrap_file(path):
    out = []
    for l in open(path).read().split("\n"):
        if l.startswith("#'") and len(l) > 100 and ", dose = c(" in l:
            i = l.index(", dose = c(")
            j = l.index("list(Intercept") + len("list(")
            out.append(l[:i + 1])
            out.append("#'" + " " * (j - 2) + l[i + 2:])
        else:
            out.append(l)
    open(path, "w").write("\n".join(out))

wrap_file(sys.argv[1])
if len(sys.argv) > 2:
    wrap_file(sys.argv[2])
