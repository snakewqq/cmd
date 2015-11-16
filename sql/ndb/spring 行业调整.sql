/*
spring 行业调整
*/

/*
SELECT d.id,d.parentid,d.name FROM ndb_taxonomy c
INNER JOIN ndb_taxonomy_term d ON c.id = d.`taxonomyid` AND c.`name`='Industry' AND d.`parentid`=0

一级行业
id	parentid	name
1	0	Agriculture - 农业
9	0	Environment - 环保
14	0	Macro, Strategy - 宏观战略
21	0	Healthcare - 医疗
26	0	Food & Beverage - 食品饮料
31	0	Consumer, Retail - 消费零售
46	0	Energy - 能源
54	0	TMT - 网络技术
73	0	Real Estate, Construction-房地产
78	0	Industrial Goods - 工业制造
81	0	Chemicals - 化学产品
84	0	Metals & Mining - 金属&采矿
90	0	Aerospace - 航空
94	0	Transportation, Logistics - 交通运输
*/

/*
二级行业
SELECT d.id,d.parentid,d.name FROM ndb_taxonomy c
INNER JOIN ndb_taxonomy_term d ON c.id = d.`taxonomyid` AND c.`name`='Industry' AND d.`parentid`>0 order by parentid asc,id asc

id	parentid	name
2	1	种植业 - Crops (Fruits, Vegetables and Grains)
3	1	农、林、牧、渔服务业- Agriculture service
4	1	畜牧业 - Livestock & Breeding
5	1	农药&肥料 - Pesticide&Fertilizer
6	1	渔业 - Fisheries
7	1	食品加工 - Food Processing
8	1	饲料 - Animal Feed
13	9	水处理 - Water Treatment
12	9	固废处理 - Waste Treatment
11	9	节能减排、脱硫脱硝 - Energy Saving&Desulfurization
10	9	土壤修复 - Soil Remediation12
20	14	证券公司 - Securities Firms
19	14	银行&会计 - Banking&Auditing
18	14	政府机关 - Government
17	14	律师 - Legal
16	14	其他金融 - Other Finance
15	14	保险 - Insurance
22	21	医院 - Hospitals
23	21	医疗设备 - Medical Equipment
24	21	药品 - Pharmaceuticals
25	21	保健品 - Healthcare Products
30	26	软饮类 - Soft Drinks
29	26	酒类&烟草 - Alcohol&Tobacco
28	26	休闲食品 - Snack Foods
27	26	奶制品 - Dairy
45	31	日用品 - Daily Necessities
44	31	酒店 - Hospitality
43	31	超市 - Supermarket
42	31	家用电器 - Applications
41	31	餐饮 - Restaurant & catering
40	31	鞋帽制造 - Accessories Manufacturing
39	31	百货 - Department Stores
38	31	日化洗护产品 - Health/Beauty Care Products
32	31	体育娱乐- Sports & Entertainment
33	31	奢侈品 - Luxury Goods
34	31	旅游 - Tourism
35	31	皮革毛皮羽毛(绒)及其制品业 - Feather & Leather & Fur
36	31	纺织品 - Textiles
37	31	连锁经营 - Chain operation 
53	46	风能 - Wind Power
52	46	生物质能 - Biofuel
51	46	水利 - Water resources
50	46	太阳能 - Solar Power
49	46	煤炭 - Coal48
48	46	石油，天然气 - Oil & Gas
47	46	电力 - Electric Power
65	54	报纸、杂志& 出版社 - Publishing
66	54	软件 - Software
67	54	硬件 - Hardware
68	54	网络增值服务 - Value-Added Services
69	54	网络游戏 - Computer Gaming
70	54	电子商务 - E-business
71	54	通信 - Communication
72	54	软件外包服务 - Outsourcing
64	54	高校 - Higher Education
63	54	消费类电子 - Consumer Electronics
55	54	互联网 - Internet
56	54	会展- Fairs
57	54	培训机构 - Training Organizations
58	54	安防-Security System77
59	54	广告&媒体 - Advertising &Media
60	54	照明- Lighting
61	54	猎头-Headhunting/Recruiting
62	54	博彩 - Gambling
77	73	设计院 - Interior Design
76	73	地产 - Real Estate 
75	73	建筑工程和装饰装修- Construction & Interior Construction
74	73	建材 - Building Materials
79	78	机械制造类 - Industrial Machinery
80	78	造纸及印刷- Paper
82	81	化工产品 - Chemical Product
83	81	非金属类 - Porcelain & Ceramics
89	84	黑色金属 - Black Metals
88	84	贵重金属 - Precious Metals
87	84	稀土 - Rare Earth
86	84	采矿业 - Mining
85	84	有色金属 - Metals
93	90	飞机制造 - Aircraft Manufacturing
92	90	飞机部件 - Aircraft Parts
91	90	航空 - Airlines
102	94	轨道交通 - Subway
101	94	道路建设 - Road Infrastructure
100	94	船舶 - Ship
99	94	汽车零部件 - Automotive Parts
98	94	铁路交通 - Railway
97	94	汽车维修 - Automotive Maintenance
96	94	物流 - Logistics
95	94	汽车制造 - Automotive Manufacturing
103	94	货运 - Shipping
*/

