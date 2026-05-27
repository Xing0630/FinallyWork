
# Multiple stressors alter greenhouse gas concentrations in streams

这是一个复现论文《Multiple stressors alter greenhouse gas concentrations in streams》（Gutiérrez-Cánovas 等，2024）中所有图表的Python代码库。

## 引用

Gutiérrez-Cánovas, C., et al. (2024). Multiple stressors alter greenhouse gas concentrations in streams. Global Change Biology.

## 项目结构

```
github-package/
├── data/
│   └── dat.txt                    # 原始数据集
├── original_figures/              # 原始论文图表（请自行添加）
│   └── README.md
├── reproduced_figures/            # 复现的图表（运行脚本后生成）
├── scripts/
│   ├── data_utils.py              # 数据加载和预处理工具
│   ├── plot_01_rel_k600_ER.py     # 图1：K600与ER的关系
│   ├── plot_02_hist_ghg.py        # 图2：代谢和GHG分布直方图
│   ├── plot_03_rel_ghg.py         # 图3：代谢、DO与GHG通量关系
│   ├── plot_04_metabolism_coefficients.py  # 图4：代谢多模型推断系数
│   ├── plot_05_ghg_coefficients.py       # 图5：GHG多模型推断系数
│   ├── plot_06_variance_partitioning.py   # 图6：方差分解图
│   ├── plot_07_sem_effects.py              # 图7：SEM效应图
│   ├── plot_08_scenarios.py                # 图8：场景分析图
│   └── run_all_figures.py      # 批量运行所有图表生成脚本
├── requirements.txt               # Python依赖包
└── README.md                   # 本文件
```

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 运行脚本

#### 批量生成所有图表：
```bash
cd scripts
python run_all_figures.py
```

#### 或单独生成某个图表：
```bash
cd scripts
python plot_01_rel_k600_ER.py
```

### 3. 查看结果

复现的图表会保存在 `reproduced_figures/` 目录中，格式为JPG。

## 图表说明

### 探索性分析图表
1. **Figure 1**：K600（气体交换速率）与ER（生态系统呼吸）的关系图
2. **Figure 2**：代谢率和温室气体浓度的分布直方图
3. **Figure 3**：代谢率、DO赤字与GHG通量的关系散点图

### 多模型推断图表
4. **Figure 4**：代谢指标（GPP、ER、NEP、Algal production）的模型系数图
5. **Figure 5**：温室气体指标（pCO2、pCH4）的模型系数图
6. **Figure 6**：各变量的方差分解图

### 结构方程模型与场景分析
7. **Figure 7**：SEM标准化总效应图
8. **Figure 8**：不同DO赤字水平下的场景分析图

## 复现对比图

<div align="center">

| 原图1 | 复现图1 |
|:---:|:---:|
| <img width="400" src="https://github.com/user-attachments/assets/ecc6aad9-267c-427e-9189-608013b9210e" alt="原图1"> | <img width="400" src="https://github.com/user-attachments/assets/772c8cab-365a-4e89-8834-c1ad95e739e6" alt="复现图1"> |
| **原图1** | **复现图1** |

</div>

<br>

<div align="center">

| 原图2 | 复现图2-1（代谢系数） | 复现图2-2（方差分解） |
|:---:|:---:|:---:|
| <img width="300" src="https://github.com/user-attachments/assets/8a62b841-d743-4d2a-986b-9f88480599f1" alt="原图2"> | <img width="300" src="https://github.com/user-attachments/assets/73207f70-37f4-4fdd-8809-085579d81dbe" alt="复现图2-1"> | <img width="300" src="https://github.com/user-attachments/assets/81f61071-2577-47d4-b6cb-e075ad19a5b4" alt="复现图2-2"> |
| **原图2** | **复现图2-1** | **复现图2-2** |

</div>

<br>

<div align="center">

| 原图3 | 复现图3-1（温室气体系数） | 复现图3-2（方差分解） |
|:---:|:---:|:---:|
| <img width="300" src="https://github.com/user-attachments/assets/c0efde88-a642-4615-9381-f89ed2c6effc" alt="原图3"> | <img width="300" src="https://github.com/user-attachments/assets/0035d051-ffa5-423a-b09c-e5192238b829" alt="复现图3-1"> | <img width="300" src="https://github.com/user-attachments/assets/606d5d07-69d8-4cf3-9ae0-c1a4e0de6f34" alt="复现图3-2"> |
| **原图3** | **复现图3-1** | **复现图3-2** |

</div>

<br>

<div align="center">

| 原图4 | 复现图4 |
|:---:|:---:|
| <img width="400" src="https://github.com/user-attachments/assets/ba6f59e9-5b5c-448e-83e9-89369ca043f4" alt="原图4"> | <img width="400" src="https://github.com/user-attachments/assets/44d2acaa-8ca4-4766-be40-334f61d509a9" alt="复现图4"> |
| **原图4** | **复现图4** |

</div>

<br>

<div align="center">

| 原图5 | 复现图5 |
|:---:|:---:|
| <img width="400" src="https://github.com/user-attachments/assets/5620aad4-0f40-45be-a1e4-cbabef1e38ed" alt="原图5"> | <img width="400" src="https://github.com/user-attachments/assets/3a82858d-92a0-42fe-b785-6b5abac51ebe" alt="复现图5"> |
| **原图5** | **复现图5** |

</div>

## 数据说明

原始数据集包含50个站点的观测数据，主要变量包括：

- **代谢指标**：GPP（总初级生产力）、ER（生态系统呼吸）、NEP（净生态系统生产力）、Algal production（藻产量）
- **温室气体**：pCO2、pCH4、FCO2、FCH4
- **环境因子**：温度、流速、流量、DIN、DO饱和度、NDVI（河岸植被）等

**注意**：部分图（系数图、方差分解图、SEM效应图、场景分析图）是基于原始R代码的模拟结果，未进行完整的模型拟合。

## 与原始代码的关系

本项目是对原始R代码的Python复现：
- 原始代码仓库：包含完整的R分析脚本
- 本项目：使用Python和matplotlib复现所有主要图表
- 数据预处理：在 `data_utils.py` 中实现了DO赤字计算等预处理步骤

## 系统要求

- Python 3.7+
- 主要依赖：pandas, numpy, matplotlib, scipy

## 技术支持

如有问题，请参阅技术文档或检查 `requirements.txt` 确保依赖正确安装。

