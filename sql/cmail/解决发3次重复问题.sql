SELECT * FROM ndb_email_queue ORDER BY id DESC LIMIT 10;

CREATE UNIQUE INDEX ndb_email_queue_subject_to ON ndb_email_queue(fromAddress,`subject`);  

CREATE TABLE tmp_queue_1109
AS 
SELECT * FROM ndb_email_queue

DROP TABLE tmp_queue_1109

CREATE TABLE tmp_id_1109
AS
SELECT id FROM ndb_email_queue a INNER JOIN (
SELECT fromAddress,`subject`,MIN(id) AS minid FROM ndb_email_queue
GROUP BY fromAddress,`subject`
HAVING COUNT(*) > 1) b
ON a.`fromAddress` = b.fromAddress AND a.`subject` = b.subject 
AND a.`id` NOT IN (
SELECT MIN(id) FROM ndb_email_queue
GROUP BY fromAddress,`subject`
HAVING COUNT(*) > 1
)

DELETE FROM ndb_email_queue 
WHERE id IN (SELECT * FROM tmp_id_1109)


SELECT SUM(num) FROM (
SELECT fromAddress,`subject`,COUNT(*) AS num FROM ndb_email_queue
GROUP BY fromAddress,`subject`
HAVING COUNT(*) > 1
) a

SELECT 1379-262