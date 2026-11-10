# Audit of VetResearchLMM 1.1.0 and the book

Findings while rebuilding the package as version 2.0.0 against Duchateau, Janssen and Rowlands (1998).

1. **ex33, BO322**: two measurements on day 23; Appendix A has days 23 and 25. Fixed.
2. **ex33, ND66**: a measurement on day 26; Appendix A has day 25. Fixed.
3. **ex33, "BO326 "**: the animal identifier had a trailing space. Fixed.
   With findings 1-3 the variance components of Example 3.3 were 5.522 and 4.943 instead of the printed 5.478 and
   4.965, and a spatial power model in time could not be fitted (two observations on one day). All printed values of Example 3.3 are now reproduced.
4. **Missing data sets**: Examples 1.2.2, 1.2.3 and 1.2.6 were not in the package. Added as ex122, ex123, ex126.
5. **ex31, ex32**: the book prints only part of these data; the printed results of Examples 3.1 and 3.2 cannot be
   reproduced from them (documented).
6. **Example 2.4.3.1**: the sire variance is printed as 3.685; REML gives 3.6855 (also lme4 and nlme): truncated.
7. **Example 2.2.1.7**: the variance 0.875 of the estimate uses the rounded error mean square 2.8; with 2.81 it is
   0.878. The text gives F = 14.36, the SAS output 14.37 (14.365).
8. **Example 2.5.3.1**: the variances 1.0975 and 0.698 are computed from rounded variance components (exact:
   1.0977 and 0.6988); the confidence half-width 2.56 uses 6 rather than the Satterthwaite 6.2 degrees of freedom.
9. **Example 3.3, Model 3**: SAS 6.12 printed 144 denominator degrees of freedom for breed and the slopes; the
   current containment rule gives 10 (the random slope per animal contains breed*time).
10. **Book ISBN**: 92-9146-038-9 (page ii).
11. **Version 1.1.0 code**: the examples relied on lme4 with treatment contrasts and asymptotic degrees of freedom,
   which do not give the book's SAS results (overparameterised solutions, containment or Satterthwaite df, EMS).
