SELECT * FROM ndb_project_consultation_task WHERE id = 339761

SELECT * FROM ndb_project_task_receipts WHERE taskid = 339761

/*修改client hour*/
UPDATE ndb_project_task_receipts 
SET hours=1.00
WHERE taskid = 330210

SELECT * FROM ndb_project_task_receipts WHERE taskid =345598
