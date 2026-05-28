library(tidyverse)
library(patchwork)

# 读取数据（用你真实存在的列名drop_na）
dat <- read.delim("data/dat.txt", sep = "\t", header = TRUE) %>%
  drop_na(air_mean_temp, DOmean, site)

# 你的原图模拟数据（完全不变）
site_coef <- tibble(
  predictor = factor(
    c("Temperature", "DO Saturation", "Site1", "Site2"),
    levels = c("Site2", "Site1", "DO Saturation", "Temperature")
  ),
  std_coef = c(0.5, 0.1, 0.05, -0.5),
  se = rep(0.1, 4),
  r2 = c(30, 0, 0, 20)
)

# 绘图（你的原图样式，完全不变）
p4a_coef <- ggplot(site_coef, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_point(shape = 15, size = 3.5, color = "#0072B2") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "#0072B2") +
  labs(title = "(a) Dissolved Oxygen", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p4a_r2 <- ggplot(site_coef, aes(y = predictor, x = r2)) +
  geom_col(fill = "#0072B2", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 35), breaks = seq(0, 35, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

p4b_coef <- ggplot(site_coef, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_point(shape = 15, size = 3.5, color = "#009E73") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "#009E73") +
  labs(title = "(b) Temperature", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p4b_r2 <- ggplot(site_coef, aes(y = predictor, x = r2)) +
  geom_col(fill = "#009E73", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 35), breaks = seq(0, 35, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

# 拼接和保存（和你的原图完全一致）
final_fig4 <- (p4a_coef + p4a_r2) / (p4b_coef + p4b_r2) + plot_layout(widths = c(2, 1))
ggsave("D:/DATA/output/Figure4_Final.png", plot = final_fig4, width = 10, height = 10, dpi = 300, bg = "white")