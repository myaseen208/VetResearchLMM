#-------------------------------------------------------------------------------------------------------------------
# The published values of Duchateau, Janssen and Rowlands (1998) that the package reproduces: writes
# inst/extdata/reference.csv (one row per printed number, with the call that recomputes it).
# Run from the package root: Rscript data-raw/reference.R
#-------------------------------------------------------------------------------------------------------------------
library(data.table)
rows <- list()
add <- function(id, source, quantity, call, extract, value, digits, level = 1L, note = "") {
  rows[[length(rows) + 1L]] <<- data.table(id = id, source = source, quantity = quantity, call = call,
                                           extract = extract, value = value, digits = digits, level = level,
                                           note = note)
}
B <- function(s) paste0("Duchateau, Janssen and Rowlands (1998), ", s)

# Example 1.3.2: expected mean squares
c132 <- "vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd, class = \"herd\")"
c132d <- "vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124[-1, ], random = ~ drug:herd, class = \"herd\")"
add("e132_drug", B("Table 1.3.2.2"), "coefficient of the herd variance in E(MS drug)", c132, "x$coefficients[1, 1]", 10, 4)
add("e132_herd", B("Table 1.3.2.2"), "coefficient of the herd variance in E(MS herd(drug))", c132, "x$coefficients[2, 1]", 10, 4)
add("e132d_drug", B("Table 1.3.2.3"), "coefficient in E(MS drug), one observation deleted", c132d, "x$coefficients[1, 1]", 9.7143, 4)
add("e132d_herd", B("Table 1.3.2.3"), "coefficient in E(MS herd(drug)), one observation deleted", c132d, "x$coefficients[2, 1]", 9.7222, 4)

# Example 2.2.1.7
c2217 <- "vlm_ems(fixed = PCVdiff ~ dose, data = ex121, random = NULL)"
add("e2217_ss_dose", B("Table 2.2.1.3"), "sum of squares among doses", c2217, "x$anova$ss[1]", 80.73, 2)
add("e2217_ss_err", B("Table 2.2.1.3"), "error sum of squares", c2217, "x$anova$ss[2]", 30.91, 2)
add("e2217_ms_dose", B("Table 2.2.1.3"), "mean square among doses", c2217, "x$anova$ms[1]", 40.36, 2)
add("e2217_ms_err", B("Table 2.2.1.3"), "error mean square", c2217, "x$anova$ms[2]", 2.81, 2)
add("e2217_F", B("Example 2.2.1.7, SAS output"), "F statistic of dose", c2217, "x$anova$F[1]", 14.37, 2)
add("e2217_p", B("Example 2.2.1.7"), "p-value of dose", c2217, "x$anova$p[1]", 0.0009, 4)
f2217 <- "vlm_estimate(fit = vlm_fit(fixed = PCVdiff ~ dose, data = ex121), L = list(\"l vs mh\" = list(dose = c(-0.5, 1, -0.5))))"
add("e2217_est", B("Example 2.2.1.7, SAS output"), "estimate l vs mh", f2217, "x$estimates$estimate", -3.68, 2)
add("e2217_se", B("Example 2.2.1.7, SAS output"), "standard error of l vs mh", f2217, "x$estimates$se", 0.937, 3)
add("e2217_var", B("Example 2.2.1.7"), "variance of l vs mh", f2217, "x$estimates$se^2", 0.875, 2)
add("e2217_t", B("Example 2.2.1.7, SAS output"), "t of l vs mh", f2217, "x$estimates$t", -3.93, 2)
c2217c <- "vlm_contrast(fit = vlm_fit(fixed = PCVdiff ~ dose, data = ex121), L = list(\"l vs mh\" = list(dose = c(-0.5, 1, -0.5))))"
add("e2217_cF", B("Example 2.2.1.7, SAS output"), "F of the contrast l vs mh", c2217c, "x$contrasts$F", 15.44, 2)
add("e2217_cp", B("Example 2.2.1.7, SAS output"), "p-value of the contrast l vs mh", c2217c, "x$contrasts$p", 0.0024, 4)

# Example 2.4.2.2
m <- "vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug, method = \"%s\")"
for (k in list(c("ML", "4.292", "0.322", "1.747"), c("REML", "5.151", "0.387", "2.096"))) {
  cl <- sprintf(m, k[1L])
  add(paste0("e2422_", tolower(k[1L]), "_region"), B("Table 2.4.2.1"), paste(k[1L], "region variance"), cl,
      "x$covariance$estimate[1]", as.numeric(k[2L]), 3)
  add(paste0("e2422_", tolower(k[1L]), "_herd"), B("Table 2.4.2.1"), paste(k[1L], "herd within region variance"), cl,
      "x$covariance$estimate[2]", as.numeric(k[3L]), 3)
  add(paste0("e2422_", tolower(k[1L]), "_resid"), B("Table 2.4.2.1"), paste(k[1L], "residual variance"), cl,
      "x$covariance$estimate[3]", as.numeric(k[4L]), 3)
}

