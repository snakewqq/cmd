PE/C
如果客户归属于PE/C，且客户状态为：Confirm、Trial、Project、Annual的所有联系人，且联系人状态为Active

SELECT * FROM ndb_employees WHERE id =701 LIMIT 10;

SELECT * FROM ndb_client_relation WHERE 

SELECT * FROM ndb_employees_team_group LIMIT 10;

SELECT * FROM ndb_taxonomy WHERE `name` = 'CLIENT AM LIST'

SELECT * FROM ndb_taxonomy_term WHERE taxonomyid = 14


A、ID
B、Name
C、Type
D、Client AM Team
E、Charge TYPE
F、Status
G、AM1

Contact模块中的
A、Name
B、Position
C、Role
D、Is Main Contacts

client_type
1 => Consulting Firm （咨询公司）
2 => Private Equity （私募股权投资）
3 => Hedge Fund （对冲基金）
4 => Venture Capital （风险投资）
5 => Mutual Fund （互惠基金）
6 => Corporate （企业）
7 => Financial Firm（金融公司）
8 => Others （其他）

"客户的状态
1 => Prospect（待争取）
2 => Engage（初期接触中）
3 => Discover（探索中）
4 => Trial（试用期）
5 => Confirm（确认）
7 => Annual（已按年签约）
8 => Project（按项目合作）"

SELECT clientid,amid,percentage FROM ndb_client_am_percentage 
GROUP BY percentage  

SELECT percentage,GROUP_CONCAT(DISTINCT(clientid)) FROM ndb_client_am_percentage 
GROUP BY clientid percentage GROUP_CONCAT( DISTINCT clientid )

SELECT a.clientid,a.amid FROM ndb_client_am_percentage a,(
SELECT DISTINCT(clientid),MAX(percentage) AS percentage FROM ndb_client_am_percentage 
GROUP BY clientid) b
WHERE a.clientid = b.clientid AND a.percentage = b.percentage



SELECT 
a.`id` AS client_id,
a.`name` AS client_name,
CASE a.`type`
    WHEN 1 THEN 'Consulting Firm'
    WHEN 2 THEN 'Private Equity'
    WHEN 3 THEN 'Hedge Fund'
    WHEN 4 THEN 'Venture Capital'
    WHEN 5 THEN 'Mutual Fund'
    WHEN 6 THEN 'Corporate'
    WHEN 7 THEN 'Financial Firm'
    WHEN 8 THEN 'Others'
END AS client_type,
d.name AS 'AmTeam',
CASE e.status
    WHEN 1 THEN 'Prospect'
    WHEN 2 THEN 'Engage'
    WHEN 3 THEN 'Discover'
    WHEN 4 THEN 'Trial'
    WHEN 5 THEN 'Confirm'
    WHEN 7 THEN 'Annual'
    WHEN 8 THEN 'Project'
END AS client_status,
g.englishname AS 'AM1',
CASE a.`chargetype`
    WHEN 1 THEN 'grade'
    WHEN 2 THEN 'unlimited'
    WHEN 3 THEN 'normal'
END AS client_charge_type,
b.`chinesename`,
b.`firstname`,
b.`lastname`,
b.`position`,
CASE b.`role`
    WHEN 1 THEN 'normal user'
    WHEN 2 THEN 'legal user'
END AS contact_role,
CASE b.`ismain`
    WHEN 0 THEN 'no'
    WHEN 1 THEN 'yes'
END AS 'Is Main Contacts' 
FROM ndb_client a,ndb_client_contact b,ndb_taxonomy c,ndb_taxonomy_term d,ndb_client_relation e,(
SELECT a.clientid,a.amid FROM ndb_client_am_percentage a,(
SELECT DISTINCT(clientid),MAX(percentage) AS percentage FROM ndb_client_am_percentage 
GROUP BY clientid) b
WHERE a.clientid = b.clientid AND a.percentage = b.percentage) f, ndb_employees g
WHERE a.id = b.`clientid` AND a.`amteamid` = d.`id` AND b.status = 1
AND d.`taxonomyid` = c.`id` AND c.`name` = 'CLIENT AM LIST' AND d.name = 'PE/C'
AND a.id = e.clientid AND e.status IN (5,4,8,7)
AND a.id = f.clientid AND f.amid = g.id;


SELECT \
a.`id` AS client_id, \
a.`name` AS client_name, \
CASE a.`type` \
    WHEN 1 THEN 'Consulting Firm' \
    WHEN 2 THEN 'Private Equity' \
    WHEN 3 THEN 'Hedge Fund' \
    WHEN 4 THEN 'Venture Capital' \
    WHEN 5 THEN 'Mutual Fund' \
    WHEN 6 THEN 'Corporate' \
    WHEN 7 THEN 'Financial Firm' \
    WHEN 8 THEN 'Others' \
END AS client_type, \
d.name AS 'AmTeam', \
CASE e.status \
    WHEN 1 THEN 'Prospect' \
    WHEN 2 THEN 'Engage' \
    WHEN 3 THEN 'Discover' \
    WHEN 4 THEN 'Trial' \
    WHEN 5 THEN 'Confirm' \
    WHEN 7 THEN 'Annual' \
    WHEN 8 THEN 'Project' \
END AS client_status, \
g.englishname AS 'AM1', \
CASE a.`chargetype` \
    WHEN 1 THEN 'grade' \
    WHEN 2 THEN 'unlimited' \
    WHEN 3 THEN 'normal' \
END AS client_charge_type, \
b.`chinesename`, \
b.`firstname`, \
b.`lastname`, \
b.`position`, \
CASE b.`role` \
    WHEN 1 THEN 'normal user' \
    WHEN 2 THEN 'legal user' \
END AS contact_role, \
CASE b.`ismain` \
    WHEN 0 THEN 'no' \
    WHEN 1 THEN 'yes' \
END AS 'Is Main Contacts'  \
FROM ndb_client a,ndb_client_contact b,ndb_taxonomy c,ndb_taxonomy_term d,ndb_client_relation e,( \
SELECT a.clientid,a.amid FROM ndb_client_am_percentage a,( \
SELECT DISTINCT(clientid),MAX(percentage) AS percentage FROM ndb_client_am_percentage  \
GROUP BY clientid) b \
WHERE a.clientid = b.clientid AND a.percentage = b.percentage) f, ndb_employees g \
WHERE a.id = b.`clientid` AND a.`amteamid` = d.`id` AND b.status = 1 \
AND d.`taxonomyid` = c.`id` AND c.`name` = 'CLIENT AM LIST' AND d.name = 'PE/C' \
AND a.id = e.clientid AND e.status IN (4,5,8,7) \
AND a.id = f.clientid AND f.amid = g.id \
INTO OUTFILE '/tmp/client_pec.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';


