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

SELECT * FROM ndb_consultant_identity_card WHERE consultant_id = 180975


