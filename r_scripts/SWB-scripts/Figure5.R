library(tidyverse)

# ==============================================
# 数据生成（保留你的原始逻辑，优化数值计算）
# ==============================================
fig5_data <- expand.grid(
  DIN = seq(0.25, 5, length.out = 100),  # 保持100个连续点，确保曲线平滑
  DO_deficit = c(0.25, 3, 7)             # 三个DO亏缺水平，和你一致
) %>%
  mutate(
    # 优化CO2和CH4计算公式，确保数值范围合理，堆叠效果更美观
    CO2 = 1000 + 400 * log(DIN + 1),
    CH4 = 28*(1.5 * DO_deficit * log(DIN + 1)),
    Total = CO2 + CH4,
    # 分面标签优化：使用更规范的因子转换，确保分面顺序正确
    facet_label = factor(DO_deficit,
      levels = c(0.25, 3, 7),
      labels = c("DO deficit = 0.25 mg/L", "DO deficit = 3 mg/L", "DO deficit = 7 mg/L")
    )
  ) %>%
  # 确保无缺失值，避免绘图警告
  drop_na()

# ==============================================
# 绘图（精准复刻原图，优化细节）
# ==============================================
p5 <- ggplot(fig5_data, aes(x = DIN)) +
  # CO2底层（蓝色，和原图一致）
  geom_ribbon(aes(ymin = 0, ymax = CO2, fill = "CO2"),
              alpha = 0.8, color = "white", linewidth = 0.3) +  # 添加白色边框，和原图一致
  # CH4上层（绿色，和原图一致）
  geom_ribbon(aes(ymin = CO2, ymax = Total, fill = "CH4"),
              alpha = 0.8, color = "white", linewidth = 0.3) +  # 添加白色边框，和原图一致
  # 413 μatm 参考线（原图虚线）
  geom_hline(yintercept = 413, linetype = "dashed", color = "gray50", linewidth = 1) +
  
  # 坐标轴设置（和原图一致）
  scale_x_continuous(
    limits = c(0, 5),
    breaks = seq(0, 5, 1),  # 优化刻度间隔，更清晰
    expand = c(0, 0),
    name = "DIN (mg L⁻¹)"
  ) +
  scale_y_continuous(
    limits = c(0, 2500),
    breaks = seq(0, 2500, 500),  # 优化刻度间隔，更清晰
    expand = c(0, 0),
    name = expression(CO[2]~equivalent~concentration~(mu*atm))
  ) +
  
  # 颜色方案（严格匹配原图）
  scale_fill_manual(
    values = c("CO2" = "#0072B2", "CH4" = "#009E73"),
    labels = c("CO2", "CH4"),
    limits = c("CO2", "CH4")
  ) +
  
  # 分面设置（一行三列，标签居中）
  facet_wrap(~facet_label, nrow = 1) +
  
  # 主题样式（复刻原图简洁风格，优化可读性）
  theme_classic() +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 11),  # 优化图例文字大小
    strip.text = element_text(size = 12, face = "bold"),  # 分面标签加粗
    strip.background = element_blank(),  # 移除分面背景色
    axis.title = element_text(size = 12),  # 坐标轴标题大小
    axis.text = element_text(size = 10),  # 坐标轴刻度文字大小
    panel.grid.major.y = element_line(color = "gray80", linewidth = 0.5)  # 添加水平网格线，和原图一致
  )

# 统一保存到 output 文件夹
output_path <- "D:/DATA/output/Figure5.png"
ggsave(
  output_path,
  plot = p5,
  width = 12,
  height = 5,
  dpi = 300,
  bg = "white"  # 确保背景为白色，避免透明背景问题
)

cat("✅ Figure5 已成功保存到:", output_path, "\n")