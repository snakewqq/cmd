SELECT a.id,a.clientid,a.location,b.name FROM ndb_client_contact a, ndb_location b
WHERE a.clientid=74654 AND a.`location` = b.id AND b.name IN ('Japan','东京都','Germany','France','South Korea','United Kingdom','Singapore','Boston')

135189

UPDATE ndb_client_contact a, ndb_location b
SET a.`clientid`=135189
WHERE a.clientid=74654 AND a.`location` = b.id AND b.name IN ('Japan','东京都','Germany','France','South Korea','United Kingdom','Singapore','Boston')

SELECT b.name,COUNT(*) FROM ndb_client_contact a, ndb_location b
WHERE a.clientid=74654 AND a.`location` = b.id
GROUP BY b.name
ORDER BY COUNT(*) DESC

'Japan','东京都','Germany','France','South Korea','United Kingdom','Singapore','Boston'
