/*
以官网数据为准
*/
SELECT t.*,a.id,e.`name` FROM tele60$ t 
LEFT JOIN ndb_contact_others c ON t.`contact_email` = c.value 
LEFT JOIN ndb_contacts b ON b.contactid = c.`id` AND b.contacttype =9 AND b.type =2 
LEFT JOIN ndb_client_contact a ON a.id = b.`objectid` 
LEFT JOIN ndb_client d ON a.`clientid` = d.`id`  
LEFT JOIN ndb_taxonomy_term e ON d.`amteamid` = e.`id` 
LEFT JOIN ndb_taxonomy f ON e.taxonomyid = f.`id` AND f.`name` = 'CLIENT AM LIST' 

/*
以db数据为准
*/
SELECT p.name,a.chinesename,a.id,c.value,e.`name` FROM ndb_project_task_common_contact ptcc,  ndb_client_contact a, ndb_project p, 
ndb_client d,ndb_taxonomy_term e,ndb_taxonomy f,ndb_contacts b,ndb_contact_others c
WHERE ptcc.projectid = p.id AND a.id = ptcc.contactid
AND ptcc.projectid IN (158419,158269,158268,158266,158265,158264)
AND a.`clientid` = d.`id`
AND d.`amteamid` = e.`id`  AND e.taxonomyid = f.`id` AND f.`name` = 'CLIENT AM LIST' 
AND a.id = b.`objectid` AND b.contacttype =9 AND b.type =2 AND b.contactid = c.`id`



SELECT t.*,a.id,e.`name` FROM tele60$ t \
LEFT JOIN ndb_contact_others c ON t.`contact_email` = c.value \
LEFT JOIN ndb_contacts b ON b.contactid = c.`id` AND b.contacttype =9 AND b.type =2 \
LEFT JOIN ndb_client_contact a ON a.id = b.`objectid` \
LEFT JOIN ndb_client d ON a.`clientid` = d.`id`  \
LEFT JOIN ndb_taxonomy_term e ON d.`amteamid` = e.`id` \
LEFT JOIN ndb_taxonomy f ON e.taxonomyid = f.`id` AND f.`name` = 'CLIENT AM LIST' \
INTO OUTFILE '/tmp/tele60_signup_1.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';


SELECT p.name,a.chinesename,a.id,c.value,e.`name` FROM ndb_project_task_common_contact ptcc,  ndb_client_contact a, ndb_project p, \
ndb_client d,ndb_taxonomy_term e,ndb_taxonomy f,ndb_contacts b,ndb_contact_others c \
WHERE ptcc.projectid = p.id AND a.id = ptcc.contactid \
AND ptcc.projectid IN (158419,158269,158268,158266,158265,158264) \
AND a.`clientid` = d.`id` \
AND d.`amteamid` = e.`id`  AND e.taxonomyid = f.`id` AND f.`name` = 'CLIENT AM LIST'  \
AND a.id = b.`objectid` AND b.contacttype =9 AND b.type =2 AND b.contactid = c.`id` \
INTO OUTFILE '/tmp/tele60_signup_2.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';