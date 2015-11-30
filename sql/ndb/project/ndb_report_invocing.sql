DELIMITER $$

USE `ndb`$$

DROP VIEW IF EXISTS `ndb_view_report_invoicing`$$

CREATE ALGORITHM=UNDEFINED DEFINER=`ndb`@`%` SQL SECURITY DEFINER VIEW `ndb_view_report_invoicing` AS 
SELECT 
`npt`.`id` AS `task_id`
,`nc`.`id` AS `client_id`
,`nc`.`name` AS `client_name`
,IFNULL(`npct`.`starttime`,IFNULL(`npctcc`.`starttime`,`npctc`.`starttime`)) AS `starttime`
,IFNULL(`npct`.`endtime`,IFNULL(`npctcc`.`endtime`,`npctc`.`endtime`)) AS `endtime`
,`ncc`.`id` AS `contact_id`
,`ncc`.`chinesename` AS `contact_chinesename`
,`ncc`.`firstname` AS `contact_firstname`
,`ncc`.`lastname` AS `contact_lastname`
,`np`.`id` AS `project_id`
,`np`.`codename` AS `project_name`
,`npct`.`typeofinterview` AS `typeofinterview`
,`npct`.`firstcall` AS `firstcall`
,`nptr`.`hours` AS `client_hours`
,`nptr`.`cash` AS `client_cash`
,`nptr`.`rate` AS `client_rate`
,`nptr`.`currency` AS `client_currency`
,`nptr`.`billnotes` AS `billnotes`
,`nptp`.`hours` AS `consultant_hours`
,`np`.`industryid` AS `project_industryid`
,`np`.`category` AS `project_type`
,IFNULL(`npct`.`taskmanagerid`,IFNULL(`npctcc`.`manageuid`,`npctc`.`manageuid`)) AS `taskmanagerid`
,`np`.`clientcode` AS `client_code`
,`nptp`.`cash` AS `consultant_cash`
,`nptp`.`currency` AS `consultant_currency`
,`nptp`.`type` AS `consultant_pay_method`
,IFNULL(`npct`.`paid`,IFNULL(`npctcc`.`paid`,`npctc`.`paid`)) AS `consultant_paid`
,`npct`.`type` AS `task_type`
,`npct`.`charge_extra_fee_ind` AS `senior_expert` 
FROM `ndb_project_task` `npt` 
	LEFT JOIN `ndb_project_task_receipts` `nptr` ON `npt`.`id` = `nptr`.`taskid`
	LEFT JOIN `ndb_project_task_payment` `nptp` ON `npt`.`id` = `nptp`.`taskid`
	LEFT JOIN `ndb_project_consultation_task` `npct` ON `npt`.`id` = `npct`.`id`
	LEFT JOIN `ndb_project_task_common` `npctc` ON `npt`.`id` = `npctc`.`id`
	LEFT JOIN `ndb_project_task_common_contact` `npctcc` ON `npt`.`id` = `npctcc`.`id`
	JOIN `ndb_project` `np` ON IFNULL(`npct`.`projectid`,IFNULL(`npctc`.`projectid`,`npctcc`.`projectid`)) = `np`.`id`
	LEFT JOIN `ndb_project_client` `npc` ON `np`.`id` = `npc`.`projectid`
	LEFT JOIN `ndb_view_report_invoicing1` `p1` ON `p1`.`projectid` = `np`.`id`
	LEFT JOIN `ndb_consultation_task_view_right` `t2` ON `t2`.`task_id` = `npt`.`id`
	LEFT JOIN `ndb_client` `nc` ON IFNULL(`npct`.`clientid`,IFNULL(`npctcc`.`clientid`,`npc`.`clientid`)) = `nc`.`id`
	LEFT JOIN `ndb_client_contact` `ncc` ON IFNULL(`t2`.`client_contact_id`,IFNULL(`npct`.`contactid`,IFNULL(`npctcc`.`contactid`,`p1`.`contactid`))) = `ncc`.`id`
	WHERE `npt`.`status` = 8 AND (`np`.`category` = 5 OR ISNULL(`npctc`.`id`))
$$
DELIMITER ;