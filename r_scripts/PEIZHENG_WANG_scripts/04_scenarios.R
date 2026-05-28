################################################################################
# 05 Scenarios
################################################################################

# 设置输出目录
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)

plot_folder <- "outputs/figures/"

################################################################################
# 加载包
################################################################################

library(usdm)
library(corrplot)
library(ade4)
library(viridis)
library(MuMIn)

library(ggplot2)
library(ggtext)
library(patchwork)

################################################################################
# 读取模型
################################################################################

load("outputs/tables/saved_models.RData")

################################################################################
# 读取数据
################################################################################

# standardized 数据（用于模型预测）
dat <- read.table(
  "PEIZHENG_WANG_data/processed/prepared_dat.txt",
  sep = "\t",
  header = TRUE
)

# raw 数据（用于 back-transform 和绘图）
dat_raw <- read.table(
  "PEIZHENG_WANG_data/processed/dat_completed.txt",
  sep = "\t",
  header = TRUE
)

################################################################################
# back-standardization parameters
################################################################################

sd(log(dat_raw$pCO2)) -> sd.co2
mean(log(dat_raw$pCO2)) -> m.co2

sd(log(dat_raw$pCH4)) -> sd.ch4
mean(log(dat_raw$pCH4)) -> m.ch4

sd(log(dat_raw$din)) -> sd.din
mean(log(dat_raw$din)) -> m.din

sd(dat_raw$tmean) -> sd.tmean
mean(dat_raw$tmean) -> m.tmean

sd(log(dat_raw$discharge)) -> sd.disc
mean(log(dat_raw$discharge)) -> m.disc

sd(log(dat_raw$do.def)) -> sd.do
mean(log(dat_raw$do.def)) -> m.do

################################################################################
# 创建 DIN sequence
################################################################################

# raw DIN sequence（用于 x 轴）
n.seq_raw <- seq(
  min(dat_raw$din, na.rm = TRUE),
  max(dat_raw$din, na.rm = TRUE),
  length.out = 1000
)

# standardized DIN sequence（用于模型）
n.seq <- (log(n.seq_raw) - m.din) / sd.din

################################################################################
# 颜色
################################################################################

col_ghg <- viridis(4)

################################################################################
# CO2 prediction
################################################################################

mod.aicc <- sapply(mods_co2, AICc)

mod.weights <- exp(-0.5 * (mod.aicc - min(mod.aicc)))
mod.weights <- mod.weights / sum(mod.weights)

mod.pred <- data.frame(
  lapply(mods_co2, function(x){
    
    predict(
      x,
      data.frame(
        din = n.seq,
        tmean = mean(dat$tmean, na.rm = TRUE),
        discharge = mean(dat$discharge, na.rm = TRUE),
        rip_open = mean(dat$rip_open, na.rm = TRUE)
      )
    )
    
  })
)

pred_vals <- apply(
  mod.pred,
  1,
  function(x) sum(x * mod.weights, na.rm = TRUE)
)

# 防止 overflow
pred_vals[pred_vals > 20] <- 20
pred_vals[pred_vals < -20] <- -20

co2_pred <- exp((pred_vals * sd.co2) + m.co2)

co2_pred[!is.finite(co2_pred)] <- NA


################################################################################
# Scenario matrix
################################################################################

din_vals <- c(0.25,0.5,1,2.5,5)

din_std <- (log(din_vals) - m.din) / sd.din

################################################################################
# CO2 matrix
################################################################################

mod.aicc <- sapply(mods_co2, AICc)

mod.weights <- exp(-0.5 * (mod.aicc - min(mod.aicc)))
mod.weights <- mod.weights / sum(mod.weights)

mod.pred <- data.frame(
  lapply(mods_co2, function(x){
    
    predict(
      x,
      data.frame(
        din = din_std,
        tmean = mean(dat$tmean, na.rm = TRUE),
        discharge = mean(dat$discharge, na.rm = TRUE),
        rip_open = mean(dat$rip_open, na.rm = TRUE)
      )
    )
    
  })
)

pred_vals <- apply(
  mod.pred,
  1,
  function(x) sum(x * mod.weights, na.rm = TRUE)
)

pred_vals[pred_vals > 20] <- 20
pred_vals[pred_vals < -20] <- -20