# Example 2.4.3.1
f127 <- "vlm_fit(fixed = Ww ~ 1, data = ex127, random = ~ sire)"
add("e2431_sire", B("Example 2.4.3.1"), "sire variance", f127, "x$covariance$estimate[1]", 3.685, 3,
    note = "the book truncates 3.6855 (also given by lme4 and nlme) to 3.685")
add("e2431_resid", B("Example 2.4.3.1"), "residual variance", f127, "x$covariance$estimate[2]", 3.542, 3)
add("e2431_mu", B("Example 2.4.3.1"), "overall mean", f127, "x$fixed$estimate[1]", 13.97, 2)
add("e2431_blup4", B("Example 2.4.3.1"), "prediction of sire 4", paste0("vlm_blup(fit = ", f127, ")"),
    "x$blup$estimate[4]", 3.16, 2)

# Example 2.5.1.1
f125 <- "vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug, ddfm = \"satterth\")"
sol <- list(c(1, 17.13, 1.27), c(2, 7.15, 0.83), c(4, 4.35, 0.70), c(6, -3.18, 1.40))
for (s in sol) {
  add(sprintf("e2511_b%d", s[1L]), B("Example 2.5.1.1"), sprintf("fixed-effect solution, row %d", s[1L]), f125,
      sprintf("x$fixed$estimate[%d]", s[1L]), s[2L], 2)
  add(sprintf("e2511_v%d", s[1L]), B("Example 2.5.1.1"), sprintf("variance of the solution, row %d", s[1L]), f125,
      sprintf("x$fixed$se[%d]^2", s[1L]), s[3L], 2)
}

# Example 2.5.2.1
l125 <- paste0("vlm_lsmeans(fit = ", f125, ", specs = ~ Drug:dose)")
for (i in 1:4) add(sprintf("e2521_m%d", i), B("Example 2.5.2.1"), sprintf("cell mean %d", i), l125,
                   sprintf("x$lsmeans$estimate[%d]", i), c(25.45, 24.28, 21.48, 17.13)[i], 2)
add("e2521_v", B("Example 2.5.2.1"), "variance of a cell mean", l125, "x$lsmeans$se[1]^2", 1.27, 2)

# Example 2.5.3.1
L4 <- paste0("list(\"Samorin mean\" = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), \"Drug:dose\" = c(0, 0, 0.5, 0.5)), ",
             "\"drug dif\" = list(Drug = c(-1, 1), \"Drug:dose\" = c(-0.5, -0.5, 0.5, 0.5)), ",
             "\"Samorin high\" = list(Intercept = 1, Drug = c(0, 1), dose = c(1, 0), \"Drug:dose\" = c(0, 0, 1, 0)), ",
             "\"Samorin HvsL\" = list(dose = c(1, -1), \"Drug:dose\" = c(0, 0, 1, -1)))")
e125 <- paste0("vlm_estimate(fit = ", f125, ", L = ", L4, ")")
vals <- list(c(1, 19.31, 1.0975, 2, 6.2), c(2, NA, 0.478, 3, 5), c(3, 21.48, 1.272, 3, 8.2), c(4, 4.35, 0.698, 2, 10))
for (v in vals) {
  i <- v[1L]
  if (!is.na(v[2L])) add(sprintf("e2531_est%d", i), B("Example 2.5.3.1"), sprintf("estimate c%d", i + 2), e125,
                         sprintf("x$estimates$estimate[%d]", i), v[2L], 2)
  add(sprintf("e2531_var%d", i), B("Example 2.5.3.1"), sprintf("variance of estimate c%d", i + 2), e125,
      sprintf("x$estimates$se[%d]^2", i), v[3L], v[4L])
  add(sprintf("e2531_df%d", i), B("Example 2.5.3.1"), sprintf("Satterthwaite df of estimate c%d", i + 2), e125,
      sprintf("x$estimates$df[%d]", i), v[5L], 1)
}
c25 <- "vlm_ems(fixed = Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug)"
ms <- c(23.47, 185.37, 2.87, 45.65, 15.20, 2.096)
for (i in seq_along(ms)) add(sprintf("e2531_ms%d", i), B("Table 2.5.3.1"), sprintf("mean square, row %d", i), c25,
                             sprintf("x$anova$ms[%d]", i), ms[i], if (i == 6L) 3 else 2)

