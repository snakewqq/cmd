SELECT 
a.`id`,a.`chinesename`,a.tele60,c.value
FROM ndb_client_contact a
INNER JOIN ndb_contacts b ON a.id = b.`objectid` AND b.contacttype =9 AND b.type =2 AND a.tele60=1 AND a.status=1
INNER JOIN ndb_contact_others c ON b.contactid = c.`id` 
ORDER BY c.value DESC
INTO OUTFILE '/tmp/client_contact_tele60_6.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';