co2_pred <- exp((pred_vals * sd.co2) + m.co2)

################################################################################
# CH4 matrix
################################################################################

ch4_pred <- matrix(NA, nrow = 3, ncol = 5)

a <- 0

for(i in c(0.25, 1.5, 7)){
  
  a <- a + 1
  
  mod.aicc <- sapply(mods_ch4, AICc)
  
  mod.weights <- exp(-0.5 * (mod.aicc - min(mod.aicc)))
  mod.weights <- mod.weights / sum(mod.weights)
  
  mod.pred <- data.frame(
    
    lapply(mods_ch4, function(x){
      
      predict(
        x,
        data.frame(
          din = din_std,
          tmean = mean(dat$tmean, na.rm = TRUE),
          do.def = (log(i) - m.do) / sd.do,
          discharge = mean(dat$discharge, na.rm = TRUE),
          rip_open = mean(dat$rip_open, na.rm = TRUE)
        )
      )
      
    })
    
  )
  
  pred_vals <- apply(
    mod.pred,
    1,
    function(x) sum(x * mod.weights, na.rm = TRUE)
  )
  
  pred_vals[pred_vals > 20] <- 20
  pred_vals[pred_vals < -20] <- -20
  
  ch4_pred[a,] <- exp((pred_vals * sd.ch4) + m.ch4)
  
}

################################################################################
# stacked data
################################################################################

ch4_pred <- ch4_pred * 28

stacked_data1 <- data.frame(
  din = rep(din_vals, 2),
  co2_eq = c(co2_pred, ch4_pred[1,]),
  gas = rep(c("CO2","CH4"), each = 5)
)

stacked_data2 <- data.frame(
  din = rep(din_vals, 2),
  co2_eq = c(co2_pred, ch4_pred[2,]),
  gas = rep(c("CO2","CH4"), each = 5)
)

stacked_data3 <- data.frame(
  din = rep(din_vals, 2),
  co2_eq = c(co2_pred, ch4_pred[3,]),
  gas = rep(c("CO2","CH4"), each = 5)
)

################################################################################
# plotting function
################################################################################

make_plot <- function(dat, ttl){
  
  ggplot(dat) +
    
    geom_area(
      aes(din, co2_eq, fill = gas),
      color = "white"
    ) +
    
    geom_hline(
      yintercept = 413,
      lty = 2,
      linewidth = 1,
      col = "grey50"
    ) +
    
    scale_fill_manual(
      values = c(
        "CO2" = "steelblue3",
        "CH4" = "green3"
      ),
      labels = c(
        expression(CH[4]),
        expression(CO[2])
      ),
      name = NULL
    ) +
    
    scale_x_continuous(
      limits = c(0,5),
      breaks = c(0,1,2,3,4,5),
      labels = c("0","1","2","3","4","5"),
      expand = c(0,0)
    ) +
    
    scale_y_continuous(
      limits = c(0,2500),
      expand = c(0,0)
    ) +
    
    labs(
      title = ttl,
      x = "DIN",
      y = expression(CO[2]*"-equivalent concentration ("*mu*"atm)")
    ) +
    
    theme_bw(base_family = "Times") +
    
    theme(
      
      legend.position = "top",
      
      panel.grid = element_blank(),
      
      plot.title = element_text(
        size = 16,
        face = "bold"
      ),
      
      axis.title = element_text(size = 15),
      
      axis.text = element_text(size = 13),
      
      legend.text = element_text(size = 13),
      
      plot.margin = margin(15,20,15,20)
      
    )
  
}

################################################################################
# generate plots
################################################################################

plt1 <- make_plot(stacked_data1, "DO deficit = 0.25 mg/L")
plt2 <- make_plot(stacked_data2, "DO deficit = 1.5 mg/L")
plt3 <- make_plot(stacked_data3, "DO deficit = 7 mg/L")

final_plot <- (plt1 | plt2 | plt3) +
  plot_layout(guides = "collect") &
  theme(legend.position = "top")

################################################################################
# save final figure
################################################################################

ggsave(
  filename = paste0(plot_folder, "图15:DIN浓度与DO亏缺对CO₂和CH₄(CO₂当量)的情景响应(scenarios_final).png"),
  plot = final_plot,
  width = 15,
  height = 5,
  dpi = 300
)