# Example 2.5.4.1
n125 <- paste0("vlm_estimate(fit = ", f125, ", L = list(narrow = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5), ",
               "\"Drug:dose\" = c(0, 0, 0.5, 0.5))), random = list(narrow = list(Region = rep(1 / 6, 6), ",
               "\"Region:Drug\" = rep(c(0, 1 / 6), 6))))")
add("e2541_var", B("Example 2.5.4.1"), "variance of the Samorin mean, narrow inference space", n125,
    "x$estimates$se^2", 0.175, 3)

# Example 2.6.1
c261 <- paste0("vlm_contrast(fit = ", f125, ", L = list(all = list(list(Drug = c(1, -1), \"Drug:dose\" = c(0.5, 0.5, -0.5, -0.5)), ",
               "list(dose = c(1, -1), \"Drug:dose\" = c(0.5, -0.5, 0.5, -0.5)), list(\"Drug:dose\" = c(0.5, -0.5, -0.5, 0.5)))))")
add("e261_F", B("Example 2.6.1"), "F of the joint hypothesis of equal cell means", c261, "x$contrasts$F", 31.2, 1)
add("e261_ddf", B("Example 2.6.1"), "Satterthwaite denominator df of the joint hypothesis", c261, "x$contrasts$den_df",
    7.14, 2)
add("e261_p", B("Example 2.6.1"), "p-value of the joint hypothesis", c261, "x$contrasts$p", 0.0002, 4)

# Example 3.3
m1 <- "vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = ~ animal_id:breed)"
add("e33_m1_anim", B("Example 3.3, Model 1"), "animal variance", m1, "x$covariance$estimate[1]", 5.478, 3)
add("e33_m1_resid", B("Example 3.3, Model 1"), "residual variance", m1, "x$covariance$estimate[2]", 4.965, 3)
fx <- list(c(1, 35.06, 2, 1.056, 3, 10), c(2, -0.842, 3, 1.493, 3, 10), c(4, -0.413, 3, 0.0225, 4, 154),
           c(5, -0.276, 3, 0.0225, 4, 154))
for (f in fx) {
  add(sprintf("e33_m1_b%d", f[1L]), B("Example 3.3, Model 1"), sprintf("fixed effect, row %d", f[1L]), m1,
      sprintf("x$fixed$estimate[%d]", f[1L]), f[2L], f[3L])
  add(sprintf("e33_m1_se%d", f[1L]), B("Example 3.3, Model 1"), sprintf("standard error, row %d", f[1L]), m1,
      sprintf("x$fixed$se[%d]", f[1L]), f[4L], f[5L])
  add(sprintf("e33_m1_df%d", f[1L]), B("Example 3.3, Model 1"), sprintf("containment df, row %d", f[1L]), m1,
      sprintf("x$fixed$df[%d]", f[1L]), f[6L], 0)
}
b1 <- paste0("vlm_blup(fit = ", m1, ")")
bl <- list(c(3, -0.672), c(4, -2.497), c(5, -2.383), c(2, 3.038), c(6, 0.0324), c(1, 2.481), c(7, -1.667),
           c(8, 2.626), c(9, -1.667), c(10, -0.372), c(11, -1.754), c(12, 2.834))
for (b in bl) add(sprintf("e33_m1_blup%d", b[1L]), B("Example 3.3, Model 1"), sprintf("prediction of animal %d", b[1L]),
                  b1, sprintf("x$blup$estimate[%d]", b[1L]), b[2L], if (b[2L] == 0.0324) 4 else 3)
add("e33_m1_blup_se", B("Example 3.3, Model 1"), "standard error of prediction", b1, "x$blup$se[1]", 1.091, 3)
add("e33_m1_blup_df", B("Example 3.3, Model 1"), "df of the predictions", b1, "x$blup$df[1]", 154, 0)
cs <- "vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, repeated = vlm_repeated(type = \"cs\", subject = ~ animal_id:breed))"
st <- function(s) sprintf("x$fit$value[x$fit$statistic == \"%s\"]", s)
add("e33_cs_m2ll", B("Example 3.3, Model 1"), "-2 restricted log-likelihood, compound symmetry", cs,
    st("-2 Res Log Likelihood"), 783.451, 3)
add("e33_cs_aic", B("Example 3.3, Model 1"), "Akaike's criterion (SAS 6)", cs, st("AIC (SAS 6, larger is better)"),
    -393.73, 2)
