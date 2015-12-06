SELECT *,FROM_UNIXTIME(createtime) FROM ndb_project_task WHERE id = 352239

SELECT *,FROM_UNIXTIME(starttime) FROM ndb_project_consultation_task WHERE id = 352239

UPDATE ndb_project_consultation_task 
SET starttime=UNIX_TIMESTAMP('2015-11-24 22:00')
WHERE id = 352239

UPDATE ndb_project_task
SET `status` = 7
WHERE id = 337369