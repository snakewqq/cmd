DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `proc_ndb_viewtable`$$

CREATE DEFINER=`root`@`%` PROCEDURE `proc_ndb_viewtable`()
BEGIN

DROP TABLE  IF EXISTS ndb.`ndb_v_client_ams_englishname`;
CREATE TABLE ndb.`ndb_v_client_ams_englishname` AS
    SELECT 
        `npct`.`id` AS `id`,
        GROUP_CONCAT(`ne`.`englishname`
            SEPARATOR ',') AS `englishname`
    FROM
        ((`ndb_client_am_percentage` `ncap`
        JOIN `ndb_employees` `ne` ON ((`ncap`.`amid` = `ne`.`id`)))
        LEFT JOIN `ndb_project_consultation_task` `npct` ON ((`ncap`.`clientid` = `npct`.`clientid`)))
    GROUP BY `npct`.`id` ;

DROP TABLE  IF EXISTS ndb.`ndb_v_consultant_referral_payment`;
CREATE TABLE ndb.`ndb_v_consultant_referral_payment` AS
SELECT 
        `npt`.`id` AS `taskid`,
        `npr`.`paid` AS `cf_status`,
        `ncrp`.`bankcash` AS `bankcash`,
        `ncrp`.`bankcurrency` AS `bankcurrency`,
        `ncrp`.`paid` AS `paid`,
        `ncrp`.`paidtime` AS `paidtime`,
        `npr`.`task_type` AS `task_type`,
        `npct`.`starttime` AS `starttime`,
        `npct`.`endtime` AS `endtime`,
        `np`.`id` AS `project_id`,
        `np`.`codename` AS `project_name`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `nrcon`.`id` AS `referral_id`,
        `nrcon`.`name` AS `referral_name`,
        `ncrp`.`cash` AS `referral_cash`,
        `ncrp`.`currency` AS `referral_currency`,
        `ncrp`.`type` AS `referral_type`,
        `ncrp`.`typeid` AS `referral_typeid`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `ncba`.`bank_type` AS `bank_type`,
        `ncba`.`bank_location` AS `bank_location`,
        `ncba`.`bank_identifier_type` AS `bank_identifier_type`,
        `ncba`.`bank_identifier` AS `bank_identifier`,
        `ncba`.`bankname` AS `bankname`,
        `ncba`.`accountname` AS `accountname`,
        `ncba`.`accountnumber` AS `accountnumber`,
        `ncba`.`otherinformation` AS `otherinformation`,
        `ncba`.`address` AS `address`,
        `np`.`category` AS `project_type`
    FROM
        ((((((((((`ndb_consultant_referral_payment` `ncrp`
        JOIN `ndb_payment_report` `npr` ON ((`npr`.`taskid` = `ncrp`.`taskid`)))
        JOIN `ndb_project_task` `npt` ON ((`npt`.`id` = `ncrp`.`taskid`)))
        JOIN `ndb_project_consultation_task` `npct` ON ((`npt`.`id` = `npct`.`id`)))
        JOIN `ndb_project` `np` ON ((`npct`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`ncrp`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_consultant` `nrcon` ON ((`ncrp`.`referralid` = `nrcon`.`id`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`npct`.`taskmanagerid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`npct`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
        LEFT JOIN `ndb_consultant_bank_account` `ncba` ON (((`ncon`.`id` = `ncba`.`consultantid`)
            AND (`ncba`.`ismain` = 1))))
    WHERE
        ((`npt`.`status` = 8)
            AND (`np`.`category` IN (1 , 12, 16))) ;
    INSERT INTO ndb.ndb_v_consultant_referral_payment SELECT 
        `npt`.`id` AS `taskid`,
        `npr`.`paid` AS `cf_status`,
        `ncrp`.`bankcash` AS `bankcash`,
        `ncrp`.`bankcurrency` AS `bankcurrency`,
        `ncrp`.`paid` AS `paid`,
        `ncrp`.`paidtime` AS `paidtime`,
        `npr`.`task_type` AS `task_type`,
        `nptc`.`starttime` AS `starttime`,
        `nptc`.`endtime` AS `endtime`,
        `np`.`id` AS `project_id`,
        `np`.`codename` AS `project_name`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `nrcon`.`id` AS `referral_id`,
        `nrcon`.`name` AS `referral_name`,
        `ncrp`.`cash` AS `referral_cash`,
        `ncrp`.`currency` AS `referral_currency`,
        `ncrp`.`type` AS `referral_type`,
        `ncrp`.`typeid` AS `referral_typeid`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `ncba`.`bank_type` AS `bank_type`,
        `ncba`.`bank_location` AS `bank_location`,
        `ncba`.`bank_identifier_type` AS `bank_identifier_type`,
        `ncba`.`bank_identifier` AS `bank_identifier`,
        `ncba`.`bankname` AS `bankname`,
        `ncba`.`accountname` AS `accountname`,
        `ncba`.`accountnumber` AS `accountnumber`,
        `ncba`.`otherinformation` AS `otherinformation`,
        `ncba`.`address` AS `address`,
        `np`.`category` AS `project_type`
    FROM
        ((((((((((`ndb_consultant_referral_payment` `ncrp`
        JOIN `ndb_payment_report` `npr` ON ((`npr`.`taskid` = `ncrp`.`taskid`)))
        JOIN `ndb_project_task` `npt` ON ((`npt`.`id` = `ncrp`.`taskid`)))
        JOIN `ndb_project_task_common` `nptc` ON ((`npt`.`id` = `nptc`.`id`)))
        JOIN `ndb_project` `np` ON ((`nptc`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`ncrp`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_consultant` `nrcon` ON ((`ncrp`.`referralid` = `nrcon`.`id`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`nptc`.`manageuid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`nptc`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
        LEFT JOIN `ndb_consultant_bank_account` `ncba` ON (((`ncon`.`id` = `ncba`.`consultantid`)
            AND (`ncba`.`ismain` = 1))))
    WHERE
        ((`npt`.`status` = 8)
            AND (`np`.`category` <> 1)
            AND (`np`.`category` <> 12)
            AND (`np`.`category` <> 16));

DROP TABLE  IF EXISTS ndb.`ndb_v_payment_report_summary` ;
CREATE TABLE ndb.`ndb_v_payment_report_summary` AS 
SELECT 
        `pt`.`id` AS `taskid`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_id`
            ELSE IFNULL(`pct`.`projectid`, `ptc`.`projectid`)
        END) AS `project_id`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`process_type`
            ELSE 0
        END) AS `process_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_id`
            ELSE `pct`.`clientid`
        END) AS `client_id`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`apply_type`
            ELSE NULL
        END) AS `apply_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`amount`
            ELSE `ptp`.`amount`
        END) AS `amount`,
        `t`.`adj_type` AS `adj_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`process_type`
            ELSE 0
        END) AS `paid`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`paytime`
            ELSE 0
        END) AS `paytime`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`charge_cash`
            ELSE 0.00
        END) AS `charge_cash`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`charge_currency`
            ELSE 0
        END) AS `charge_currency`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`starttime`
            ELSE IFNULL(`pct`.`starttime`, `ptc`.`starttime`)
        END) AS `starttime`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`endtime`
            ELSE IFNULL(`pct`.`endtime`, `ptc`.`endtime`)
        END) AS `endtime`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_name`
            ELSE `c`.`name`
        END) AS `client_name`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_name`
            ELSE `p`.`name`
        END) AS `project_name`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`client_hours`
            ELSE `ptr`.`hours`
        END) AS `client_hours`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`consultant_name`
            ELSE `con`.`name`
        END) AS `consultant_name`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`consultant_id`
            ELSE IFNULL(`pct`.`consultantid`,
                    `ptc`.`consultantid`)
        END) AS `consultant_id`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`consultant_hours`
            ELSE `ptp`.`hours`
        END) AS `consultant_hours`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`project_type`
            ELSE `p`.`category`
        END) AS `project_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`task_type`
            ELSE `pct`.`type`
        END) AS `task_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`company`
            ELSE `con`.`company_name`
        END) AS `company`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_location`
            ELSE `nl`.`name`
        END) AS `bank_location`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_identifier_type`
            ELSE `ba`.`bank_identifier_type`
        END) AS `bank_identifier_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_identifier`
            ELSE `ba`.`bank_identifier`
        END) AS `bank_identifier`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`address`
            ELSE `ba`.`address`
        END) AS `address`,
        `t`.`change_reason` AS `change_reason`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`payment_type`
            ELSE `ptp`.`type`
        END) AS `payment_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`typeofinterview`
            ELSE `pct`.`typeofinterview`
        END) AS `typeofinterview`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`tm_englishname`
            ELSE `e2`.`englishname`
        END) AS `tm_englishname`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`km_englishname`
            ELSE `e`.`englishname`
        END) AS `km_englishname`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bank_type`
            ELSE `ba`.`bank_type`
        END) AS `bank_type`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`accountname`
            ELSE `ba`.`accountname`
        END) AS `accountname`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`bankname`
            ELSE `ba`.`bankname`
        END) AS `bankname`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`accountnumber`
            ELSE `ba`.`accountnumber`
        END) AS `accountnumber`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`otherinformation`
            ELSE `ba`.`otherinformation`
        END) AS `otherinformation`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`rate`
            ELSE `con`.`rate`
        END) AS `rate`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`rate_currency`
            ELSE `con`.`currency`
        END) AS `rate_currency`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`consultant_cash`
            ELSE `ptp`.`cash`
        END) AS `consultant_cash`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`payment_currency`
            ELSE `ptp`.`currency`
        END) AS `payment_currency`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `pr`.`mobilerecharge`
            ELSE NULL
        END) AS `mobilerecharge`,
        (CASE
            WHEN (`pr`.`taskid` IS NOT NULL) THEN `t`.`change_reason`
            ELSE `ptp`.`paymentnotes`
        END) AS `paymentnotes`
    FROM
        ((((((((((((((`ndb_project_task` `pt`
        LEFT JOIN `ndb_payment_report` `pr` ON (((`pr`.`taskid` = `pt`.`id`)
            AND (`pr`.`payment_status` IN (1 , 3)))))
        LEFT JOIN `ndb_payment_report_detail` `t` ON (((`pr`.`taskid` = `t`.`taskid`)
            AND (`t`.`process_type` <> 2))))
        LEFT JOIN `ndb_project_consultation_task` `pct` ON ((`pct`.`id` = `pt`.`id`)))
        LEFT JOIN `ndb_project_task_common` `ptc` ON ((`ptc`.`id` = `pt`.`id`)))
        LEFT JOIN `ndb_project_task_payment` `ptp` ON ((`ptp`.`taskid` = `pt`.`id`)))
        LEFT JOIN `ndb_project_task_receipts` `ptr` ON ((`ptr`.`taskid` = `pt`.`id`)))
        LEFT JOIN `ndb_project` `p` ON ((`p`.`id` = IFNULL(`pct`.`projectid`, `ptc`.`projectid`))))
        LEFT JOIN `ndb_project_team` `pte` ON (((`pte`.`projectid` = `p`.`id`)
            AND (`pte`.`role` = 2))))
        LEFT JOIN `ndb_client` `c` ON ((`c`.`id` = `pct`.`clientid`)))
        LEFT JOIN `ndb_consultant` `con` ON ((`con`.`id` = IFNULL(`pct`.`consultantid`, `ptc`.`consultantid`))))
        LEFT JOIN `ndb_consultant_bank_account` `ba` ON (((`ba`.`consultantid` = IFNULL(`pct`.`consultantid`, `ptc`.`consultantid`))
            AND (`ba`.`ismain` = 1))))
        LEFT JOIN `ndb_employees` `e` ON ((`e`.`id` = `pte`.`uid`)))
        LEFT JOIN `ndb_employees` `e2` ON ((`e2`.`id` = IFNULL(`pct`.`taskmanagerid`, `ptc`.`manageuid`))))
        LEFT JOIN `ndb_location` `nl` ON ((`nl`.`id` = `ba`.`bank_location`)))
    WHERE
        ((`p`.`category` <> 5)
            AND (`pt`.`status` = 8)) ;

DROP TABLE  IF EXISTS ndb.`ndb_v_payment_review`  ;
CREATE TABLE ndb.`ndb_v_payment_review` AS
SELECT 
        `npt`.`id` AS `taskid`,
        IFNULL(`npct`.`starttime`, `npnct`.`starttime`) AS `starttime`,
        IFNULL(`npct`.`endtime`, `npnct`.`endtime`) AS `endtime`,
        IFNULL(`npct`.`consultantid`,
                `npnct`.`consultantid`) AS `consultant_id`,
        IFNULL(`npct`.`taskmanagerid`,
                `npnct`.`taskmanagerid`) AS `taskmanagerid`,
        `np`.`id` AS `project_id`,
        `np`.`name` AS `project_name`,
        `np`.`category` AS `project_category`,
        `nptp`.`hours` AS `consultant_hours`,
        `nptp`.`cash` AS `consultant_cash`,
        `nptp`.`currency` AS `payment_currency`
    FROM
        ((((`ndb_project_task` `npt`
        LEFT JOIN `ndb_project_consultation_task` `npct` ON ((`npt`.`id` = `npct`.`id`)))
        LEFT JOIN `ndb_project_task_common` `npnct` ON ((`npt`.`id` = `npnct`.`id`)))
        JOIN `ndb_project` `np` ON ((IFNULL(`npct`.`projectid`, `npnct`.`projectid`) = `np`.`id`)))
        LEFT JOIN `ndb_project_task_payment` `nptp` ON ((`npt`.`id` = `nptp`.`taskid`)))
    WHERE
        ((`npt`.`status` = 8)
            AND (`npt`.`paymentstatus` = 2));

DROP TABLE  IF EXISTS ndb.`ndb_v_report_compliance`  ;
CREATE TABLE ndb.`ndb_v_report_compliance` AS  
SELECT 
        `npt`.`id` AS `task_id`,
        `npt`.`status` AS `status`,
        `npct`.`starttime` AS `starttime`,
        `npct`.`endtime` AS `endtime`,
        `nc`.`id` AS `client_id`,
        `nc`.`name` AS `client_name`,
        `np`.`id` AS `project_id`,
        `np`.`name` AS `project_name`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `npctb`.`company` AS `company`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `npt`.`createtime` AS `createtime`,
        `np`.`category` AS `project_type`
    FROM
        ((((((((`ndb_project_task` `npt`
        JOIN `ndb_project_consultation_task` `npct` ON ((`npt`.`id` = `npct`.`id`)))
        JOIN `ndb_project` `np` ON ((`npct`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_client` `nc` ON ((`npct`.`clientid` = `nc`.`id`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`npct`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_project_consultation_task_background` `npctb` ON ((`npct`.`id` = `npctb`.`taskid`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`npct`.`taskmanagerid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`npct`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
    WHERE
        ((`npt`.`status` IN (6 , 7, 8))
            AND (`np`.`category` = 1)) ;
INSERT INTO ndb.ndb_v_report_compliance SELECT 
        `npt`.`id` AS `task_id`,
        `npt`.`status` AS `status`,
        `nptc`.`starttime` AS `starttime`,
        `nptc`.`endtime` AS `endtime`,
        NULL AS `client_id`,
        NULL AS `client_name`,
        `np`.`id` AS `project_id`,
        `np`.`name` AS `project_name`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `ncv`.`name` AS `company`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `npt`.`createtime` AS `createtime`,
        `np`.`category` AS `project_type`
    FROM
        ((((((((`ndb_project_task` `npt`
        JOIN `ndb_project_task_common` `nptc` ON ((`npt`.`id` = `nptc`.`id`)))
        JOIN `ndb_project` `np` ON ((`nptc`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`nptc`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_consultant_position` `ncp` ON ((`ncp`.`id` = `ncon`.`currentpositionid`)))
        LEFT JOIN `ndb_company_vocabulary` `ncv` ON ((`ncp`.`company` = `ncv`.`id`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`nptc`.`manageuid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`nptc`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
    WHERE
        ((`npt`.`status` IN (6 , 7, 8))
            AND (`np`.`category` <> 1)) ;

DROP TABLE  IF EXISTS ndb.`ndb_v_report_invoicing1`  ;
CREATE TABLE ndb.`ndb_v_report_invoicing1` AS
    SELECT 
        `ndb`.`ndb_project_client_contact`.`projectid` AS `projectid`,
        SUBSTRING_INDEX(MAX(CONCAT(IFNULL(`ndb`.`ndb_project_client_contact`.`CRE_DT`,
                                '1262275200'),
                        '|',
                        `ndb`.`ndb_project_client_contact`.`contactid`)),
                '|',
                -(1)) AS `contactid`
    FROM
        `ndb_project_client_contact`
    GROUP BY `ndb`.`ndb_project_client_contact`.`projectid`;

ALTER TABLE ndb.`ndb_v_report_invoicing1` ADD INDEX ix_projectid (projectid);

DROP TABLE  IF EXISTS ndb.`ndb_v_report_invoicing`  ;
CREATE TABLE ndb.`ndb_v_report_invoicing` AS
SELECT 
        `npt`.`id` AS `task_id`,
        `nc`.`id` AS `client_id`,
        `nc`.`name` AS `client_name`,
        IFNULL(`npct`.`starttime`,
                IFNULL(`npctcc`.`starttime`,
                        `npctc`.`starttime`)) AS `starttime`,
        IFNULL(`npct`.`endtime`,
                IFNULL(`npctcc`.`endtime`, `npctc`.`endtime`)) AS `endtime`,
        `ncc`.`id` AS `contact_id`,
        `ncc`.`chinesename` AS `contact_chinesename`,
        `ncc`.`firstname` AS `contact_firstname`,
        `ncc`.`lastname` AS `contact_lastname`,
        `np`.`id` AS `project_id`,
        `np`.`codename` AS `project_name`,
        `npct`.`typeofinterview` AS `typeofinterview`,
        `npct`.`firstcall` AS `firstcall`,
        `nptr`.`hours` AS `client_hours`,
        `nptr`.`cash` AS `client_cash`,
        `nptr`.`rate` AS `client_rate`,
        `nptr`.`currency` AS `client_currency`,
        `nptr`.`billnotes` AS `billnotes`,
        `nptp`.`hours` AS `consultant_hours`,
        `np`.`industryid` AS `project_industryid`,
        `np`.`category` AS `project_type`,
        IFNULL(`npct`.`taskmanagerid`,
                IFNULL(`npctcc`.`manageuid`,
                        `npctc`.`manageuid`)) AS `taskmanagerid`,
        `np`.`clientcode` AS `client_code`,
        `nptp`.`cash` AS `consultant_cash`,
        `nptp`.`currency` AS `consultant_currency`,
        `nptp`.`type` AS `consultant_pay_method`,
        IFNULL(`npct`.`paid`,
                IFNULL(`npctcc`.`paid`, `npctc`.`paid`)) AS `consultant_paid`,
        `npct`.`type` AS `task_type`,
        `npct`.`charge_extra_fee_ind` AS `senior_expert`
    FROM
        (((((((((((`ndb_project_task` `npt`
        LEFT JOIN `ndb_project_task_receipts` `nptr` ON ((`npt`.`id` = `nptr`.`taskid`)))
        LEFT JOIN `ndb_project_task_payment` `nptp` ON ((`npt`.`id` = `nptp`.`taskid`)))
        LEFT JOIN `ndb_project_consultation_task` `npct` ON ((`npt`.`id` = `npct`.`id`)))
        LEFT JOIN `ndb_project_task_common` `npctc` ON ((`npt`.`id` = `npctc`.`id`)))
        LEFT JOIN `ndb_project_task_common_contact` `npctcc` ON ((`npt`.`id` = `npctcc`.`id`)))
        JOIN `ndb_project` `np` ON ((IFNULL(`npct`.`projectid`, IFNULL(`npctc`.`projectid`, `npctcc`.`projectid`)) = `np`.`id`)))
        LEFT JOIN `ndb_project_client` `npc` ON ((`np`.`id` = `npc`.`projectid`)))
        LEFT JOIN `ndb_v_report_invoicing1` `p1` ON ((`p1`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_consultation_task_view_right` `t2` ON ((`t2`.`task_id` = `npt`.`id`)))
        LEFT JOIN `ndb_client` `nc` ON ((IFNULL(`npct`.`clientid`, IFNULL(`npctcc`.`clientid`, `npc`.`clientid`)) = `nc`.`id`)))
        LEFT JOIN `ndb_client_contact` `ncc` ON ((IFNULL(`t2`.`client_contact_id`, IFNULL(`npct`.`contactid`, IFNULL(`npctcc`.`contactid`, `p1`.`contactid`))) = `ncc`.`id`)))
    WHERE
        ((`npt`.`status` = 8)
            AND ((`np`.`category` = 5)
            OR ISNULL(`npctc`.`id`))) ;

ALTER TABLE ndb.`ndb_v_report_invoicing1` DROP INDEX ix_projectid;


DROP TABLE IF EXISTS ndb.`ndb_v_report_payment`;

CREATE TABLE  ndb.`ndb_v_report_payment` AS
    SELECT 
        `npt`.`id` AS `taskid`,
        `npct`.`paid` AS `paid`,
        `npct`.`starttime` AS `starttime`,
        `npct`.`endtime` AS `endtime`,
        `nc`.`id` AS `client_id`,
        `nc`.`name` AS `client_name`,
        `np`.`id` AS `project_id`,
        `np`.`name` AS `project_name`,
        `nptr`.`hours` AS `client_hours`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `npctb`.`company` AS `company`,
        `nptp`.`hours` AS `consultant_hours`,
        `nptp`.`cash` AS `consultant_cash`,
        `nptp`.`currency` AS `payment_currency`,
        `npct`.`typeofinterview` AS `typeofinterview`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `ncba`.`bankname` AS `bankname`,
        `ncba`.`accountname` AS `accountname`,
        `ncba`.`accountnumber` AS `accountnumber`,
        `ncba`.`otherinformation` AS `otherinformation`,
        `ncon`.`rate` AS `rate`,
        `ncon`.`currency` AS `rate_currency`,
        ROUND((`nptp`.`hours` * `ncon`.`rate`), 2) AS `amount`,
        `nptp`.`paymentnotes` AS `paymentnotes`,
        `np`.`category` AS `project_type`
    FROM
        (((((((((((`ndb_project_task` `npt`
        JOIN `ndb_project_consultation_task` `npct` ON ((`npt`.`id` = `npct`.`id`)))
        JOIN `ndb_project` `np` ON ((`npct`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_client` `nc` ON ((`npct`.`clientid` = `nc`.`id`)))
        LEFT JOIN `ndb_project_task_receipts` `nptr` ON ((`npct`.`id` = `nptr`.`taskid`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`npct`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_project_consultation_task_background` `npctb` ON ((`npct`.`id` = `npctb`.`taskid`)))
        LEFT JOIN `ndb_project_task_payment` `nptp` ON ((`npct`.`id` = `nptp`.`taskid`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`npct`.`taskmanagerid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`npct`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
        LEFT JOIN `ndb_consultant_bank_account` `ncba` ON (((`npct`.`consultantid` = `ncba`.`consultantid`)
            AND (`ncba`.`ismain` = 1))))
    WHERE
        ((`npt`.`status` = 8)
            AND (`np`.`category` IN (1 , 12))) ;

   INSERT INTO ndb.ndb_v_report_payment SELECT 
        `npt`.`id` AS `taskid`,
        `nptc`.`paid` AS `paid`,
        `nptc`.`starttime` AS `starttime`,
        `nptc`.`endtime` AS `endtime`,
        `nc`.`id` AS `client_id`,
        `nc`.`name` AS `client_name`,
        `np`.`id` AS `project_id`,
        `np`.`name` AS `project_name`,
        `nptr`.`hours` AS `client_hours`,
        `ncon`.`id` AS `consultant_id`,
        `ncon`.`name` AS `consultant_name`,
        `ncv`.`name` AS `company`,
        `nptp`.`hours` AS `consultant_hours`,
        `nptp`.`cash` AS `consultant_cash`,
        `nptp`.`currency` AS `payment_currency`,
        NULL AS `typeofinterview`,
        `ne_tm`.`englishname` AS `tm_englishname`,
        `ne_km`.`englishname` AS `km_englishname`,
        `ncba`.`bankname` AS `bankname`,
        `ncba`.`accountname` AS `accountname`,
        `ncba`.`accountnumber` AS `accountnumber`,
        `ncba`.`otherinformation` AS `otherinformation`,
        `ncon`.`rate` AS `rate`,
        `ncon`.`currency` AS `rate_currency`,
        ROUND((`nptp`.`hours` * `ncon`.`rate`), 2) AS `amount`,
        `nptp`.`paymentnotes` AS `paymentnotes`,
        `np`.`category` AS `project_type`
    FROM
        (((((((((((((`ndb_project_task` `npt`
        JOIN `ndb_project_task_common` `nptc` ON ((`npt`.`id` = `nptc`.`id`)))
        JOIN `ndb_project` `np` ON ((`nptc`.`projectid` = `np`.`id`)))
        LEFT JOIN `ndb_project_task_receipts` `nptr` ON ((`nptc`.`id` = `nptr`.`taskid`)))
        LEFT JOIN `ndb_project_client` `npc` ON ((`nptc`.`projectid` = `npc`.`projectid`)))
        LEFT JOIN `ndb_client` `nc` ON ((`npc`.`clientid` = `nc`.`id`)))
        LEFT JOIN `ndb_consultant` `ncon` ON ((`nptc`.`consultantid` = `ncon`.`id`)))
        LEFT JOIN `ndb_consultant_position` `ncp` ON ((`ncp`.`id` = `ncon`.`currentpositionid`)))
        LEFT JOIN `ndb_company_vocabulary` `ncv` ON ((`ncp`.`company` = `ncv`.`id`)))
        LEFT JOIN `ndb_project_task_payment` `nptp` ON ((`nptc`.`id` = `nptp`.`taskid`)))
        LEFT JOIN `ndb_employees` `ne_tm` ON ((`nptc`.`manageuid` = `ne_tm`.`id`)))
        LEFT JOIN `ndb_project_team` `npt_km` ON (((`nptc`.`projectid` = `npt_km`.`projectid`)
            AND (`npt_km`.`role` = 2))))
        LEFT JOIN `ndb_employees` `ne_km` ON ((`npt_km`.`uid` = `ne_km`.`id`)))
        LEFT JOIN `ndb_consultant_bank_account` `ncba` ON (((`nptc`.`consultantid` = `ncba`.`consultantid`)
            AND (`ncba`.`ismain` = 1))))
    WHERE
        ((`npt`.`status` = 8)
            AND (`np`.`category` NOT IN (1 , 12)));

END$$

DELIMITER ;