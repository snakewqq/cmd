/*
spring

身份证非15、18位的

*/

SELECT LENGTH(`value`),COUNT(*) FROM ndb_consultant_identity_card
WHERE `type`=1 AND valid = 1
GROUP BY LENGTH(`value`)
ORDER BY COUNT(*) DESC

SELECT consultant_id,`value`,FROM_UNIXTIME(TIME) FROM ndb_consultant_identity_card
WHERE `type`=1 AND LENGTH(`value`) = 15 AND valid=1
INTO OUTFILE '/tmp/spring_consultant_idcard_15_2.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

SELECT a.consultant_id,a.`value`,FROM_UNIXTIME(a.TIME),b.`note` FROM ndb_consultant_identity_card a, ndb_notes b
WHERE b.type=1 AND b.`objectid` = a.`consultant_id` AND a.type=1 AND LENGTH(a.`value`) = 15 AND a.valid=1
ORDER BY a.consultant_id ASC
INTO OUTFILE '/tmp/spring_consultant_idcard_15_5.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

SELECT * FROM ndb_notes LIMIT 10;


