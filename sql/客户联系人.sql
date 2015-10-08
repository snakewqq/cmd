UPDATE ndb_contact_others
SET `value` = REPLACE(`value`,'@opentide.com','@thecorebridge.com')


CREATE TABLE tmp_0915(
id INT NOT NULL,
oldvalue VARCHAR(100) NULL,
newvalue VARCHAR(100) NULL
)

INSERT INTO tmp_0915
SELECT co.id,co.value,REPLACE(co.value,'@thecorebridge.com','@samsung.com') AS newvalue
FROM ndb_contact_others co
INNER JOIN ndb_contacts c ON c.contactid = co.id
INNER JOIN ndb_client_contact cc ON cc.id = c.objectid
WHERE c.contacttype =9 /*Email*/
AND c.type =2 /*client contact*/
AND cc.clientid =134495
/*order by c.id desc*/

SELECT * 

UPDATE ndb_contact_others,tmp_0915
SET `value` = tmp_0915.newvalue
WHERE  ndb_contact_others.id = tmp_0915.id

SELECT * FROM tmp_0915

DROP TABLE tmp_0915
