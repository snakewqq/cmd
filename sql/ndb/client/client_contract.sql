SELECT COUNT(*) FROM ndb_client;

SELECT * FROM ndb_client_relation WHERE clientid=134286;

SELECT a.id,COUNT(*) FROM ndb_client a, ndb_client_relation b
WHERE a.id=b.`clientid`
GROUP BY a.`id`
HAVING COUNT(*) > 1

SELECT COUNT(*) FROM ndb_client a, ndb_client_relation b
WHERE a.id=b.`clientid`

SELECT * FROM ndb_client_relation WHERE clientid NOT IN (SELECT id FROM ndb_client)

SELECT b.status,COUNT(*) FROM ndb_client a, ndb_client_relation b
WHERE a.id=b.`clientid`
GROUP BY b.status
ORDER BY b.status ASC