/*
SELECT * FROM tmp_industry_one;

SELECT * FROM tmp_industry_company

SELECT * FROM tmp_industry_two;

SELECT *,FLOOR(id/10000) AS parentid FROM tmp_industry_two;

UPDATE tmp_industry_two
SET parentid = FLOOR(id/10000)

ALTER TABLE tmp_industry_two
ADD parentid INT NULL

UPDATE tmp_industry_one
SET id = id+1000

UPDATE tmp_industry_two
SET id = id+10000000


SELECT d.* FROM ndb_taxonomy c
INNER JOIN ndb_taxonomy_term d ON c.id = d.`taxonomyid` AND c.`name`='Industry' AND d.`parentid`=0
*/

/*
step 1
ndb_taxonomy_term 去掉自增长
通过excel上传tmp_industry_one、tmp_industry_two、tmp_industry_company
*/

/*插入新的1级行业*/
INSERT INTO ndb_taxonomy_term
SELECT 
id
,1 AS taxonomyid
,0 AS parentid
,`name`
,'' AS englishname
,'' AS description
,ROUND(RAND() * 100) AS weight
,0 AS `status`
,UNIX_TIMESTAMP(NOW()) AS createtime
,UNIX_TIMESTAMP(NOW()) AS updatetime
,NULL AS CRE_DT
,NULL AS CRE_UID
,UNIX_TIMESTAMP(NOW()) AS UPD_TS
,1 AS UPD_UID
FROM tmp_industry_one;

/*
SELECT MAX(id) FROM ndb_taxonomy_term;

SELECT * FROM tmp_industry_company
*/

/*
SELECT d.* FROM ndb_taxonomy c
INNER JOIN ndb_taxonomy_term d ON c.id = d.`taxonomyid` AND c.`name`='Industry' AND d.`parentid`>0 ORDER BY parentid ASC
*/

/*插入二级行业*/
INSERT INTO ndb_taxonomy_term
SELECT 
id
,1 AS taxonomyid
,parentid
,`name`
,'' AS englishname
,'' AS description
,ROUND(RAND() * 100) AS weight
,0 AS `status`
,UNIX_TIMESTAMP(NOW()) AS createtime
,UNIX_TIMESTAMP(NOW()) AS updatetime
,NULL AS CRE_DT
,NULL AS CRE_UID
,UNIX_TIMESTAMP(NOW()) AS UPD_TS
,1 AS UPD_UID
FROM tmp_industry_two;

/*
更新项目的行业
*/
/*统计代码*/
SELECT 
d.name AS second_industry,d.id,COUNT(*)
FROM ndb_project_consultation a
INNER JOIN ndb_project b ON a.id = b.id
LEFT JOIN ndb_taxonomy_term d ON b.`industryid`=d.`id`
GROUP BY d.name,d.id
ORDER BY d.id DESC;

CREATE TABLE tmp_project_transfer AS
SELECT a.id,b.industryid,f.id AS new_industryid 
FROM ndb_project_consultation a
INNER JOIN ndb_project b ON a.id = b.id
INNER JOIN ndb_taxonomy_term d ON b.`industryid`=d.`id`
INNER JOIN ndb_taxonomy_term e ON d.`parentid`=e.`id`
INNER JOIN tmp_industry_company f ON b.`industryid` = f.`old_id`;

UPDATE tmp_project_transfer a, ndb_project b
SET b.industryid = a.new_industryid
WHERE a.id = b.id;

/*
SELECT * FROM tmp_industry_company

ALTER TABLE tmp_industry_company
ADD old_parentid INT NULL

UPDATE tmp_industry_company
SET parentid=FLOOR(id/10000)


CREATE TABLE tmp_old_one_company
AS
SELECT old_one_name,COUNT(*) FROM tmp_industry_company
GROUP BY old_one_name
ORDER BY COUNT(*) DESC

SELECT * FROM tmp_old_one_company
*/

/*
更新公司的行业
*/
SELECT
e.name AS first_industry,e.id AS first_id,d.name AS second_industry,d.id AS second_id,COUNT(*)
FROM ndb_company_vocabulary a
LEFT JOIN ndb_taxonomy_term d ON a.`subindustry`=d.`id`
LEFT JOIN ndb_taxonomy_term e ON a.`industry`=e.`id`
GROUP BY e.name,e.id,d.name,d.id
ORDER BY COUNT(*) DESC;

UPDATE ndb_company_vocabulary a, ndb_taxonomy_term d, tmp_industry_company f
SET a.subindustry=f.id,a.`industry`=f.parentid
WHERE a.`subindustry`=d.`id` AND a.`subindustry` = f.`old_id`;

UPDATE ndb_company_vocabulary a,tmp_sheet2 e
SET a.industry=e.`new_id`
WHERE a.industry = e.old_id;

