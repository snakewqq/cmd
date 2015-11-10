/*
joyce_导出Tele60手动发送Email名单
*/

SELECT 
c.value AS contact_email,
h.englishname AS am1,
e.name AS am_team
FROM ndb_contact_others c 
INNER JOIN ndb_contacts b ON b.contactid = c.`id` AND b.contacttype =9 AND b.type =2
INNER JOIN ndb_client_contact a ON a.id = b.`objectid` AND a.tele60=1
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
INTO OUTFILE '/tmp/tele60_contact_email_1.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'