-- 查询1: 各品牌电动汽车平均续航里程和电池容量排名
select make
,round(avg(Range_km),1) avg_Range_km
,round(avg(Battery_Capacity_kWh),1) avg_battery_capacity_kwh
from ev_performance
group by make
order by avg_Range_km desc;



-- 查询2: 不同车型类别(SUV, Sedan等)的能耗对比
select Vehicle_Type
,round(avg(Energy_Consumption_kWh_per_100km),2) avg_consumption
from ev_performance
group by Vehicle_Type
order by Vehicle_Type;
-- 通过查询，发现hatchback能耗最高



-- 查询3: 各地区(Region)的环保贡献(CO2减排总量)分析
SELECT Region
,round(sum(CO2_Saved_tons),0) saved
,count(Vehicle_ID) total_vehicle
from ev_performance
group by Region
order by sum(CO2_Saved_tons) desc;


-- 查询4: 使用成本分析（充电成本 vs 维护成本）
select Make
,Model
,round(avg(Monthly_Charging_Cost_USD),1) a
,round(avg(Maintenance_Cost_USD),2) b
,round(avg(Monthly_Charging_Cost_USD),1)+round(avg(Maintenance_Cost_USD),2) total_cost
from ev_performance
group by Make, Model
order by total_cost asc;
-- 找出使用成本最少的车型

-- 工作表5：电池性能衰减趋势分析
select floor(Charge_Cycles/100)*100 charge_cycle_group    -- 用floor向下取整，再乘100，去除十位和个位
, CONCAT(ROUND(AVG(`Battery_Health_%`), 2), '%') avg_Battery_Health
,count(*) sample_size                       -- 计算每个充电周期分组中有多少行数据
from ev_performance
where Charge_Cycles is not null and `Battery_Health_%` is not null      -- 去除空值
group by floor(Charge_Cycles/100)*100
having sample_size>100                                           -- 排除小样本数据，避免造成干扰
order by charge_cycle_group desc;
-- 电池性能衰减趋势分析的图表分析出现失真，集中在200-300次健康度有显著提升，是因为LFP电池：典型特征是循环寿命极长，衰减曲线非常平缓。但其初始能量密度稍低。
-- 1200次是因为因续航严重衰减或电池故障，车主为其更换了全新的电池，新电池的高健康度拉高了整体的电池健康度
-- 整体仍然呈现下降趋势
