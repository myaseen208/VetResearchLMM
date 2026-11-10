fm <- vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug,
              ddfm = "satterth")

test_that("vlm_fit() returns the SAS tables and keeps its call", {
  expect_result(fm, "fit", c("covariance", "fixed", "tests", "fit", "dimensions"))
  expect_equal(as.character(attr(fm, "call")[[1L]]), "vlm_fit")
  expect_equal(nrow(fm$fixed), 9L)
  expect_equal(sum(fm$fixed$estimate == 0), 5L)
  expect_true(all(is.na(fm$fixed$se[fm$fixed$estimate == 0])))
  expect_s3_class(data.table::as.data.table(fm, component = "tests"), "data.table")
})

test_that("Type 1 tests, the Type 3 method and every ddfm run", {
  t1 <- vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug, type = 1)
  expect_equal(t1$tests$F, fm$tests$F, tolerance = 1e-6)
  m3 <- vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug,
                method = "Type3")
  expect_equal(m3$covariance$estimate, fm$covariance$estimate, tolerance = 1e-4)
  for (d in c("contain", "residual", "betwithin", "kr")) {
    f <- vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug, ddfm = d)
    expect_equal(f$tests$F[2L], fm$tests$F[2L], tolerance = 1e-6)
  }
  bw <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33,
                repeated = vlm_repeated(type = "cs", subject = ~ animal_id:breed))
  expect_equal(bw$tests$den_df, c(10, 154))
})

test_that("argument checks give clear errors", {
  expect_error(vlm_fit(fixed = ~ dose, data = ex125), "two-sided formula")
  expect_error(vlm_fit(fixed = Pcv ~ dose, data = ex125, random = "Region"), "random")
  expect_error(vlm_fit(fixed = Pcv ~ dose, data = ex125, type = 2), "1 or 3")
  expect_error(vlm_fit(fixed = Pcv ~ dose, data = ex125, method = "Type3",
                       repeated = vlm_repeated("cs", ~ Region)), "Type3")
  expect_error(vlm_random(effects = ~ 1), "subject")
  expect_error(vlm_repeated(type = "sp_pow", subject = ~ animal_id), "order")
  expect_error(vlm_lsmeans(fit = 1, specs = "dose"), "vlm_fit")
  expect_error(vlm_lsmeans(fit = fm, specs = "Region"), "classification")
  expect_error(vlm_estimate(fit = fm, L = list(a = list(nodose = 1))), "no fixed effect")
  expect_error(vlm_estimate(fit = fm, L = list(a = list(dose = c(1, 2, 3)))), "levels")
  expect_error(vlm_compare(fm), "at least two")
  expect_error(vlm_ems(fixed = Pcv ~ Drug, data = ex125, random = ~ Region), "not in")
  expect_output(print(vlm_random(~ 1 + time, ~ animal_id, "un")), "UN")
  expect_output(print(vlm_repeated("ar1", ~ animal_id, ~ time)), "AR1")
})

test_that("non-estimable functions give NA", {
  e <- vlm_estimate(fit = fm, L = list(drug = list(Drug = c(1, 0))))
  expect_true(is.na(e$estimates$estimate))
  c1 <- vlm_contrast(fit = fm, L = list(drug = list(Drug = c(1, 0))))
  expect_equal(c1$contrasts$note, "not estimable")
  expect_equal(vlm_estimate(fit = fm, L = list(a = c(1, 0, 1, 1, 0, 0, 0, 1, 0)))$estimates$estimate, 21.483333,
               tolerance = 1e-6)
})

test_that("least-squares means, differences and adjustments", {
  for (adj in c("none", "tukey", "bonferroni", "sidak")) {
    l <- vlm_lsmeans(fit = fm, specs = "Drug:dose", diff = TRUE, adjust = adj)
    expect_result(l, "lsmeans", c("lsmeans", "diffs", "L"))
    expect_equal(nrow(l$diffs), 6L)
    expect_true(all(l$diffs$p_adjusted >= l$diffs$p - 1e-12))
  }
  l1 <- vlm_lsmeans(fit = fm, specs = ~ dose)
  expect_equal(l1$lsmeans$estimate, c(23.46667, 20.70833), tolerance = 1e-5)
  expect_s3_class(plot(l1), "ggplot")
})

test_that("Tukey-Kramer comparisons agree with emmeans", {
  skip_if_not_installed("emmeans")
  skip_if_not_installed("lmerTest")
  lt <- lmerTest::lmer(Pcv ~ Drug * dose + (1 | Region) + (1 | Region:Drug), data = ex125)
  em <- as.data.frame(emmeans::contrast(emmeans::emmeans(lt, ~ Drug * dose, lmer.df = "satterthwaite"),
                                        method = "pairwise", adjust = "tukey"))
  l <- vlm_lsmeans(fit = fm, specs = ~ Drug:dose, diff = TRUE, adjust = "tukey")$diffs
  expect_equal(sort(abs(l$estimate)), sort(abs(em$estimate)), tolerance = 1e-6)
  expect_equal(sort(l$p_adjusted), sort(em$p.value), tolerance = 1e-3)
})

