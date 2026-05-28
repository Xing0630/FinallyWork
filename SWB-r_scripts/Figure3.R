library(tidyverse)
library(patchwork)

# 读取数据（用你真实存在的列名drop_na，不影响后续绘图）
dat <- read.delim("data/dat.txt", sep = "\t", header = TRUE) %>%
  drop_na(air_mean_temp, DOmean, flow_vel, site)

# 你的原图模拟数据（完全不变）
coef_data <- tibble(
  predictor = factor(
    c("Temperature", "DO Saturation", "Site1", "Site2"),
    levels = c("Site2", "Site1", "DO Saturation", "Temperature")
  ),
  std_coef = c(0.6, 0.4, 0.1, 0.1),
  se = rep(0.1, 4),
  r2 = c(40, 15, 0, 0)
)

# 绘图（你的原图样式，完全不变）
p3a_coef <- ggplot(coef_data, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
  geom_point(shape = 15, size = 3, color = "red") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "red") +
  labs(title = "(a) Dissolved Oxygen", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p3a_r2 <- ggplot(coef_data, aes(y = predictor, x = r2)) +
  geom_col(fill = "red", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 40), breaks = seq(0, 40, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

# 图b/c/d保持你的原图样式不变
p3b_coef <- ggplot(coef_data, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
  geom_point(shape = 15, size = 3, color = "red") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "red") +
  labs(title = "(b) Site Variation", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p3b_r2 <- ggplot(coef_data, aes(y = predictor, x = r2)) +
  geom_col(fill = "red", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 40), breaks = seq(0, 40, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

p3c_coef <- ggplot(coef_data, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
  geom_point(shape = 15, size = 3, color = "red") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "red") +
  labs(title = "(c) Temporal Trend", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p3c_r2 <- ggplot(coef_data, aes(y = predictor, x = r2)) +
  geom_col(fill = "red", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 40), breaks = seq(0, 40, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

p3d_coef <- ggplot(coef_data, aes(y = predictor, x = std_coef)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
  geom_point(shape = 15, size = 3, color = "orange") +
  geom_errorbarh(aes(xmin = std_coef - se, xmax = std_coef + se), height = 0.2, color = "orange") +
  labs(title = "(d) Saturation Drivers", x = "Standardized coefficient", y = "") +
  scale_x_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0, size = 12, face = "bold"))

p3d_r2 <- ggplot(coef_data, aes(y = predictor, x = r2)) +
  geom_col(fill = "orange", color = "black", width = 0.7) +
  labs(x = "Explained variance (%)", y = "") +
  scale_x_continuous(limits = c(0, 40), breaks = seq(0, 40, 10)) +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

# 拼接和保存（和你的原图完全一致）
final_plot <- (p3a_coef + p3a_r2) / (p3b_coef + p3b_r2) / (p3c_coef + p3c_r2) / (p3d_coef + p3d_r2) + plot_layout(widths = c(2, 1))
ggsave("D:/DATA/output/Figure3_Final.png", plot = final_plot, width = 10, height = 12, dpi = 300, bg = "white")