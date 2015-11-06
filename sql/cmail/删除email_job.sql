SELECT * FROM ndb_email_job ORDER BY id DESC LIMIT 10;

SELECT * FROM ndb_email_queue ORDER BY id DESC LIMIT 10;

DELETE FROM ndb_email_queue WHERE id IN (1940,1941);

DELETE FROM ndb_email_job WHERE queueid IN (1940,1941);

DELETE FROM ndb_email_record WHERE queueid IN (1940,1941);