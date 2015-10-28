/*
Spring Liu
查询客户联系人
状态：active
1. 手机号是否有重复的
2. 重复的有多少个

Hi，伟义，麻烦帮我取一个数据：

1、Status为Active的client contact
2、Mobile字段数据相同

上次说有60个客户联系人存在这个情况？请将这些人的数据取出来，需要的字段包括：


客户ID、客户name、客户联系人ID，客户联系人name，客户联系人Mobile，客户联系人Status

非常感谢


*/

SELECT \
e.id AS client_id, \
e.name AS client_name, \
b.`contactid` AS contact_id,  \
a.`chinesename` AS contact_name, \
c.mobile AS contact_mobile, \
CASE a.status   \
    WHEN 1 THEN 'active'  \
    WHEN 2 THEN 'transfer'  \
    WHEN 0 THEN 'inactive'  \
END   \
AS contact_status, \
f.name AS 'AmTeam' \
FROM ndb_client_contact a, ndb_contacts b, ndb_contact_mobile c \
INNER JOIN (  \
	SELECT c.mobile FROM ndb_client_contact a, ndb_contacts b, ndb_contact_mobile c  \
	WHERE a.id = b.objectid AND a.status = 1 AND b.contactid = c.id AND b.contacttype=1  \
	GROUP BY c.mobile  \
	HAVING COUNT(*) > 1) d,ndb_client e,ndb_taxonomy_term f  \
WHERE a.id = b.objectid AND a.status = 1 AND b.contactid = c.id AND b.contacttype=1 AND c.mobile = d.mobile \
AND a.clientid = e.id AND e.`amteamid` = f.`id` \
INTO OUTFILE '/tmp/spring_client_mobile_duplicate.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';


