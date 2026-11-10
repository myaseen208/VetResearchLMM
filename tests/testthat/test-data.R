test_that("included datasets keep expected shape and columns", {
  expected <- list(
    ex121 = list(
      dim = c(14L, 5L),
      names = c("animals", "dose", "PCV1", "PCV2", "PCVdiff")
    ),
    ex124 = list(
      dim = c(40L, 4L),
      names = c("herd", "drug", "dose", "PCVdif")
    ),
    ex125 = list(
      dim = c(24L, 4L),
      names = c("Region", "Drug", "dose", "Pcv")
    ),
    ex127 = list(
      dim = c(43L, 2L),
      names = c("sire", "Ww")
    ),
    ex31 = list(
      dim = c(38L, 6L),
      names = c("herd", "animal_id", "PCV1", "PCV2", "dose", "drug")
    ),
    ex32 = list(
      dim = c(65L, 5L),
      names = c("breed", "sire_id", "sex", "agew", "Ww")
    ),
    ex33 = list(
      dim = c(168L, 4L),
      names = c("animal_id", "breed", "time", "PCV")
    )
  )

  for (dataset_name in names(expected)) {
    env <- new.env(parent = emptyenv())
    utils::data(
      list = dataset_name,
      package = "VetResearchLMM",
      envir = env
    )

    dataset <- env[[dataset_name]]
    expect_s3_class(dataset, "data.frame")
    expect_equal(dim(dataset), expected[[dataset_name]]$dim)
    expect_named(dataset, expected[[dataset_name]]$names)
  }
})

test_that("included datasets keep expected field classes", {
  expected_classes <- list(
    ex121 = c(
      animals = "integer",
      dose = "factor",
      PCV1 = "numeric",
      PCV2 = "numeric",
      PCVdiff = "numeric"
    ),
    ex124 = c(
      herd = "integer",
      drug = "factor",
      dose = "factor",
      PCVdif = "numeric"
    ),
    ex125 = c(
      Region = "integer",
      Drug = "factor",
      dose = "factor",
      Pcv = "numeric"
    ),
    ex127 = c(
      sire = "integer",
      Ww = "numeric"
    ),
    ex31 = c(
      herd = "integer",
      animal_id = "integer",
      PCV1 = "integer",
      PCV2 = "integer",
      dose = "integer",
      drug = "factor"
    ),
    ex32 = c(
      breed = "integer",
      sire_id = "integer",
      sex = "factor",
      agew = "integer",
      Ww = "numeric"
    ),
    ex33 = c(
      animal_id = "factor",
      breed = "factor",
      time = "integer",
      PCV = "numeric"
    )
  )

  for (dataset_name in names(expected_classes)) {
    env <- new.env(parent = emptyenv())
    utils::data(
      list = dataset_name,
      package = "VetResearchLMM",
      envir = env
    )

    dataset <- env[[dataset_name]]
    observed_classes <- vapply(
      dataset,
      function(column) class(column)[1L],
      character(1L)
    )
    expect_equal(observed_classes, expected_classes[[dataset_name]])
  }
})

test_that("the data sets added in version 2.0.0 have the shape of Appendix A", {
  expect_equal(dim(ex122), c(30L, 3L))
  expect_named(ex122, c("herd", "dose", "PCVdif"))
  expect_equal(dim(ex123), c(28L, 3L))
  expect_named(ex123, c("herd", "drug", "PCVdif"))
  expect_equal(dim(ex126), c(88L, 4L))
  expect_named(ex126, c("time", "replicat", "anim_id", "OD"))
  expect_equal(sum(ex122$PCVdif), 146.5, tolerance = 1e-10)
})

test_that("ex33 has 14 distinct days per animal after the corrections of version 2.0.0", {
  days <- tapply(ex33$time, ex33$animal_id, function(t) length(unique(t)))
  expect_true(all(days == 14L))
  expect_false(any(grepl(" ", levels(ex33$animal_id))))
})
