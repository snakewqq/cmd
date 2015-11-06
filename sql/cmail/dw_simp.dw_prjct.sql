SELECT * FROM ndb.ndb_project a  JOIN ndb.ndb_project_client b ON a.id = b.projectid ;

SELECT * FROM ndb.ndb_project a, ndb.ndb_project_client_tmp b
WHERE a.id=b.projectid;

DROP TABLE ndb.ndb_project_client_tmp;

CREATE TABLE ndb.ndb_project_client AS
SELECT * FROM ndb.ndb_project_client_tmp;

SELECT * FROM ndb.ndb_project a WHERE a.id IS  NULL;


SELECT * FROM ndb.ndb_project_client b WHERE b.projectid IS  NULL;

SELECT * FROM ndb.ndb_project_client