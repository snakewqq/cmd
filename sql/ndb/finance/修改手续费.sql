/*
Henry Ma
Kristen已经记录手续费和日期，现在我们发现手续费和币种错误，麻烦你们后台直接修改为34.26USD
*/
SELECT * FROM ndb_payment_report WHERE taskid = 349095 LIMIT 10;

SELECT * FROM ndb_taxonomy WHERE NAME LIKE '%curr%';

SELECT * FROM ndb_taxonomy_term WHERE taxonomyid = 11


UPDATE ndb_payment_report 
SET charge_cash = 34.26
WHERE taskid = 298883


SELECT * FROM ndb_payment_report_detail WHERE taskid = 349095

UPDATE ndb_payment_report_detail 
SET charge_cash = 34.26
WHERE taskid = 298883

SELECT * FROM ndb_project_task_payment WHERE taskid=349095

UPDATE ndb_project_task_payment 
SET hours=0.93
WHERE taskid=349095