test_that("predictions, narrow estimates, comparisons, plots and interpretation", {
  b <- vlm_blup(fit = vlm_fit(fixed = Ww ~ 1, data = ex127, random = ~ sire, ddfm = "satterth"))
  expect_result(b, "blup", "blup")
  expect_true(all(b$blup$df > 0))
  expect_s3_class(plot(b), "ggplot")
  n <- vlm_estimate(fit = fm, L = list(m = list(Intercept = 1, Drug = c(0, 1), dose = c(0.5, 0.5),
                                               "Drug:dose" = c(0, 0, 0.5, 0.5))),
                    random = list(m = list(Region = rep(1 / 6, 6), "Region:Drug" = rep(c(0, 1 / 6), 6))))
  expect_equal(n$estimates$space, "narrow")
  expect_s3_class(plot(n), "ggplot")
  expect_error(vlm_estimate(fit = fm, L = list(m = 1), random = list(z = list())), "names")
  for (w in c("residuals", "qq", "observed")) expect_s3_class(plot(fm, which = w), "ggplot")
  expect_s3_class(ggplot2::autoplot(fm), "ggplot")
  cs <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, repeated = vlm_repeated("cs", ~ animal_id:breed))
  ar <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33, repeated = vlm_repeated("ar1", ~ animal_id:breed))
  i0 <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33)
  cmp <- vlm_compare(independent = i0, CS = cs, AR1 = ar)
  expect_result(cmp, "compare", "models")
  expect_equal(cmp$models$chisq[2L], 80.845, tolerance = 1e-4)
  expect_s3_class(plot(cmp), "ggplot")
  for (x in list(fm, b, n, cmp, vlm_lsmeans(fit = fm, specs = "Drug:dose", diff = TRUE),
                 vlm_contrast(fit = fm, L = list(a = list(dose = c(1, -1)))), ar,
                 vlm_ems(fixed = PCVdif ~ drug + drug:herd + dose + dose:drug, data = ex124, random = ~ drug:herd,
                         class = "herd"))) {
    it <- vlm_interpret(x = x)
    expect_s3_class(it, "vlm_interpretation")
    expect_output(print(it))
    expect_true(any(grepl("^##", format(it, style = "markdown"))))
    expect_output(print(vlm_cite(x = x)))
  }
  expect_output(print(vlm_cite(style = "bibtex")), "@Book")
  expect_error(vlm_interpret(x = 1), "result")
})

test_that("expected mean squares: Type 1 and synthesised error terms", {
  e1 <- vlm_ems(fixed = Pcv ~ Region + Drug + Region:Drug + dose + Drug:dose, data = ex125,
                random = ~ Region + Region:Drug, type = 1)
  expect_result(e1, "ems", c("anova", "coefficients", "error_terms", "components"))
  expect_equal(e1$components$estimate, c(5.150833, 0.387, 2.096417), tolerance = 1e-5)
  e2 <- vlm_ems(fixed = OD ~ anim_id + time + anim_id:time, data = ex126, random = ~ anim_id + time + anim_id:time,
                class = "time")
  expect_true(all(!is.na(e2$anova$F[1:3])))
  expect_true(grepl("MS\\(anim_id:time\\)", e2$error_terms$error[1L]))
})

test_that("the helpers of version 1.1.0 also accept vlm_fit results", {
  l <- emmeans_mixed_model(model = fm, specs = ~ dose | Drug, pairwise = TRUE)
  expect_s3_class(l, "vlm_lsmeans")
  expect_s3_class(report_mixed_model(model = fm), "vlm_interpretation")
})

test_that("the application object builds", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("bslib")
  skip_if_not_installed("DT")
  app <- vlm_app_object()
  expect_s3_class(app, "shiny.appobj")
  L <- VetResearchLMM:::.vlm_app_parse_L("a: Drug -1 1 Drug:dose -0.5 -0.5 0.5 0.5\nb: dose 1 -1, Drug:dose 1 -1 0 0")
  expect_equal(L$a$Drug, c(-1, 1))
  expect_length(L$b, 2L)
  shiny::testServer(VetResearchLMM:::.vlm_app_server, {
    session$setInputs(dat_src = "book", dat_book = "ex125", m_fixed = "Pcv ~ Drug + dose + Drug:dose",
                      m_random = "~ Region + Region:Drug", m_rc_eff = "", m_rc_sub = "", m_rc_type = "vc",
                      m_rep_type = "none", m_rep_sub = "", m_rep_ord = "", m_method = "REML",
                      m_ddfm = "satterth", m_type = "3", m_class = "", m_run = 1)
    expect_s3_class(fit(), "vlm_fit")
    session$setInputs(lsm_specs = "Drug:dose", lsm_at = "", lsm_diff = TRUE, lsm_adjust = "tukey", lsm_run = 1)
    expect_s3_class(lsm(), "vlm_lsmeans")
    session$setInputs(est_L = "m: intercept 1 Drug 0 1 dose 0.5 0.5 Drug:dose 0 0 0.5 0.5",
                      ct_L = "all: Drug 1 -1, dose 1 -1", est_run = 1)
    expect_s3_class(est(), "vlm_estimate")
    expect_s3_class(ct(), "vlm_contrast")
    session$setInputs(blup_run = 1)
    expect_s3_class(blup(), "vlm_blup")
    expect_match(VetResearchLMM:::.vlm_app_code(input), "vlm_fit")
  })
})