UPDATE ndb_company_vocabulary a,tmp_sheet3 e
SET a.industry=e.`new_one`,
a.subindustry=e.new_two
WHERE a.industry = e.old_id;

/*
ALTER TABLE tmp_old_one_company
ADD id INT NULL

SELECT * FROM tmp_old_one_company

SELECT * FROM tmp_industry_company a, tmp_old_one_company b
WHERE a.old_one_name = b.old_one_name

UPDATE tmp_industry_company a, tmp_old_one_company b
SET a.old_parentid=b.id
WHERE a.old_one_name = b.old_one_name

SELECT * FROM tmp_industry_company

DELETE FROM tmp_industry_company WHERE id=11060003

SELECT * FROM tmp_industry_company ORDER BY old_parentid ASC

SELECT a.old_two_name,d.name,(a.old_id-d.id) AS check1,(a.old_parentid-d.parentid) AS check2 FROM tmp_industry_company a,ndb_taxonomy c,ndb_taxonomy_term d 
WHERE a.old_id = d.id AND c.id = d.`taxonomyid` AND c.`name`='Industry' AND d.`parentid`>0
*/

/*
task相关调整
*/
SELECT e.name,e.id AS first_id,d.name,d.id AS second_id,COUNT(*) FROM ndb_project_consultation_task a
LEFT JOIN ndb_taxonomy_term d ON a.`subindustry`=d.`id`
LEFT JOIN ndb_taxonomy_term e ON a.`industry`=e.`id`
GROUP BY e.name,e.id,d.name,d.id
ORDER BY COUNT(*) DESC;

UPDATE ndb_project_consultation_task a ,tmp_sheet4 e 
SET a.`industry`=e.`new_one`,a.`subindustry`=e.`new_two` 
WHERE a.`industry`=e.`old_id`;

/*
SELECT * FROM ndb_project_consultation_task WHERE id = 25641;


SELECT * FROM ndb_taxonomy WHERE NAME='Task Industry'

SELECT * FROM ndb_taxonomy_term WHERE taxonomyid = 8

SELECT * FROM tmp_industry_task
SELECT * FROM tmp_industry_company

ALTER TABLE tmp_industry_task
ADD old_parentid INT NULL

SELECT * FROM tmp_industry_task a
INNER JOIN tmp_industry_company b ON a.id=b.id

SELECT * FROM tmp_industry_company b

UPDATE tmp_industry_task a,tmp_industry_company b 
SET a.old_id=b.old_id,a.old_parentid=b.old_parentid
WHERE a.id=b.id

SELECT * FROM tmp_industry_task 
WHERE old_parentid IS NULL
ORDER BY id ASC

ALTER TABLE tmp_industry_task
ADD parentid INT NULL

UPDATE tmp_industry_task
SET parentid=FLOOR(id/10000)
WHERE parentid IS NULL
*/

/*
SELECT * FROM tmp_industry_task WHERE old_id IS NULL ORDER BY id ASC

SELECT * FROM tmp_industry_task WHERE old_parentid IS NULL ORDER BY id ASC

SELECT * FROM ndb_project WHERE industryid IN ()

SELECT * FROM tmp_industry

SELECT 
a.id,d.name AS second_industry,d.id
FROM ndb_project_consultation a
INNER JOIN ndb_project b ON a.id = b.id
INNER JOIN ndb_taxonomy_term d ON b.`industryid`=d.`id`
INNER JOIN tmp_industry e ON d.id=e.old_id
ORDER BY d.id DESC;

SELECT b.id,b.`industryid`,e.`new_id`
FROM ndb_project_consultation a,ndb_project b,ndb_taxonomy_term d,tmp_industry e
WHERE a.id = b.id AND b.`industryid`=d.`id` AND d.id=e.old_id
ORDER BY b.id DESC

UPDATE ndb_project_consultation a,ndb_project b,ndb_taxonomy_term d,tmp_industry e
SET b.`industryid`=e.`new_id`
WHERE a.id = b.id AND b.`industryid`=d.`id` AND d.id=e.old_id

SELECT old_id,COUNT(*) FROM tmp_sheet4
GROUP BY old_id
ORDER BY COUNT(*) DESC

SELECT * FROM tmp_sheet4

UPDATE tmp_sheet4
SET new_two=new_two+10000000

ALTER TABLE tmp_sheet4
ADD new_one INT NULL

UPDATE tmp_sheet4
SET new_one=FLOOR(new_two/10000)
*/

/*
删除旧数据
*/
DELETE FROM ndb_taxonomy_term WHERE taxonomyid IN (1,8) AND id<1000;

/*
SELECT * FROM ndb_taxonomy
SELECT * FROM ndb_taxonomy_term WHERE taxonomyid IN (1,8)
SELECT * FROM ndb_taxonomy_term WHERE parentid=0
*/

UPDATE ndb_taxonomy_term 
SET weight = MOD(id,100)*5
WHERE taxonomyid=1 AND parentid=0;

UPDATE tmp_sheet6 a, ndb_taxonomy_term b
SET b.weight=a.order2
WHERE a.id=b.id;






/*---------------------------------------------------------------------*/




