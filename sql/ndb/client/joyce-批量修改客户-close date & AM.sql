/*
joyce 
Team

Please help adjust close date to 2020/12/31.  Thank you. 

Also update AM to Default PEC AM

cc. Team，if you want take flwg. account， Please let me know.

*/

SELECT * FROM sheet1$

ALTER TABLE sheet1$
ADD COLUMN max_contract_id INT NULL

SELECT a.*,b.id FROM sheet1$ a, ndb_client b
WHERE a.Name = b.name

UPDATE sheet1$ a, ndb_client b
SET a.client_id = b.id
WHERE a.Name = b.name



SELECT a.*,b.*,FROM_UNIXTIME(c.closedate) FROM sheet1$ a
LEFT JOIN (
	SELECT clientid,MAX(id) AS maxid FROM ndb_client_contract
	GROUP BY clientid
) b ON a.client_id = b.clientid
LEFT JOIN ndb_client_contract c ON b.maxid = c.id

UPDATE sheet1$ a
LEFT JOIN (
	SELECT clientid,MAX(id) AS maxid FROM ndb_client_contract
	GROUP BY clientid
) b ON a.client_id = b.clientid
SET a.max_contract_id = b.maxid

SELECT * FROM sheet1$ a, ndb_client_contract b
WHERE a.max_contract_id=b.id

/*
修改日期
*/
UPDATE sheet1$ a, ndb_client_contract b
SET b.closedate=UNIX_TIMESTAMP('2020-12-31 00:00:00')
WHERE a.max_contract_id=b.id

/*
修改负责am
*/
UPDATE sheet1$ a,ndb_client b,ndb_client_am_percentage c
SET c.amid=1337
WHERE a.client_id = b.id AND a.client_id = c.clientid


SELECT * FROM sheet1$ a
INNER JOIN ndb_client b ON a.client_id = b.id
INNER JOIN ndb_client_am_percentage c ON a.client_id = c.clientid

UPDATE sheet1$ a
INNER JOIN ndb_client b ON a.client_id = b.id
INNER JOIN ndb_client_am_percentage c ON a.client_id = c.clientid
SET c.am1=1337

SELECT * FROM sheet1$ a,ndb_client b,ndb_client_am_percentage c
WHERE a.client_id = b.id AND a.client_id = c.clientid

SELECT * FROM ndb_employees WHERE englishname = 'Default PEC AM'

SELECT * FROM ndb_client_am_percentage








