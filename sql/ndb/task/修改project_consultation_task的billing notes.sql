SELECT * FROM ndb_project_consultation_task WHERE id = 349095

SELECT * FROM ndb_project_task_receipts WHERE taskid = 349095

/*修改client hour*/
UPDATE ndb_project_task_receipts 
SET hours=1.00
WHERE taskid = 330210

SELECT * FROM ndb_project_task_receipts WHERE taskid =349095
