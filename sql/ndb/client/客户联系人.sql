UPDATE ndb_contact_others
SET `value` = REPLACE(`value`,'@booz.com','@strategyand.pwc.com')


CREATE TABLE tmp_0915(
id INT NOT NULL,
oldvalue VARCHAR(100) NULL,
newvalue VARCHAR(100) NULL
)

INSERT INTO tmp_0915
SELECT co.id,co.value,REPLACE(co.value,'@booz.com','@strategyand.pwc.com') AS newvalue
FROM ndb_contact_others co
INNER JOIN ndb_contacts c ON c.contactid = co.id
INNER JOIN ndb_client_contact cc ON cc.id = c.objectid
WHERE c.contacttype =9 /*Email*/ AND co.value LIKE '%@booz.com%'
AND c.type =2 /*client contact*/
AND cc.clientid =134495
/*order by c.id desc*/

SELECT co.id,cc.id AS contact_id,cc.chinesename,co.value
FROM ndb_contact_others co
INNER JOIN ndb_contacts c ON c.contactid = co.id
INNER JOIN ndb_client_contact cc ON cc.id = c.objectid
WHERE c.contacttype =9 /*Email*/ AND co.value LIKE '%pwc.com%'
AND c.type =2 /*client contact*/
INTO OUTFILE '/tmp/global_pwc_com_1.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';



UPDATE ndb_contact_others,tmp_0915
SET `value` = tmp_0915.newvalue
WHERE  ndb_contact_others.id = tmp_0915.id

SELECT * FROM tmp_0915

DROP TABLE tmp_0915
