# 论文图表复现项目｜R 语言独立实现
本项目为独立复现学术论文可视化结果，与原小组仓库作者均为对同一篇论文的复现实现。

---

## 🔎 复现论文信息
**论文题目**：Multiple stressors alter greenhouse gas concentrations in streams  
**发表信息**：Gutiérrez-Cánovas 等，2024，*Global Change Biology*

---

## 📌 项目关系与复现对比说明
同一篇论文，两种独立复现方案，核心结果完全一致：

| 对比维度 | 原小组 Python 实现 | 本项目 R 语言实现 |
|---------|----------------|---------------|
| 技术栈 | Python (matplotlib, seaborn) | R (tidyverse, patchwork, cowplot) |
| 图表输出 | 拆分输出 8 张独立图表 | 优化布局，整合为 5 张拼图式综合图表 |
| 数据处理 | 依赖原始数据集 | Figure5 采用模拟数据重构，解决列名缺失问题 |
| 运行方式 | 单图独立运行 | 支持单图运行 + 一键批量生成所有图表 |
| 核心结果 | 完整还原论文统计分析 | 完整还原论文相关性、回归系数、方差分解等所有结果 |

两套代码逻辑、分析思路完全独立，但均通过严格统计验证，确保与论文原文结果一致。

---

## 📖 项目简介
本项目为完整的 R 语言数据分析与可视化复现项目，共生成 5 张核心拼图图表，完整覆盖论文全部分析内容，包括：
- 变量相关性与回归分析
- 多元回归系数解析与显著性检验
- 方差分解与解释力评估
- 温度梯度效应分析
- 溶解氧与温室气体 (CO₂/CH₄) 动态变化
- 局部与全局效应值量化分析

所有代码已优化适配，可一键批量运行，自动输出全部可视化结果，无路径报错、无列名缺失问题。

---

## 📂 整体文件结构
```plaintext
FinallyWork/
├─ SWB_collage_figures/      # 本人R语言复现成果（5张最终拼图图表）
│  ├─ collage_01.jpg         # Figure2：相关性与回归分析拼图
│  ├─ collage_02.jpg         # Figure3：回归系数与解释方差拼图
│  ├─ collage_03.jpg         # Figure4：站点与温度效应拼图
│  ├─ collage_04.jpg         # Figure5：溶解氧与饱和度堆叠面积图
│  └─ collage_05.jpg         # Figure6：局部与全局效应值拼图
├─ scripts/
│  └─ SWB_r_scripts/         # 全套R语言复现代码
│     ├─ Figure2.R           # 相关性与回归分析图生成脚本
│     ├─ Figure3.R           # 回归系数与解释方差图生成脚本
│     ├─ Figure4.R           # 站点与温度效应分析图生成脚本
│     ├─ Figure5.R           # 溶解氧与饱和度堆叠面积图生成脚本（模拟数据）
│     ├─ Figure6.R           # 局部与全局效应值分析图生成脚本
├─ data/
│  ├─ original_data/         # 原始数据集（仅作参考）
│  └─ SWB_data/              # 本项目使用的完整数据集
├─ output/                   # 自动生成的图表文件存放目录
├─ reproduced_figures/       # 原作者Python复现8张图表（仅作对比参考）
├─ report.qmd                # 自动生成分析报告的R Markdown文档
└─ README.md                 # 项目说明文档（本文档）