SELECT * FROM ndb_project_task_notes WHERE taskid = 335924

INSERT INTO ndb_project_task_notes (uid, taskid,NAME)
SELECT 111 AS uid,a.id AS taskid,'KM Notes' AS `name` FROM ndb_project_task_common_contact a,ndb_project_task c WHERE a.id NOT IN (
SELECT b.taskid FROM ndb_project_task c,ndb_project_task_common_contact a,ndb_project_task_notes b
WHERE c.id = a.id AND a.projectid = 157708 AND a.id = b.taskid  AND b.name = 'KM Notes' AND c.`status` = 1) AND a.projectid = 157708 
AND c.id = a.id AND c.status = 1;

SELECT * FROM ndb_user WHERE email = 'bhuang@capvision.com';

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,335924,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,335931,"KM Notes")

SELECT * FROM ndb_project_task_notes WHERE taskid = 335931

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336011,"KM Notes")

SELECT * FROM ndb_project_task_notes WHERE taskid = 336011

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336013,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336016,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336017,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336019,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336021,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336022,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336028,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336029,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336030,"KM Notes")

INSERT INTO ndb_project_task_notes
(uid, taskid,NAME) VALUES(111,336033,"KM Notes")

