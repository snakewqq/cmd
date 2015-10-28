DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `proc_ndb_view_dbsearch`$$

CREATE DEFINER=`root`@`%` PROCEDURE `proc_ndb_view_dbsearch`()
BEGIN

DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch1;
 CREATE TABLE ndb.ndb_v_dbsearch1 AS SELECT 
        `ndb`.`ndb_consultant_background`.`consultantid` AS `cnsltnt_id`,
        MAX((CASE
            WHEN (`ndb`.`ndb_consultant_background`.`type` = 1) THEN `ndb`.`ndb_consultant_background`.`background`
        END)) AS `bckgrnd_txt`,
        MAX((CASE
            WHEN (`ndb`.`ndb_consultant_background`.`type` = 1) THEN `ndb`.`ndb_consultant_background`.`expertise`
        END)) AS `exprts_txt`,
        MAX((CASE
            WHEN (`ndb`.`ndb_consultant_background`.`type` = 2) THEN `ndb`.`ndb_consultant_background`.`background`
        END)) AS `bckgrnd_txt_eng`,
        MAX((CASE
            WHEN (`ndb`.`ndb_consultant_background`.`type` = 2) THEN `ndb`.`ndb_consultant_background`.`expertise`
        END)) AS `exprts_txt_eng`
    FROM
        `ndb_consultant_background` WHERE UPD_TS>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY))  OR CRE_DT>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY))   
    GROUP BY `ndb`.`ndb_consultant_background`.`consultantid` ;


DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch2;
CREATE TABLE ndb.ndb_v_dbsearch2 AS 
SELECT `ndb`.`ndb_consultant_request`.`consultantid` AS `cnsltnt_id`,
        GROUP_CONCAT((CASE
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 1) THEN 'referral'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 2) THEN 'find jobs'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 3) THEN 'hiring'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 4) THEN 'deal sourcing'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 5) THEN 'market research'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 6) THEN 'corporate request'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 7) THEN 'other'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 8) THEN 'coupon services'
                WHEN (`ndb`.`ndb_consultant_request`.`type` = 9) THEN 'panel'
                ELSE 'other'
            END),
            ': ',
            `ndb`.`ndb_consultant_request`.`message`,
            CHAR(13)
            SEPARATOR ',') AS `note`
    FROM
        `ndb_consultant_request`
    WHERE
        (`ndb`.`ndb_consultant_request`.`type` <> 8)
    GROUP BY `ndb`.`ndb_consultant_request`.`consultantid`;

DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch3;
CREATE TABLE ndb.ndb_v_dbsearch3 AS 
SELECT 
        `ndb`.`ndb_notes`.`objectid` AS `cnsltnt_id`,
        GROUP_CONCAT(`ndb`.`ndb_notes`.`note`, CHAR(13)
            SEPARATOR ',') AS `note`
    FROM
        `ndb_notes`
    WHERE
        (`ndb`.`ndb_notes`.`type` = 1)
    GROUP BY `ndb`.`ndb_notes`.`objectid`;


DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch4;
CREATE TABLE ndb.ndb_v_dbsearch4 AS  
SELECT 
        `ndb`.`ndb_consultant_profile`.`consultantid` AS `cnsltnt_id`,
        MAX(`ndb`.`ndb_consultant_profile`.`value`) AS `last_contact_time`
    FROM
        `ndb_consultant_profile`
    WHERE
        (`ndb`.`ndb_consultant_profile`.`attribute` = 'contact_time')
    GROUP BY `ndb`.`ndb_consultant_profile`.`consultantid`;

DROP TABLE IF EXISTS ndb.ndb_v_dbsearch5;
CREATE TABLE ndb.ndb_v_dbsearch5 SELECT `cpf`.`positionid` AS `positionid`,MAX(`cpf`.`functionid`) AS `functionid` FROM `ndb_consultant_position_function` `cpf` GROUP BY `cpf`.`positionid`;


ALTER TABLE ndb.`ndb_v_dbsearch5` ADD INDEX ix_positionid(positionid);

DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch6;
CREATE TABLE ndb.ndb_v_dbsearch6 AS  
SELECT 
        `cp`.`consultantid` AS `cnsltnt_id`,
        GROUP_CONCAT(DISTINCT (CASE
                WHEN (`cv`.`industry` <> 0) THEN `cv`.`industry`
            END)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ',') AS `indstry_id`,
        GROUP_CONCAT(DISTINCT (CASE
                WHEN (`cv`.`subindustry` <> 0) THEN `cv`.`subindustry`
            END)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ',') AS `subindstry_id`,
        GROUP_CONCAT(DISTINCT (CASE
                WHEN (`cpf`.`functionid` <> 0) THEN `cpf`.`functionid`
            END)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ',') AS `fnctn_id`,
        GROUP_CONCAT(CONCAT(`ind1`.`name`, ',', `cv`.`industry`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `indstry`,
        GROUP_CONCAT(CONCAT(`ind2`.`name`, ',', `cv`.`subindustry`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `subindstry`,
        GROUP_CONCAT(CONCAT(`cv`.`name`, ',', `cp`.`company`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `cmpny`,
        GROUP_CONCAT(CONCAT(`pv`.`name`, ',', `cp`.`position`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `pstn`,
        GROUP_CONCAT(CONCAT(`ntt`.`name`, ',', `cpf`.`functionid`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `fnctn`,
        GROUP_CONCAT((CASE
                WHEN (`cp`.`iscurrent` = 1) THEN 'current '
                ELSE ''
            END),
            IFNULL(`cp`.`startdate_string`, 'N/A'),
            ' to ',
            IFNULL(`cp`.`enddate_string`, 'N/A'),
            '  ',
            IFNULL(`cv`.`name`, 'N/A'),
            '  ',
            IFNULL(`pv`.`name`, 'N/A'),
            '  ',
            `ind1`.`name`,
            '-',
            `ind2`.`name`
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR '
                                    ') AS `work_exprnc_txt`,
        GROUP_CONCAT(CONCAT(`cv`.`englishname`, ',', `cp`.`company`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `cmpny_eng`,
        GROUP_CONCAT(CONCAT(`pv`.`englishname`, ',', `cp`.`position`)
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR ';') AS `pstn_eng`,
        GROUP_CONCAT((CASE
                WHEN (`cp`.`iscurrent` = 1) THEN 'current '
                ELSE ''
            END),
            IFNULL(`cp`.`startdate_string`, 'N/A'),
            ' to ',
            IFNULL(`cp`.`enddate_string`, 'N/A'),
            '  ',
            IFNULL(`cv`.`englishname`, 'N/A'),
            '  ',
            IFNULL(`pv`.`englishname`, 'N/A'),
            '  ',
            `ind1`.`name`,
            '-',
            `ind2`.`name`
            ORDER BY `cp`.`iscurrent` DESC , `cp`.`startdate_string` DESC , `cp`.`id` DESC
            SEPARATOR '
                                    ') AS `work_exprnc_txt_eng`
    FROM
        ((((((`ndb_consultant_position` `cp` 
        LEFT JOIN `ndb_position_vocabulary` `pv` ON ((`pv`.`id` = `cp`.`position`)))
        LEFT JOIN `ndb_company_vocabulary` `cv` ON ((`cv`.`id` = `cp`.`company`)))
        LEFT JOIN `ndb_v_dbsearch5` `cpf` ON ((`cpf`.`positionid` = `cp`.`id`)))
        LEFT JOIN `ndb_taxonomy_term` `ntt` ON (((`ntt`.`id` = `cpf`.`functionid`)
            AND (`ntt`.`taxonomyid` = 5))))
        LEFT JOIN `ndb_taxonomy_term` `ind1` ON (((`ind1`.`id` = `cv`.`industry`)
            AND (`ind1`.`taxonomyid` = 1))))
        LEFT JOIN `ndb_taxonomy_term` `ind2` ON (((`ind2`.`id` = `cv`.`subindustry`)
            AND (`ind2`.`taxonomyid` = 1))))  WHERE cp.UPD_TS>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY))  OR cp.CRE_DT>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY))  
    GROUP BY `cp`.`consultantid`;


DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch7;
CREATE TABLE ndb.ndb_v_dbsearch7 AS  
  SELECT 
        `a`.`consultantid` AS `cnsltnt_id`,
        GROUP_CONCAT(DISTINCT `b`.`id`
            SEPARATOR ',') AS `panel_id`,
        GROUP_CONCAT(CONCAT(`b`.`name`, ',', `b`.`id`)
            SEPARATOR ';') AS `panel`
    FROM
        (`ndb_panel_consultant` `a`
        JOIN `ndb_panel` `b` ON ((`a`.`panelid` = `b`.`id`)))
    GROUP BY `a`.`consultantid`;


DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch8;
CREATE TABLE ndb.ndb_v_dbsearch8 AS  
 SELECT 
        CAST(TRIM(`c`.`origin_value`) AS UNSIGNED) AS `cnsltnt_id`,
        GROUP_CONCAT(CONCAT(TRIM(`c`.`name`), ',', `c`.`id`)
            SEPARATOR ';') AS `rfrl`
    FROM
        `ndb_consultant` `c`
    WHERE
        ((`c`.`origin_id` = 1)
            AND (`c`.`origin_value` <> 0))
    GROUP BY TRIM(`c`.`origin_value`) ;

DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch9;
CREATE TABLE ndb.ndb_v_dbsearch9 AS  
SELECT 
        `nc`.`objectid` AS `cnsltnt_id`,
        GROUP_CONCAT(CONCAT(`cm`.`countrycode`, '-', `cm`.`mobile`)
            ORDER BY `nc`.`main` DESC , `nc`.`id` DESC
            SEPARATOR ',') AS `mobile`,
        GROUP_CONCAT(CONCAT(`ct`.`countrycode`,
                    '-',
                    `ct`.`citycode`,
                    '-',
                    `ct`.`telephone`,
                    '-',
                    `ct`.`extension`)
            ORDER BY `nc`.`main` DESC , `nc`.`id` DESC
            SEPARATOR ',') AS `telephone`,
        GROUP_CONCAT(`co`.`value`
            ORDER BY `nc`.`main` DESC , `nc`.`id` DESC
            SEPARATOR ',') AS `email`
    FROM
        (((`ndb_contacts` `nc`
        LEFT JOIN `ndb_contact_mobile` `cm` ON (((`cm`.`id` = `nc`.`contactid`)
            AND (`nc`.`contacttype` = 1))))
        LEFT JOIN `ndb_contact_telephone` `ct` ON (((`ct`.`id` = `nc`.`contactid`)
            AND (`nc`.`contacttype` = 2))))
        LEFT JOIN `ndb_contact_others` `co` ON (((`co`.`id` = `nc`.`contactid`)
            AND (`nc`.`contacttype` = 9))))
    WHERE
        (`nc`.`type` = 1) AND (nc.UPD_TS>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY)) OR nc.CRE_DT>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY)))   
    GROUP BY `nc`.`objectid`;

ALTER TABLE ndb_v_dbsearch1 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch2 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch3 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch4 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch6 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch7 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch9 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE ndb_v_dbsearch8 ADD INDEX ix_cnsltnt_id(cnsltnt_id);

DROP TABLE IF EXISTS   ndb.ndb_v_dbsearch;
CREATE TABLE ndb.ndb_v_dbsearch AS  
SELECT 
        `c`.`id` AS `cnsltnt_id`,
        (CASE
            WHEN
                ((IFNULL(`c`.`lastname`, '') = '')
                    AND (IFNULL(`c`.`firstname`, '') = ''))
            THEN
                NULL
            ELSE CONCAT(TRIM(IFNULL(`c`.`lastname`, '')),
                    TRIM(IFNULL(`c`.`firstname`, '')))
        END) AS `cnsltnt_name`,
        (CASE
            WHEN
                ((IFNULL(`c`.`lastname_eng`, '') = '')
                    AND (IFNULL(`c`.`firstname_eng`, '') = ''))
            THEN
                NULL
            ELSE CONCAT(TRIM(IFNULL(`c`.`firstname_eng`, '')),
                    ' ',
                    TRIM(IFNULL(`c`.`lastname_eng`, '')))
        END) AS `cnsltnt_name_eng`,
        `c`.`status` AS `cnsltnt_sts_cd`,
        `c`.`type` AS `cnsltnt_type_cd`,
        `c`.`uid` AS `user_cre_uid`,
        `c`.`countryid` AS `cntry_id`,
        `c`.`province` AS `prvnc_id`,
        `c`.`city` AS `city_id`,
        `we`.`indstry_id` AS `indstry_id`,
        `we`.`subindstry_id` AS `subindstry_id`,
        `we`.`fnctn_id` AS `fnctn_id`,
        `pnl`.`panel_id` AS `panel_id`,
        CONCAT(`l1`.`name`, ',', `c`.`countryid`) AS `cntry`,
        CONCAT(`l2`.`name`, ',', `c`.`province`) AS `prvnc`,
        CONCAT(`l3`.`name`, ',', `c`.`city`) AS `city`,
        `c`.`rate` AS `rate`,
        `c`.`currency` AS `currency`,
        `c`.`createtime` AS `user_cre_ts`,
        `p`.`last_contact_time` AS `last_cntct_ts`,
        `we`.`indstry` AS `indstry`,
        `we`.`subindstry` AS `subindstry`,
        `we`.`cmpny` AS `cmpny`,
        `we`.`pstn` AS `pstn`,
        `we`.`fnctn` AS `fnctn`,
        `we`.`work_exprnc_txt` AS `work_exprnc_txt`,
        `we`.`cmpny_eng` AS `cmpny_eng`,
        `we`.`pstn_eng` AS `pstn_eng`,
        `we`.`work_exprnc_txt_eng` AS `work_exprnc_txt_eng`,
        (CASE
            WHEN (`c`.`consultations` = 0) THEN NULL
            ELSE `c`.`consultations`
        END) AS `calls`,
        (CASE
            WHEN (`c`.`completedconsultations` = 0) THEN NULL
            ELSE `c`.`completedconsultations`
        END) AS `cmplt_call`,
        `c`.`warningbar` AS `wrngbr_txt`,
        `pnl`.`panel` AS `panel`,
        `cntct`.`mobile` AS `mobile`,
        `cntct`.`telephone` AS `telephone`,
        `cntct`.`email` AS `email`,
        `rfrl`.`rfrl` AS `rfrl`,
        `req`.`note` AS `mkt_rqst`,
        `note`.`note` AS `note`,
        `ba`.`bckgrnd_txt` AS `bckgrnd_txt`,
        `ba`.`exprts_txt` AS `exprts_txt`,
        `ba`.`bckgrnd_txt_eng` AS `bckgrnd_txt_eng`,
        `ba`.`exprts_txt_eng` AS `exprts_txt_eng`,
        `c`.`last_upd_ts` AS `last_upd_ts`,
        (CASE
            WHEN (IFNULL(`c`.`completedconsultations`, 0) = 0) THEN 0
            ELSE 1
        END) AS `call_sort_ind`
    FROM
        (((((((((((`ndb_consultant`  `c` 
        LEFT JOIN `ndb_location` `l1` ON ((`c`.`countryid` = `l1`.`id`)))
        LEFT JOIN `ndb_location` `l2` ON ((`c`.`province` = `l2`.`id`)))
        LEFT JOIN `ndb_location` `l3` ON ((`c`.`city` = `l3`.`id`)))
        LEFT JOIN `ndb_v_dbsearch1` `ba` ON ((`ba`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch2` `req` ON ((`req`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch3` `note` ON ((`note`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch4` `p` ON ((`p`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch6` `we` ON ((`we`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch7` `pnl` ON ((`pnl`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch8` `rfrl` ON ((`rfrl`.`cnsltnt_id` = `c`.`id`)))
        LEFT JOIN `ndb_v_dbsearch9` `cntct` ON ((`cntct`.`cnsltnt_id` = `c`.`id`))) 
	    WHERE c.last_upd_ts>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY)) OR c.createtime>UNIX_TIMESTAMP(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -14 DAY)) ;


ALTER TABLE ndb.`ndb_v_dbsearch5` DROP INDEX ix_positionid;

ALTER TABLE ndb_v_dbsearch1 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch2 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch3 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch4 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch6 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch7 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch8 DROP INDEX ix_cnsltnt_id;
ALTER TABLE ndb_v_dbsearch9 DROP INDEX ix_cnsltnt_id;

DROP TABLE ndb_v_dbsearch1,ndb_v_dbsearch2,ndb_v_dbsearch3,ndb_v_dbsearch4,ndb_v_dbsearch5,
ndb_v_dbsearch6,ndb_v_dbsearc7,ndb_v_dbsearch8,ndb_v_dbsearch9;
END$$

DELIMITER ;