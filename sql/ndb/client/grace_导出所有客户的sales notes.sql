SELECT 
c.id AS client_id
,c.name AS client_name
,FROM_UNIXTIME(a.CRE_DT) AS create_time
,REPLACE(b.notes,'"','') AS sales_notes
,b.nextstep AS next_step
,d.`englishname` AS am
FROM ndb_client_time_line a, ndb_client_sale_notes b, ndb_client c, ndb_employees d
WHERE a.`type` IN (6,7,8) AND a.`newvalue`=b.id AND a.clientid=c.id AND b.`CRE_UID`=d.`id`
ORDER BY c.id DESC, a.id DESC