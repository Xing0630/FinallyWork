# Setting results plots
plot_folder <- "outputs/figures/"

# Loading packages
library(MuMIn)
library(usdm)
library(corrplot)
library(ade4)
library(viridis)
library(lattice)
library(relaimpo)

source("PEIZHENG_WANG_scripts/00_setup.R")

# 创建输出目录
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)

# Read data

dat <- read.table(
  "PEIZHENG_WANG_data/processed/prepared_dat.txt",
  sep = "\t",
  header = TRUE
)

# Removing sites with bad metabolic estimations
dat.m<-dat[-c(19, 28, 38, 41),]

# Evaluating predictor collinearity
vifstep(dat[,c("din","do.def","tmean","discharge","rip_open")])

################################################################################
# Multiple stressor effects on metabolism and GHGs (Multi-model inference)
################################################################################

# Creating a list
# Creating lists to store model results
ci<-avg<-r2_order<-mod_set<-res_d<-res_d_full<-res<-list() # to store data

#Models for multiple stressors analysis
options (na.action="na.fail") # necessary to run dredge()

#######################################################################
# GPP
#######################################################################

i=1

#Global model
mod1<-lm(GPP.mle~din+tmean+discharge+rip_open,data=dat.m)

# Models including interactions
mod2<-lm(GPP.mle~din+tmean+discharge+rip_open+din:rip_open,data=dat.m)
mod3<-lm(GPP.mle~din+tmean+discharge+rip_open+din:tmean,data=dat.m)
mod4<-lm(GPP.mle~din+tmean+discharge+rip_open+din:discharge,data=dat.m)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

mod<-mod1 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_gpp <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_gpp)->n.mod

for (k in 1:n.mod) 
{
  mods_gpp[[k]]->mod
}

# Variance partitioning
library(relaimpo)

calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
) -> relimp_res

res[[i]] <- relimp_res$lmg

# Weighted partitioned variance
res[[i]]<-apply(var.part, 2, function(x) weighted.mean(x, mod_set[[i]]$weight))
res[[i]]

#######################################################################
# ER
#######################################################################

i=2

#Global model
mod1<-lm(ER.mle~din+tmean+discharge+rip_open,data=dat.m)

# Models including interactions
mod2<-lm(ER.mle~din+tmean+discharge+rip_open+din:rip_open,data=dat.m)
mod3<-lm(ER.mle~din+tmean+discharge+rip_open+din:tmean,data=dat.m)
mod4<-lm(ER.mle~din+tmean+discharge+rip_open+din:discharge,data=dat.m)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

# Testing if mod2 has better explanatory capacity than mod1
anova(mod1, mod2)

mod<-mod1 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_er <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_er)->n.mod

