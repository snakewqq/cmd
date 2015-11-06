UPDATE ndb_project 
SET `status` = 3,endtime=UNIX_TIMESTAMP()
WHERE id IN 
(
151281,
148976
)
