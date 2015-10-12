SELECT DISTINCT(a.id) FROM ndb_consultant a,ndb_consultant_compliance b,ndb_consultant_compliance_document c
WHERE a.`id` = b.`consultantid` AND b.status = 1 AND b.`type` = 'tnc' AND b.`signedtype` = 2
AND c.type = b.type AND c.typeid = b.typeid
AND c.`consultantid` = a.`id` 
AND FROM_UNIXTIME(b.`updatedate`) BETWEEN '2013-1-1' AND '2014-1-1'
LIMIT 100;