for (k in 1:n.mod) 
{
  mods_er[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

# Weighted partitioned variance
res[[i]]<-apply(var.part, 2, function(x) weighted.mean(x, mod_set[[i]]$weight))
res[[i]]

#######################################################################
# NEP
#######################################################################

i=3

#Global model
mod1<-lm(NEP.mle~din+tmean+discharge+rip_open,data=dat.m)

# Models including interactions
mod2<-lm(NEP.mle~din+tmean+discharge+rip_open+din:rip_open,data=dat.m)
mod3<-lm(NEP.mle~din+tmean+discharge+rip_open+din:tmean,data=dat.m)
mod4<-lm(NEP.mle~din+tmean+discharge+rip_open+din:discharge,data=dat.m)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

mod<-mod1 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_nep <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_nep)->n.mod

for (k in 1:n.mod) 
{
  mods_nep[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

#######################################################################
# algal production
#######################################################################

i=4

#Global model
mod1<-lm(algal.production~din+tmean+discharge+rip_open,data=dat)

# Models including interactions
mod2<-lm(algal.production~din+tmean+discharge+rip_open+din:rip_open,data=dat)
mod3<-lm(algal.production~din+tmean+discharge+rip_open+din:tmean,data=dat)
mod4<-lm(algal.production~din+tmean+discharge+rip_open+din:discharge,data=dat)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

mod<-mod1 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_algal <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_algal)->n.mod

for (k in 1:n.mod) 
{
  mods_algal[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

#######################################################################
# pCO2
#######################################################################

i=5

#Global model
mod1<-lm(pCO2~din+tmean+discharge+rip_open,data=dat)

# Models including interactions
mod2<-lm(pCO2~din+tmean+discharge+rip_open+din:rip_open,data=dat)
mod3<-lm(pCO2~din+tmean+discharge+rip_open+din:tmean,data=dat)
mod4<-lm(pCO2~din+tmean+discharge+rip_open+din:discharge,data=dat)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

mod<-mod1 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_co2 <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_co2)->n.mod

for (k in 1:n.mod) 
{
  mods_co2[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

#######################################################################
# pCH4
#######################################################################

i=6

#Global model
mod1<-lm(pCH4~din+do.def+tmean+discharge+rip_open,data=dat)

# Models including interactions
mod2<-lm(pCH4~din+do.def+tmean+discharge+rip_open+din:rip_open,data=dat)
mod3<-lm(pCH4~din+do.def+tmean+discharge+rip_open+din:tmean,data=dat)
mod4<-lm(pCH4~din+do.def+tmean+discharge+rip_open+din:discharge,data=dat)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

# Comparing the explanatory capacity of mod1 and mod3
anova(mod1, mod3)

mod<-mod3 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_ch4 <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_ch4)->n.mod

for (k in 1:n.mod) 
{
  mods_ch4[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

#######################################################################
# Molar ratio CH4:CO2
#######################################################################

i=7

#Global model
mod1<-lm(ch4co2_ratio~din+do.def+tmean+discharge+rip_open,data=dat)

# Models including interactions
mod2<-lm(ch4co2_ratio~din+do.def+tmean+discharge+rip_open+din:rip_open,data=dat)
mod3<-lm(ch4co2_ratio~din+do.def+tmean+discharge+rip_open+din:tmean,data=dat)
mod4<-lm(ch4co2_ratio~din+do.def+tmean+discharge+rip_open+din:discharge,data=dat)

# Identifying best model structure (with or without interactions)
AICc(mod1, mod2, mod3, mod4)

# Comparing the explanatory capacity of mod1 and mod3
anova(mod1, mod3)

mod<-mod3 # Choosing most supported structure

# Producing all potential predictor combinations
mod_d<- dredge(mod, rank="AICc", extra=c("R^2"))

mod_d[which(mod_d$delta<=7), ]->res_d[[i]]
mod_d[as.character(1:nrow(mod_d)),]->r2_order[[i]]

# Selecting models to do inference
mod_set[[i]] <- subset(mod_d, delta<=7)
mod_set[[i]]

# coefficients average and CI
avg[[i]]<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,1]
se<-summary(model.avg(get.models(mod_d, delta<=7)))$coefmat.subset[-1,2]

ci1<-avg[[i]] - qnorm(0.975)*as.numeric(se)
ci2<-avg[[i]] + qnorm(0.975)*as.numeric(se)

ci[[i]]<-data.frame(ci1,ci2)

# Getting models (we can use these models for other operations)
mods_ch4co2_ratio <- get.models (mod_d, subset=delta<=7) # subset 

# Checking model assumptions (see PDFs in plots/assum/ folder)
length(mods_ch4co2_ratio)->n.mod

for (k in 1:n.mod) 
{
  mods_ch4co2_ratio[[k]]->mod
}

# Variance partitioning
relimp_res <- calc.relimp(
  mod,
  type = "lmg",
  rela = TRUE
)

res[[i]] <- relimp_res$lmg

# Saving model results

write.table(as.data.frame(mod_set[[1]]), "outputs/tables/gpp_mods.txt", sep = "\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[2]]), "outputs/tables/er_mods.txt", sep="\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[3]]), "outputs/tables/nep_mods.txt", sep="\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[4]]), "outputs/tables/algal_mods.txt", sep="\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[5]]), "outputs/tables/pco2_mods.txt", sep="\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[6]]), "outputs/tables/pch4_mods.txt", sep="\t", row.names = FALSE)
write.table(as.data.frame(mod_set[[7]]), "outputs/tables/ch4co2_ratio_mods.txt", sep="\t", row.names = FALSE)

######################
# Model plots
#######################

var_col<-c("red","red","red","orange","blue","green")

var_names<-c("GPP", "ER","NEP","Algal production", "pCO2" ,"pCH4")

# GPP

ci.d<-ci[[1]][order(avg[[1]]),]
avg.d<-avg[[1]][order(avg[[1]])]

png(filename = paste0(plot_folder, "图4:总初级生产力回归系数图(gpp_coef).png"), width = 1800, height = 1600, res = 300)
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1)),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="red")
          panel.xyplot(x, y, pch=15, cex=2,col="red")
          panel.abline(v=0, col="black", lty=2)
          }))

if(dev.cur() > 1) dev.off()

# ER

ci.d<-ci[[2]][order(avg[[2]]),]
avg.d<-avg[[2]][order(avg[[2]])]

