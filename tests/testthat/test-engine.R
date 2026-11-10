# The engine against lme4, lmerTest, pbkrtest, nlme and emmeans (all optional)

test_that("REML and ML variance components agree with lme4", {
  skip_if_not_installed("lme4")
  for (reml in c(TRUE, FALSE)) {
    fm <- vlm_fit(fixed = Pcv ~ Drug + dose + Drug:dose, data = ex125, random = ~ Region + Region:Drug,
                  method = if (reml) "REML" else "ML")
    lm4 <- lme4::lmer(Pcv ~ Drug * dose + (1 | Region) + (1 | Region:Drug), data = ex125, REML = reml)
    vc <- as.data.frame(lme4::VarCorr(lm4))
    expect_equal(sort(fm$covariance$estimate), sort(vc$vcov), tolerance = 1e-5)
    ll <- fm$fit$value[1L]
    expect_equal(ll, -2 * as.numeric(stats::logLik(lm4)), tolerance = 1e-6)
  }
})

test_that("Satterthwaite degrees of freedom agree with lmerTest on unbalanced data", {
  skip_if_not_installed("lmerTest")
  d <- ex31
  d$cell <- interaction(d$drug, d$dose, drop = TRUE)
  fm <- vlm_fit(fixed = PCV2 ~ drug + drug:dose, data = ex31, random = ~ drug:herd, ddfm = "satterth",
                class = c("herd", "dose"))
  lt <- lmerTest::lmer(PCV2 ~ 0 + cell + (1 | drug:herd), data = d)
  # Type 3 test of drug: Berenil (mean of its two doses) against Samorin
  ct <- lmerTest::contest(lt, rbind(c(0.5, -1, 0.5)), joint = TRUE)
  expect_equal(fm$tests$F[1L], ct[["F value"]], tolerance = 1e-4)
  expect_equal(fm$tests$den_df[1L], ct[["DenDF"]], tolerance = 1e-3)
  ct2 <- lmerTest::contest(lt, rbind(c(1, 0, -1)), joint = TRUE)
  expect_equal(fm$tests$den_df[2L], ct2[["DenDF"]], tolerance = 1e-3)
})

test_that("Kenward-Roger tests and least-squares means agree with lmerTest and emmeans", {
  skip_if_not_installed("lmerTest")
  skip_if_not_installed("pbkrtest")
  skip_if_not_installed("emmeans")
  d <- ex31
  d$cell <- interaction(d$drug, d$dose, drop = TRUE)
  fm <- vlm_fit(fixed = PCV2 ~ drug + drug:dose + PCV1:drug:dose, data = ex31, random = ~ drug:herd,
                ddfm = "kr", class = c("herd", "dose"))
  lt <- lmerTest::lmer(PCV2 ~ cell + PCV1:cell + (1 | drug:herd), data = d)
  a <- stats::anova(lt, ddf = "Kenward-Roger")
  expect_equal(fm$tests$F[3L], a["cell:PCV1", "F value"], tolerance = 1e-4)
  expect_equal(fm$tests$den_df[3L], a["cell:PCV1", "DenDF"], tolerance = 1e-3)
  lm <- vlm_lsmeans(fit = fm, specs = ~ drug:dose, at = list(PCV1 = 18))$lsmeans
  em <- suppressMessages(as.data.frame(emmeans::emmeans(lt, ~ cell, at = list(PCV1 = 18), lmer.df = "kenward-roger")))
  em <- em[match(c("BERENIL.1", "BERENIL.2", "SAMORIN.1"), em$cell), ]
  expect_equal(lm$estimate, em$emmean, tolerance = 1e-5)
  expect_equal(lm$se, em$SE, tolerance = 1e-4)
  expect_equal(lm$df, em$df, tolerance = 1e-3)
})

test_that("residual structures agree with nlme::gls", {
  skip_if_not_installed("nlme")
  d <- ex33
  d$sub <- interaction(d$animal_id, d$breed, drop = TRUE)
  cs <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33,
                repeated = vlm_repeated(type = "cs", subject = ~ animal_id:breed))
  g <- nlme::gls(PCV ~ breed + breed:time, data = d, correlation = nlme::corCompSymm(form = ~ 1 | sub),
                 method = "REML")
  expect_equal(-cs$fit$value[1L] / 2, as.numeric(stats::logLik(g)), tolerance = 1e-6)
  sp <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33,
                repeated = vlm_repeated(type = "sp_pow", subject = ~ animal_id:breed, order = ~ time))
  g2 <- nlme::gls(PCV ~ breed + breed:time, data = d, correlation = nlme::corExp(form = ~ time | sub),
                  method = "REML")
  expect_equal(-sp$fit$value[1L] / 2, as.numeric(stats::logLik(g2)), tolerance = 1e-5)
  rng <- unname(stats::coef(g2$modelStruct$corStruct, unconstrained = FALSE))
  expect_equal(sp$covariance$estimate[1L], exp(-1 / rng), tolerance = 1e-3)
  # unstructured residual covariance on four days
  d4 <- d[d$time %in% c(0, 9, 21, 35), ]
  un <- vlm_fit(fixed = PCV ~ breed + breed:time, data = d4,
                repeated = vlm_repeated(type = "un", subject = ~ animal_id:breed, order = ~ time))
  d4$occ <- match(d4$time, c(0, 9, 21, 35))
  g3 <- nlme::gls(PCV ~ breed + breed:time, data = d4, correlation = nlme::corSymm(form = ~ occ | sub),
                  weights = nlme::varIdent(form = ~ 1 | occ), method = "REML")
  expect_equal(-un$fit$value[1L] / 2, as.numeric(stats::logLik(g3)), tolerance = 1e-5)
})

test_that("random coefficients with an unstructured covariance agree with lme4", {
  skip_if_not_installed("lme4")
  rc <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33,
                random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = "un"))
  lm4 <- lme4::lmer(PCV ~ breed + breed:time + (1 + time | animal_id), data = ex33,
                    control = lme4::lmerControl(check.conv.grad = "ignore"))
  expect_equal(-rc$fit$value[1L] / 2, as.numeric(stats::logLik(lm4)), tolerance = 1e-5)
  skip_if_not_installed("nlme")
  nl <- nlme::lme(PCV ~ breed + breed:time, random = ~ 1 + time | animal_id, data = ex33,
                  control = nlme::lmeControl(tolerance = 1e-10, msMaxIter = 500))
  vc <- nlme::getVarCov(nl)
  expect_equal(rc$covariance$estimate[1:3], c(vc[1, 1], vc[2, 1], vc[2, 2]), tolerance = 1e-3)
  b <- vlm_blup(fit = rc)$blup
  re <- lme4::ranef(lm4)$animal_id
  expect_equal(b$estimate[b$effect == "Intercept"], re[, 1L], tolerance = 1e-3)
})

test_that("independent random intercept and slope (VC) agree with lme4", {
  skip_if_not_installed("lme4")
  vc <- vlm_fit(fixed = PCV ~ breed + breed:time, data = ex33,
                random = vlm_random(effects = ~ 1 + time, subject = ~ animal_id:breed, type = "vc"))
  lm4 <- lme4::lmer(PCV ~ breed + breed:time + (1 + time || animal_id), data = ex33)
  expect_equal(-vc$fit$value[1L] / 2, as.numeric(stats::logLik(lm4)), tolerance = 1e-5)
})
