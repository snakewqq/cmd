/*
Spring Liu
查询客户联系人
状态：active
1. 手机号是否有重复的
2. 重复的有多少个
*/

SELECT c.mobile,COUNT(*) FROM ndb_client_contact a, ndb_contacts b, ndb_contact_mobile c
WHERE a.id = b.objectid AND a.status = 1 AND b.contactid = c.id
AND b.contacttype=1
GROUP BY c.mobile 
HAVING COUNT(*) > 1
