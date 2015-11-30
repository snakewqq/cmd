/*
spring_获取所有Email字段重复的客户联系人信息

1、Email字段，仅指客户联系人的Email
2、获得这些人以后，输出为excel表格。
3、表格需包含字段：

A、客户联系人所属客户的client ID
B、客户所属Client AM Team ，可能的值包括：Domestic、GES、Global、PE/C、PSF
C、客户的AM，若有多个，取AM1
D、客户联系人的client contact ID
E、客户联系人name
F、客户联系人状态，可能的值包括：Active、Inactive
G、客户联系人的邮箱字段内容。如果有多个邮箱字段内容，展示为多行。

124
258
*/

SELECT 
#count(*)
a.clientid AS client_id
,e.name AS am_team
,h.englishname AS am1
,a.id AS contact_id
,a.chinesename AS contact_name
,CASE a.status   
    WHEN 1 THEN 'active'  
    WHEN 2 THEN 'transfer'  
    WHEN 0 THEN 'inactive'  
END AS contact_status
,c.value AS contact_email
FROM (
SELECT 
c.value
FROM ndb_client_contact a
INNER JOIN ndb_contacts b ON a.id = b.`objectid` AND b.contacttype =9 AND b.type =2
INNER JOIN ndb_contact_others c ON b.contactid = c.`id` 
GROUP BY c.value
HAVING COUNT(*)>1 
AND c.`value` IS NOT NULL) i
INNER JOIN ndb_contact_others c ON i.value=c.value
INNER JOIN ndb_contacts b ON b.contactid = c.`id` AND b.contacttype =9 AND b.type =2
INNER JOIN ndb_client_contact a ON a.id = b.`objectid`
INNER JOIN ndb_client d ON a.clientid=d.id
INNER JOIN ndb_taxonomy_term e ON d.`amteamid` = e.`id`
INNER JOIN ndb_taxonomy f ON e.taxonomyid = f.id AND f.`name` = 'CLIENT AM LIST'
LEFT JOIN (	
	SELECT a.`clientid`,MAX(a.amid) AS am1 FROM (
		SELECT a.clientid,a.amid FROM ndb_client_am_percentage a,(
			SELECT DISTINCT(clientid),MAX(percentage) AS percentage FROM ndb_client_am_percentage 
			GROUP BY clientid ) b
		WHERE a.clientid = b.clientid AND a.percentage = b.percentage
	) a
	GROUP BY a.clientid
) g ON a.clientid = g.clientid
LEFT JOIN ndb_employees h ON g.am1 = h.id 
INTO OUTFILE '/tmp/sprint_client_contact_email_duplicate_1.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';