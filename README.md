 电动汽车云端数据分析项目

 🚗 项目概述
本项目是一个端到端的数据分析案例，旨在挖掘电动汽车市场数据中的商业洞察。通过Python将本地CSV数据ETL至云端MySQL数据库，使用SQL进行深度查询分析，并最终通过Tableau进行可视化呈现。

## 🛠️ 技术栈
- **数据获取与处理**: Python (Pandas, SQLAlchemy)
- **数据存储**: MySQL (部署于AWS RDS / Google Cloud SQL)
- **数据分析**: SQL
- **数据可视化**: Tableau / Power BI

## 📊 数据集
数据集 `electric_vehicle_analytics.csv` 包含超过3000条电动汽车记录，涵盖：
- 车辆基本信息（品牌、型号、年份、地区）
- 性能指标（续航、能耗、电池健康度、加速）
- 成本数据（维护成本、保险成本、充电成本）
- 环保效益（CO2减排量）

- ## 📊 数据字典（字段说明）
数据集 `electric_vehicle_analytics.csv` 包含超过10条初始字段，涵盖：
- 字段名	                           说明
Vehicle_ID	                      车辆唯一标识
Make	                            品牌（如 Tesla, Nissan）
Model	                            车型（如 Model 3, Leaf）
Year	                           生产年份
Region	                         销售/使用地区
Vehicle_Type	                   车型分类（SUV, Sedan, Hatchback, Truck）
Battery_Capacity_kWh	           电池容量（千瓦时）
Battery_Health_%	               电池健康度（百分比）
Range_km	                       续航里程（公里）
Charging_Power_kW	               充电功率（千瓦）
Charging_Time_hr	               充电时间（小时）
Charge_Cycles	                   充电循环次数
Energy_Consumption_kWh_per_100km	百公里能耗（千瓦时）
Mileage_km	                     总行驶里程（公里）
Avg_Speed_kmh	                   平均速度（公里/小时）
Max_Speed_kmh	                   最高速度（公里/小时）
Acceleration_0_100_kmh_sec	0-100公里加速时间（秒）
Temperature_C	                   平均使用环境温度（摄氏度）
Usage_Type	                     使用类型（Personal, Fleet, Commercial）
CO2_Saved_tons	                 累计减少的CO2排放（吨）
Maintenance_Cost_USD	           维护成本（美元）
Insurance_Cost_USD	             保险成本（美元）
Electricity_Cost_USD_per_kWh	   电费单价（美元/千瓦时）
Monthly_Charging_Cost_USD	       月充电费用（美元）
Resale_Value_USD	               二手车残值（美元）

## 🔍 核心分析内容
1.  **品牌性能排名**：对比各品牌在续航、电池容量方面的表现。
2.  **能效分析**：分析不同车型类别（SUV、轿车等）的能耗差异。
3.  **电池衰减研究**：探索不同年份，不同品牌的充电次数与电池健康度的关系。
4.  **区域市场分析**：评估不同地区电动汽车的总减排贡献。
5.  **使用成本洞察**：计算不同车型的月均使用成本，识别最经济的车型。

## 📈 如何重现

1.  **环境准备**：
    ```bash
    pip install pandas sqlalchemy pymysql
    ```
2.  **数据入库**：
    - 配置云端MySQL数据库及安全组。
    - 修改 `data_ingestion/data_to_cloud_ev.py` 中的连接字符串。
    - 运行脚本：`python data_to_cloud_ev.py`
3.  **SQL分析**：
    - 使用数据库客户端执行 `sql_analysis/ev_analysis_queries.sql`。
4.  **可视化 (Tableau)**：
    - 连接数据库，重建视图或导入 `Electric_Vehicle_Analysis.twbx` 工作簿。

## 📈 结果展示

<img width="987" height="807" alt="image" src="https://github.com/user-attachments/assets/2b3e4921-bd24-4e2c-b567-b2e9ff521288" />

*图：电动汽车性能与市场分析交互式仪表板*


## 💡 核心发现
- 品牌 BMW,Hyundai，Ford 在平均续航里程上领先。
- [hatchback 掀背车] 车型类别相比SUV能效高出约1%，从家用实际角度出发，suv最划算。
- 电池健康度与充电次数整体呈现负相关，但局部数据出现反常，在两百次充电次数时，电池健康度的平均值出现不合理的波谷，在充电次数达到1200次左右时，电池健康度出现异常回升。怀疑的具体原因有如下两点：

1.汽车制造年份不同，譬如制造年限早的汽车电池衰减严重，在1200次之前车辆已经报废，导致1200次左右的车辆样本数量不够，并且能坚持到1200次的车辆技术先进，影响了平均值
2.汽车品牌不同，对应电池的制造技术不同，某种品牌的高健康度影响了平均值
3.电池健康度的量化指标不应该用平均值，容易受到异常值的影响。

验证方法：通过筛选器自由选择了年份以及汽车制造商，数据波动幅度变小，但仍然反常
放弃平均值，改用四分位中位数，仍未有良好效果

结论：通过大量的资料查询，我们发现现今大量电动汽车的电池主要分为LFP（磷酸铁锂） 和NCA/NMC（三元锂）。
LFP电池：典型特征是循环寿命极长，衰减曲线非常平缓。但其初始能量密度稍低。
NCA/NMC电池：典型特征是能量密度高，但初期衰减相对较快，之后会进入一个平台期。
这两种电池共性时前期电池健康度出现异常波谷
而达到1200次充电循环周期后，大部分车主会选择更换全新的电池包，这导致电池健康度在1200次充电次数的时候出现异常上升
- 澳大利亚地区在总CO2减排量上贡献最大，电动汽车普及量也最大。


## 💡 总结与反思

-   **技术收获**：通过本项目，完整实践了现代数据分析的云原生工作流，提升了解决复杂数据问题的能力。
-   **业务洞察**：电池化学体系（LFP vs. NMC）对衰减趋势的影响远大于预期，这是未来分析中需要优先区分的维度。
-   **挑战与解决**：在分析初期，电池健康度曲线出现异常波动。通过**控制变量法（筛选器）**、**更改统计量（平均值→中位数）** 并结合**行业知识调研**，最终合理解释了数据现象，得到了更可靠的结论。

**开发者**：丁凯  
**邮箱**：2821322734@qq.com  
