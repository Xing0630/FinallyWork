dat <- read.delim("data/dat.txt", sep = "\t", header = TRUE)

dat <- dat %>%
  mutate(
    ER = abs(ER.mle),
    NEP = GPP.mle - ER,
    DO_deficit = 10 - DOmean
  ) %>%
  filter(complete.cases(GPP.mle, ER, NEP, DO_deficit, pCO2, FCO2.h, pCH4, FCH4.h))

p2a <- ggplot(dat, aes(x = GPP.mle, y = ER)) +
  geom_point(size = 2, color = "red") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  geom_abline(slope = 1, linetype = "dashed", color = "gray") +
  labs(x = "GPP (mmol C m⁻² day⁻¹)", y = "ER (mmol C m⁻² day⁻¹)") +
  theme_classic()

p2b <- ggplot(dat, aes(x = NEP, y = DO_deficit)) +
  geom_point(size = 2, color = "red") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(x = "NEP (mmol C m⁻² day⁻¹)", y = "DO deficit (mg L⁻¹)") +
  theme_classic()

p2c <- ggplot(dat, aes(x = pCO2, y = FCO2.h)) +
  geom_point(size = 2, color = "blue") +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  labs(x = "pCO2 (μatm)", y = "FCO2 (mmol m⁻² day⁻¹)") +
  theme_classic()

p2d <- ggplot(dat, aes(x = pCH4, y = FCH4.h)) +
  geom_point(size = 2, color = "green") +
  geom_smooth(method = "lm", color = "green", se = FALSE) +
  labs(x = "pCH4 (μatm)", y = "FCH4 (mmol m⁻² day⁻¹)") +
  theme_classic()

p2 <- plot_grid(p2a, p2b, p2c, p2d, ncol = 2, labels = c("a","b","c","d"), align = "hv")

# 统一保存到 output
ggsave("D:/DATA/output/Figure2.png", plot = p2, width=10, height=8, dpi=300, bg="white")