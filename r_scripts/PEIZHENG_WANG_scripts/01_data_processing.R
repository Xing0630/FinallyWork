source("PEIZHENG_WANG_scripts/00_setup.R")
# Read processed data directly

dat <- read.table(
  "PEIZHENG_WANG_data/processed/dat_completed.txt",
  sep = "\t",
  header = TRUE
)

# Quick inspection
str(dat)
summary(dat)

# Save clean version
write.table(
  dat,
  "PEIZHENG_WANG_data/processed/analysis_ready_data.txt",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

cat("Data processing completed.\n")

################################################################################
# Exploratory figures
################################################################################

# remove problematic metabolism estimates
dat[c(19, 28, 38, 41), c("GPP.mle","ER.mle")] <- NA

################################################################################
# figure output folder
################################################################################

dir.create("outputs/figures", showWarnings = FALSE)

plot_folder <- "outputs/figures/"

################################################################################
# rel_k600_ER
################################################################################

png(
  paste0(plot_folder, "图1:K600与生态呼吸关系图(rel_k600_ER).png"),
  width = 1800,
  height = 1800,
  res = 300,
  family = "Times"
)

par(
  family = "Times",
  mar = c(6,6,3,2),
  cex.lab = 1.8,
  cex.axis = 1.5
)

cor1 <- bquote(
  italic(r[P]) == .(
    round(
      cor(
        log(-dat$ER.mle),
        dat$K600_hyd,
        use = "complete.obs"
      ),
      2
    )
  )
)

plot(
  dat$K600_hyd ~ abs(dat$ER.mle),
  
  xlab = expression(
    ER ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  ),
  
  ylab = expression(
    k[600] ~ (m ~ d^{-1})
  ),
  
  pch = 21,
  bg = "red"
)

mod <- lm(
  K600_hyd ~ -ER.mle,
  data = dat,
  na.action = "na.omit"
)

abline(mod, col = "red", lwd = 4)

mtext(
  cor1,
  line = -1.5,
  adj = 0.8,
  cex = 1.5
)

dev.off()

################################################################################
# hist_ghg
################################################################################

png(
  paste0(plot_folder, "图2:代谢指标与温室气体浓度分布直方图(hist_ghg).png"),
  width = 3000,
  height = 2000,
  res = 300,
  family = "Times"
)

par(
  mfrow = c(2,3),
  family = "Times",
  mar = c(5,5,3,2),
  cex.lab = 1.5,
  cex.axis = 1.3
)

hist(
  dat$GPP.mle,
  col = "red",
  main = "",
  xlab = expression(
    GPP ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  )
)

hist(
  -dat$ER.mle,
  col = "red",
  main = "",
  xlab = expression(
    ER ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  )
)

hist(
  dat$NEP.mle,
  col = "red",
  main = "",
  xlab = expression(
    NEP ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  )
)

hist(
  dat$algal.production,
  col = "orange",
  main = "",
  xlab = expression(
    Algal ~ production
  )
)

hist(
  dat$pCO2,
  col = "steelblue3",
  main = "",
  xlab = expression(
    italic(p) * CO[2] ~ (mu * atm)
  )
)

hist(
  dat$pCH4,
  col = "green3",
  main = "",
  xlab = expression(
    italic(p) * CH[4] ~ (mu * atm)
  )
)

dev.off()

################################################################################
# rel_ghg
################################################################################

png(
  paste0(plot_folder, "图3:河流代谢与温室气体关系图(rel_ghg).png"),
  width = 3200,
  height = 3200,
  res = 300,
  family = "Times"
)

par(
  mfrow = c(2,2),
  family = "Times",
  mar = c(5,6,3,2),
  cex.lab = 1.5,
  cex.axis = 1.3
)

################################################################################
# GPP vs ER
################################################################################

cor1 <- bquote(
  italic(r[P]) == .(
    round(
      cor(
        dat$GPP.mle,
        dat$ER.mle,
        use = "complete.obs"
      ),
      2
    )
  )
)

plot(
  -dat$ER.mle ~ dat$GPP.mle,
  
  ylab = expression(
    ER ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  ),
  
  xlab = expression(
    GPP ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  ),
  
  pch = 21,
  bg = "red"
)

mod <- lm(-ER.mle ~ GPP.mle, data = dat, na.action = na.omit)

abline(mod, col = "red", lwd = 4)

abline(a = 0, b = 1, lty = 2)

mtext(
  cor1,
  line = -1.5,
  adj = 0.85,
  cex = 1.4
)

################################################################################
# NEP vs DO deficit
################################################################################

cor2 <- bquote(
  italic(r[P]) == .(
    round(
      cor(
        dat$NEP.mle,
        dat$do.def,
        use = "complete.obs"
      ),
      2
    )
  )
)

plot(
  dat$do.def ~ dat$NEP.mle,
  
  ylab = expression(
    DO ~ deficit ~ (mg ~ L^{-1})
  ),
  
  xlab = expression(
    NEP ~ (mmol ~ C ~ m^{-2} ~ d^{-1})
  ),
  
  pch = 21,
  bg = "red"
)

mod <- lm(do.def ~ NEP.mle, data = dat, na.action = na.omit)

abline(mod, col = "red", lwd = 4)

mtext(
  cor2,
  line = -1.5,
  adj = 0.9,
  cex = 1.4
)

################################################################################
# pCO2 vs FCO2
################################################################################

co2_col <- rep("steelblue3", nrow(dat))
co2_col[which(dat$FCO2.h < 0)] <- "gold"

cor3 <- bquote(
  italic(r[P]) == .(
    round(
      cor(
        dat$pCO2,
        dat$FCO2.h,
        use = "complete.obs"
      ),
      2
    )
  )
)

plot(
  dat$FCO2.h ~ dat$pCO2,
  
  pch = 21,
  bg = co2_col,
  
  ylab = expression(
    italic(F) * CO[2] ~ (mmol ~ m^{-2} ~ d^{-1})
  ),
  
  xlab = expression(
    italic(p) * CO[2] ~ (mu * atm)
  )
)

mod <- lm(FCO2.h ~ pCO2, data = dat, na.action = na.omit)

abline(mod, col = "steelblue3", lwd = 4)

abline(h = 0, lty = 2)

mtext(
  cor3,
  line = -1.5,
  adj = 0.9,
  cex = 1.4
)

################################################################################
# pCH4 vs FCH4
################################################################################

cor4 <- bquote(
  italic(r[P]) == .(
    round(
      cor(
        dat$pCH4,
        dat$FCH4.h,
        use = "complete.obs"
      ),
      2
    )
  )
)

plot(
  dat$FCH4.h ~ dat$pCH4,
  
  pch = 21,
  bg = "green3",
  
  ylab = expression(
    italic(F) * CH[4] ~ (mmol ~ m^{-2} ~ d^{-1})
  ),
  
  xlab = expression(
    italic(p) * CH[4] ~ (mu * atm)
  )
)

mod <- lm(FCH4.h ~ pCH4, data = dat, na.action = na.omit)

abline(mod, col = "green3", lwd = 4)

mtext(
  cor4,
  line = -1.5,
  adj = 0.9,
  cex = 1.4
)

dev.off()

cat("Exploratory figures completed.\n")