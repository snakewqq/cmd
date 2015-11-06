SELECT * FROM tmp_project_status_1009 WHERE project_status IN (3,4);

SELECT a.id,a.status,b.`project_status` FROM ndb_project a,tmp_project_status_1009 b
WHERE a.id = b.`project_id` AND b.`project_status` IN (3,4);

UPDATE ndb_project a,tmp_project_status_1009 b
SET a.status = b.`project_status`
WHERE a.id = b.`project_id` AND b.`project_status` IN (3,4);

DROP TABLE tmp_project_status_1009;