png(filename = paste0(plot_folder, "图5:生态系统呼吸回归系数图(er_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="red")
          panel.xyplot(x, y, pch=15, cex=2,col="red")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

# NEP

ci.d<-ci[[3]][order(avg[[3]]),]
avg.d<-avg[[3]][order(avg[[3]])]

png(filename = paste0(plot_folder, "图6:净生态系统生产力回归系数图(nep_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="red")
          panel.xyplot(x, y, pch=15, cex=2,col="red")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

# algal

ci.d<-ci[[4]][order(avg[[4]]),]
avg.d<-avg[[4]][order(avg[[4]])]

png(filename = paste0(plot_folder, "图7:藻类生产力回归系数图(algal_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="orange")
          panel.xyplot(x, y, pch=15, cex=2,col="orange")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

# pCO2

ci.d<-ci[[5]][order(avg[[5]]),]
avg.d<-avg[[5]][order(avg[[5]])]

png(filename = paste0(plot_folder, "图8:CO₂分压标准化回归系数图(pco2_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="blue")
          panel.xyplot(x, y, pch=15, cex=2,col="blue")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

# pCH4

ci.d<-ci[[6]][order(avg[[6]]),]
avg.d<-avg[[6]][order(avg[[6]])]

png(filename = paste0(plot_folder, "图9:CH₄分压标准化回归系数图(pch4_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="green")
          panel.xyplot(x, y, pch=15, cex=2,col="green")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

# CH4:CO2 ratio

ci.d<-ci[[7]][order(avg[[7]]),]
avg.d<-avg[[7]][order(avg[[7]])]

png(filename = paste0(plot_folder, "图10:甲烷—二氧化碳比值回归系数图(ch4co2_coef).png"), width = 1800, height = 1600, res = 300, family = "Times")
print(dotplot(avg.d, xlab="Standardized coefficient", xlim=c(-1.05, 1.05),
        
        par.settings = list(axis.text = list(cex = 2, font=1), 
                            par.xlab.text = list(cex = 2, font=1), 
                            par.ylab.text = list(cex = 2, font=1), family = "Times"),
        panel=function(x,y){
          panel.segments(ci.d[,1], as.numeric(y), ci.d[,2], as.numeric(y), lty=1, col="violet")
          panel.xyplot(x, y, pch=15, cex=2,col="violet")
          panel.abline(v=0, col="black", lty=2)
          
        }))

if(dev.cur() > 1) dev.off()

########################################
# Variance partition plots
########################################

# Metabolism

png(filename = paste0(plot_folder, "图11:生态代谢方差分解图(var_part_metab).png"), width = 2500, height = 6000, res = 300)
par(mfrow=c(4,1), cex=2, cex.lab=1, cex.axis=1, mar=c(4,6,3,4),family = "Times") 

barplot(100*sort(res[[1]]),col=var_col[1],xlab="",
        horiz=T,las=1, xlim=c(0,40),main=var_names[1]) 

barplot(100*sort(res[[2]]),col=var_col[2],xlab="",
        horiz=T,las=1, xlim=c(0,40),main=var_names[2]) 

barplot(100*sort(res[[3]]),col=var_col[3],xlab="",
        horiz=T,las=1, xlim=c(0,40),main=var_names[3]) 

barplot(100*sort(res[[4]]),col=var_col[4],xlab="Explained variance (%)",
        horiz=T,las=1, xlim=c(0,40),main=var_names[4]) 

dev.off()

# GHGs
png(filename = paste0(plot_folder, "图12:温室气体方差分解图(var_part_ghg).png"), width = 2500, height = 3000, res = 300)
par(mfrow=c(2,1), cex=2, cex.lab=1, cex.axis=1, mar=c(4,6,3,4), family = "Times") 

barplot(100*sort(res[[5]]),col=var_col[5],xlab="",
        horiz=T,las=1, xlim=c(0,40),main=var_names[5]) 

barplot(100*sort(res[[6]]),col=var_col[6],xlab="Explained variance (%)",
        horiz=T,las=1, xlim=c(0,40),main=var_names[6]) 

dev.off()

# CH4:CO2 ratio

png(filename = paste0(plot_folder, "图13:CH₄CO₂比值方差分解图.png"), width = 1800, height = 1600, res = 300)
par(mfrow=c(1,1), cex=1.6, cex.lab=1.3, cex.axis=1.2, mar=c(3,6,3,4),family = "Times") 

barplot(100*sort(res[[7]]),col="violet",xlab="Explained variance (%)",
        horiz=T,las=1, xlim=c(0,40)) 

dev.off()

# Save model variables
save.image("outputs/tables/saved_models.RData")

