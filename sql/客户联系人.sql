UPDATE ndb_contact_others
SET `value` = REPLACE(`value`,'@opentide.com','@thecorebridge.com')

CREATE TABLE tmp_0915(
id INT NOT NULL,
oldvalue VARCHAR(100) NULL,
newvalue VARCHAR(100) NULL
)

INSERT INTO tmp_0915
SELECT co.id,co.value,REPLACE(co.value,'@opentide.com','@thecorebridge.com') AS newvalue
FROM ndb_contact_others co
INNER JOIN ndb_contacts c ON c.contactid = co.id
INNER JOIN ndb_client_contact cc ON cc.id = c.objectid
WHERE c.contacttype =9 /*Email*/
AND c.type =2 /*client contact*/
AND cc.clientid =134495
/*order by c.id desc*/

SELECT * 

UPDATE ndb_contact_others
SET `value` = a.newvalue
FROM tmp_0915 a
INNER JOIN ndb_contact_others b ON a.id = b.id

DELETE TABLE tmp_0915