add("e33_cs_sbc", B("Example 3.3, Model 1"), "Schwarz's criterion (SAS 6)", cs, st("SBC (SAS 6, larger is better)"),
    -396.83, 2)
add("e33_cs_lrt", B("Example 3.3, Model 1"), "null model likelihood ratio chi-square", cs,
    st("Null model LRT chi-square"), 80.845, 3)
m1c <- "vlm_fit(fixed = PCV ~ time + breed + breed:time, data = ex33, random = ~ animal_id:breed)"
tt <- list(c(1, 470.05, 154), c(2, 0.32, 10), c(3, 18.62, 154))
for (t in tt) {
  add(sprintf("e33_m1c_F%d", t[1L]), B("Example 3.3, Model 1"), sprintf("Type 3 F, row %d", t[1L]), m1c,
      sprintf("x$tests$F[%d]", t[1L]), t[2L], 2)
  add(sprintf("e33_m1c_df%d", t[1L]), B("Example 3.3, Model 1"), sprintf("denominator df, row %d", t[1L]), m1c,
      sprintf("x$tests$den_df[%d]", t[1L]), t[3L], 0)
}
ar <- "vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, repeated = vlm_repeated(type = \"ar1\", subject = ~ animal_id:breed))"
add("e33_ar_rho", B("Example 3.3, Model 2"), "AR(1) correlation", ar, "x$covariance$estimate[1]", 0.621, 3)
add("e33_ar_resid", B("Example 3.3, Model 2"), "residual variance", ar, "x$covariance$estimate[2]", 10.19, 2,
    note = "")
add("e33_ar_m2ll", B("Example 3.3, Model 2"), "-2 restricted log-likelihood", ar, st("-2 Res Log Likelihood"),
    793.139, 3)
add("e33_ar_aic", B("Example 3.3, Model 2"), "Akaike's criterion (SAS 6)", ar, st("AIC (SAS 6, larger is better)"),
    -398.57, 2)
add("e33_ar_sbc", B("Example 3.3, Model 2"), "Schwarz's criterion (SAS 6)", ar, st("SBC (SAS 6, larger is better)"),
    -401.67, 2)
add("e33_ar_lrt", B("Example 3.3, Model 2"), "null model likelihood ratio chi-square", ar,
    st("Null model LRT chi-square"), 71.156, 2)
rc <- "vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = \"un\"))"
add("e33_rc_un11", B("Example 3.3, Model 3"), "UN(1,1)", rc, "x$covariance$estimate[1]", 12.46, 2)
add("e33_rc_un21", B("Example 3.3, Model 3"), "UN(2,1)", rc, "x$covariance$estimate[2]", -0.255, 3)
add("e33_rc_un22", B("Example 3.3, Model 3"), "UN(2,2)", rc, "x$covariance$estimate[3]", 0.005758, 5)
add("e33_rc_resid", B("Example 3.3, Model 3"), "residual variance", rc, "x$covariance$estimate[4]", 4.353, 3)
add("e33_rc_se1", B("Example 3.3, Model 3"), "standard error of the intercept", rc, "x$fixed$se[1]", 1.501, 3)
add("e33_rc_se2", B("Example 3.3, Model 3"), "standard error of breed BO", rc, "x$fixed$se[2]", 2.123, 3)
add("e33_rc_se4", B("Example 3.3, Model 3"), "standard error of a slope", rc, "x$fixed$se[4]", 0.037, 3)
b3 <- paste0("vlm_blup(fit = ", rc, ")")
add("e33_rc_blup_int", B("Example 3.3, Model 3"), "random intercept of BO241", b3, "x$blup$estimate[3]", -1.836, 3)
add("e33_rc_blup_slope", B("Example 3.3, Model 3"), "random slope of BO241", b3, "x$blup$estimate[15]", 0.0563, 4)
add("e33_rc_blup_se1", B("Example 3.3, Model 3"), "standard error of a random intercept", b3, "x$blup$se[3]", 1.64, 2)
add("e33_rc_blup_se2", B("Example 3.3, Model 3"), "standard error of a random slope", b3, "x$blup$se[15]", 0.0417, 4)
add("e33_rc_blup_df", B("Example 3.3, Model 3"), "df of the predictions", b3, "x$blup$df[3]", 144, 0)

ref <- rbindlist(rows)
ref[, call := gsub("\"", "'", call)]
ref[, extract := gsub("\"", "'", extract)]
dir.create("inst/extdata", showWarnings = FALSE, recursive = TRUE)
fwrite(ref, "inst/extdata/reference.csv")
cat(nrow(ref), "rows\n")
