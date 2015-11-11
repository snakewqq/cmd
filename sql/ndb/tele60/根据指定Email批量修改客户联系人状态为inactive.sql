SELECT * FROM tmp_inactive a, ;

SELECT 
COUNT(*),a.`status`
FROM  tmp_inactive d 
LEFT JOIN ndb_contact_others c  ON c.value=d.`email`
LEFT JOIN ndb_contacts b ON b.contactid = c.`id`  AND b.contacttype =9 AND b.type =2
LEFT JOIN ndb_client_contact a ON a.id = b.`objectid`
GROUP BY a.`status`


UPDATE tmp_inactive d,ndb_contact_others c, ndb_contacts b, ndb_client_contact a
SET a.`status`=0
WHERE c.value=d.`email` AND b.contactid = c.`id`  AND b.contacttype =9 AND b.type =2 AND a.id = b.`objectid` AND a.status=1

DROP TABLE tmp_inactive

