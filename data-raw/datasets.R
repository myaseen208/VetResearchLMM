#-------------------------------------------------------------------------------------------------------------------
# Data sets of Appendix A of Duchateau, Janssen and Rowlands (1998) that version 1.1.0 did not contain: ex122, ex123
# and ex126. The values were typed from the book; data/ex121, ex124, ex125, ex127, ex31, ex32 and ex33 are kept as
# they were in version 1.1.0 (same column names, so old code keeps working).
# Run from the package root: Rscript data-raw/datasets.R
#-------------------------------------------------------------------------------------------------------------------

ex122 <-
  data.frame(
      herd   = factor(rep(1:3, each = 10))
    , dose   = factor(rep(rep(c("L", "H"), each = 5), times = 3), levels = c("H", "L"))
    , PCVdif = c(
          0.9, 2.0, 2.0, 2.2, 2.0, 7.4, 6.8, 7.1, 6.7, 7.9
        , 2.3, 2.7, 1.3, 1.6, 2.1, 6.6, 7.1, 6.2, 7.8, 7.2
        , 3.4, 2.7, 2.8, 3.0, 3.4, 8.8, 8.3, 7.9, 8.2, 8.1
        )
    )

ex123 <-
  data.frame(
      herd   = factor(rep(1:4, each = 7))
    , drug   = factor(rep(c("Berenil", "Samorin"), each = 14))
    , PCVdif = c(
          7.1, 6.6, 5.8, 6.3, 6.4, 7.0, 7.3
        , 6.9, 6.3, 7.6, 7.7, 7.6, 7.1, 7.5
        , 6.8, 6.9, 7.6, 7.9, 7.5, 6.8, 7.0
        , 8.0, 8.1, 7.1, 6.9, 8.2, 7.7, 7.6
        )
    )

od <- matrix(
    c(
        0.910, 0.806, 0.675, 0.639
      , 0.923, 0.807, 0.685, 0.639
      , 0.929, 0.743, 0.682, 0.581
      , 0.907, 0.746, 0.686, 0.584
      , 0.924, 0.802, 0.708, 0.560
      , 0.918, 0.803, 0.703, 0.564
      , 0.929, 0.820, 0.649, 0.572
      , 0.927, 0.828, 0.631, 0.582
      , 0.876, 0.819, 0.696, 0.619
      , 0.875, 0.825, 0.684, 0.640
      , 0.911, 0.752, 0.709, 0.600
      , 0.914, 0.760, 0.704, 0.603
      , 0.919, 0.753, 0.668, 0.604
      , 0.937, 0.750, 0.659, 0.587
      , 0.906, 0.738, 0.684, 0.602
      , 0.906, 0.754, 0.688, 0.605
      , 0.952, 0.817, 0.690, 0.544
      , 0.954, 0.803, 0.690, 0.565
      , 0.975, 0.808, 0.731, 0.628
      , 0.961, 0.802, 0.716, 0.613
      , 0.923, 0.789, 0.711, 0.618
      , 0.930, 0.793, 0.705, 0.618
      )
  , ncol  = 4L
  , byrow = TRUE
  )
ex126 <-
  data.frame(
      time     = rep(rep(1:11, each = 2), times = 4)
    , replicat = factor(rep(rep(1:2, times = 11), times = 4))
    , anim_id  = factor(rep(1:4, each = 22))
    , OD       = as.vector(od)
    )
ex126 <- ex126[order(ex126$time, ex126$replicat, ex126$anim_id), ]
rownames(ex126) <- NULL

save(ex122, file = "data/ex122.RData", compress = "xz")
save(ex123, file = "data/ex123.RData", compress = "xz")
save(ex126, file = "data/ex126.RData", compress = "xz")

# ex33 as in version 1.1.0, with three typing errors corrected against Appendix A: the 11th measurement of BO322 is at
# day 25 (not a second day 23), that of ND66 is at day 25 (not 26), and the identifier "BO326 " had a trailing space.
load("data/ex33.RData")
if (any(grepl(" $", levels(ex33$animal_id)))) {
  ex33$animal_id <- factor(trimws(as.character(ex33$animal_id)))
  i <- which(ex33$animal_id == "BO322")
  ex33$time[i[11L]] <- 25L
  i <- which(ex33$animal_id == "ND66" & ex33$time == 26L)
  ex33$time[i] <- 25L
  save(ex33, file = "data/ex33.RData", compress = "xz")
}
