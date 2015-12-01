UPDATE ndb_project 
SET `status` = 3,endtime=UNIX_TIMESTAMP()
WHERE id IN 
(
160085,
160083
)
