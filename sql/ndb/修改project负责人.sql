SELECT * FROM ndb_user WHERE id IN (111,39);
UPDATE ndb_project_team SET uid = 111 WHERE uid = 39 AND role = 3;