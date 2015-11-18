/*
Yang Pei反映report-newpayment-summary-2015-10-1~2015-10-31数据有重复现象
taskid in (343286,343121)
*/
SELECT 
`pt`.`id` AS `taskid`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_id` ELSE IFNULL(`pct`.`projectid`,`ptc`.`projectid`) END) AS `project_id`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`process_type` ELSE 0 END) AS `process_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_id` ELSE `pct`.`clientid` END) AS `client_id`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`apply_type` ELSE NULL END) AS `apply_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`amount` ELSE `ptp`.`amount` END) AS `amount`,
`t`.`adj_type` AS `adj_type`,(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`process_type` ELSE 0 END) AS `paid`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`paytime` ELSE 0 END) AS `paytime`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`charge_cash` ELSE 0.00 END) AS `charge_cash`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`charge_currency` ELSE 0 END) AS `charge_currency`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`starttime` ELSE IFNULL(`pct`.`starttime`,`ptc`.`starttime`) END) AS `starttime`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`endtime` ELSE IFNULL(`pct`.`endtime`,`ptc`.`endtime`) END) AS `endtime`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_name` ELSE `c`.`name` END) AS `client_name`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_name` ELSE `p`.`name` END) AS `project_name`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_hours` ELSE `ptr`.`hours` END) AS `client_hours`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`consultant_name` ELSE `con`.`name` END) AS `consultant_name`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`consultant_id` ELSE IFNULL(`pct`.`consultantid`,`ptc`.`consultantid`) END) AS `consultant_id`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`consultant_hours` ELSE `ptp`.`hours` END) AS `consultant_hours`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_type` ELSE `p`.`category` END) AS `project_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`task_type` ELSE `pct`.`type` END) AS `task_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`company` ELSE `con`.`company_name` END) AS `company`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_location` ELSE `nl`.`name` END) AS `bank_location`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_identifier_type` ELSE `ba`.`bank_identifier_type` END) AS `bank_identifier_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_identifier` ELSE `ba`.`bank_identifier` END) AS `bank_identifier`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`address` ELSE `ba`.`address` END) AS `address`,
`t`.`change_reason` AS `change_reason`,(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`payment_type` ELSE `ptp`.`type` END) AS `payment_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`typeofinterview` ELSE `pct`.`typeofinterview` END) AS `typeofinterview`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`tm_englishname` ELSE `e2`.`englishname` END) AS `tm_englishname`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`km_englishname` ELSE `e`.`englishname` END) AS `km_englishname`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_type` ELSE `ba`.`bank_type` END) AS `bank_type`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`accountname` ELSE `ba`.`accountname` END) AS `accountname`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bankname` ELSE `ba`.`bankname` END) AS `bankname`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`accountnumber` ELSE `ba`.`accountnumber` END) AS `accountnumber`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`otherinformation` ELSE `ba`.`otherinformation` END) AS `otherinformation`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`rate` ELSE `con`.`rate` END) AS `rate`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`rate_currency` ELSE `con`.`currency` END) AS `rate_currency`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`consultant_cash` ELSE `ptp`.`cash` END) AS `consultant_cash`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`payment_currency` ELSE `ptp`.`currency` END) AS `payment_currency`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`mobilerecharge` ELSE NULL END) AS `mobilerecharge`,
(CASE WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`change_reason` ELSE `ptp`.`paymentnotes` END) AS `paymentnotes` 
FROM `ndb_project_task` `pt` 
LEFT JOIN `ndb_payment_report` `pr` ON `pr`.`taskid` = `pt`.`id` AND `pr`.`payment_status` IN (1,3)
LEFT JOIN `ndb_payment_report_detail` `t` ON `pr`.`taskid` = `t`.`taskid` AND `t`.`process_type` <> 2
LEFT JOIN `ndb_project_consultation_task` `pct` ON `pct`.`id` = `pt`.`id`
LEFT JOIN `ndb_project_task_common` `ptc` ON `ptc`.`id` = `pt`.`id`
LEFT JOIN `ndb_project_task_payment` `ptp` ON `ptp`.`taskid` = `pt`.`id`
LEFT JOIN `ndb_project_task_receipts` `ptr` ON `ptr`.`taskid` = `pt`.`id`
LEFT JOIN `ndb_project` `p` ON `p`.`id` = IFNULL(`pct`.`projectid`,`ptc`.`projectid`)
LEFT JOIN `ndb_project_team` `pte` ON `pte`.`projectid` = `p`.`id` AND `pte`.`role` = 2
LEFT JOIN `ndb_client` `c` ON `c`.`id` = `pct`.`clientid` 
LEFT JOIN `ndb_consultant` `con` ON `con`.`id` = IFNULL(`pct`.`consultantid`,`ptc`.`consultantid`)
LEFT JOIN `ndb_consultant_bank_account` `ba` ON `ba`.`consultantid` = IFNULL(`pct`.`consultantid`,`ptc`.`consultantid`) AND `ba`.`ismain` = 1
LEFT JOIN `ndb_employees` `e` ON `e`.`id` = `pte`.`uid` 
LEFT JOIN `ndb_employees` `e2` ON `e2`.`id` = IFNULL(`pct`.`taskmanagerid`,`ptc`.`manageuid`)
LEFT JOIN `ndb_location` `nl` ON `nl`.`id` = `ba`.`bank_location` 
WHERE `p`.`category` <> 5 AND `pt`.`status` = 8 AND pt.id IN (343286,343121)

SELECT pt.id,p.id FROM ndb_project_task pt 
LEFT JOIN `ndb_payment_report` `pr` ON `pr`.`taskid` = `pt`.`id` AND `pr`.`payment_status` IN (1,3)
LEFT JOIN `ndb_payment_report_detail` `t` ON `pr`.`taskid` = `t`.`taskid` AND `t`.`process_type` <> 2
LEFT JOIN `ndb_project_consultation_task` `pct` ON `pct`.`id` = `pt`.`id`
LEFT JOIN `ndb_project_task_common` `ptc` ON `ptc`.`id` = `pt`.`id`
LEFT JOIN `ndb_project_task_payment` `ptp` ON `ptp`.`taskid` = `pt`.`id`
LEFT JOIN `ndb_project_task_receipts` `ptr` ON `ptr`.`taskid` = `pt`.`id`
LEFT JOIN `ndb_project` `p` ON `p`.`id` = IFNULL(`pct`.`projectid`,`ptc`.`projectid`)
#LEFT JOIN `ndb_project_team` `pte` ON `pte`.`projectid` = `p`.`id` AND `pte`.`role` = 2
#LEFT JOIN `ndb_client` `c` ON `c`.`id` = `pct`.`clientid` 
#LEFT JOIN `ndb_consultant` `con` ON `con`.`id` = IFNULL(`pct`.`consultantid`,`ptc`.`consultantid`)
#LEFT JOIN `ndb_consultant_bank_account` `ba` ON `ba`.`consultantid` = IFNULL(`pct`.`consultantid`,`ptc`.`consultantid`) AND `ba`.`ismain` = 1
#LEFT JOIN `ndb_employees` `e` ON `e`.`id` = `pte`.`uid` 
#LEFT JOIN `ndb_employees` `e2` ON `e2`.`id` = IFNULL(`pct`.`taskmanagerid`,`ptc`.`manageuid`)
WHERE pt.id IN (343286,343121)

SELECT *,FROM_UNIXTIME(CRE_DT) FROM `ndb_project_team` WHERE projectid IN (138507,158568) AND `role` = 2

DELETE FROM ndb_project_team WHERE id IN (101448,264616)

CREATE UNIQUE INDEX ndb_project_team_unique ON ndb_project_team(projectid,uid,role);  

SELECT projectid,uid,role,COUNT(*) FROM ndb_project_team
WHERE `role` = 2
GROUP BY projectid,uid,role
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC

