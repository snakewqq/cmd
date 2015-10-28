DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `proc_clnt_quota`$$

CREATE DEFINER=`root`@`%` PROCEDURE `proc_clnt_quota`()
BEGIN


    

CALL dw_simp.add_index('v_user','ix_UID','UID');
CALL dw_simp.add_index('v_clnt_cntct','ix_CLNT_CNTCT_ID','CLNT_CNTCT_ID');
CALL dw_simp.add_index('v_clnt ','ix_CLNT_ID','CLNT_ID');
CALL dw_simp.add_index('dw_clnt_grp_quota','ix_clnt_grp_id','clnt_grp_id');
#alter table dw_simp.v_user  add index ix_UID(UID);
#alter table   dw_simp.v_clnt_cntct  add index ix_CLNT_CNTCT_ID(CLNT_CNTCT_ID);
#alter table  dw_simp.v_clnt add index ix_CLNT_ID(CLNT_ID);
#alter table  dw_simp.dw_clnt_grp_quota add index ix_clnt_grp_id(clnt_grp_id);

DROP TABLE IF EXISTS dw_simp.km_clnt_quota1;
CREATE TABLE dw_simp.km_clnt_quota1 AS 
     SELECT 
        CONCAT(DATE_FORMAT(IFNULL(`b`.`BEG_DT`,
                                IFNULL(`b`.`TASK_STS_UPD_DT`, `b`.`END_DT`)),
                        '%Y-%m-'),
                '01') AS `month_begin_dt`,
        `b`.`CLNT_ID` AS `clnt_id`,
        `ct`.`CLNT_CNTCT_ID` AS `CLNT_CNTCT_ID`,
        `ct`.`CLNT_CNTCT_NAME` AS `CLNT_CNTCT_NAME`,
        `ct`.`CLNT_GRP_ID` AS `clnt_grp_id`,
        MAX(`uc`.`USER_ENG_NAME`) AS `clnt_am_name`,
        MAX(`c`.`CLNT_NAME`) AS `clnt_name`,
        MAX(`c`.`CLNT_TYPE_NAME`) AS `CLNT_TYPE_NAME`,
        MAX(`c`.`CLNT_TEAM`) AS `clnt_team`,
        MAX(`c`.`CLNT_CHRG_TYPE_NAME`) AS `CLNT_CHRG_TYPE`,
        MAX(`a`.`quota_hr`) AS `quota_HR`,
        SUM((CASE
            WHEN (`b`.`TASK_STS_CD` = 7) THEN 1
            ELSE 0
        END)) AS `ARNG_HR`,
        SUM((CASE
            WHEN (`b`.`TASK_STS_CD` = 8) THEN `b`.`CLNT_HR`
            ELSE 0
        END)) AS `CMPLT_HR`,
        SUM((CASE
            WHEN (`b`.`TASK_STS_CD` = 7) THEN 1
            WHEN (`b`.`TASK_STS_CD` = 8) THEN `b`.`CLNT_HR`
            ELSE 0
        END)) AS `TOTAL_HR`
    FROM
        ((((dw_simp.`v_prjct_task` `b`
        JOIN dw_simp.`v_clnt` `c` ON ((`b`.`CLNT_ID` = `c`.`CLNT_ID`)))
        LEFT JOIN dw_simp.`v_user` `uc` ON ((`uc`.`UID` = `c`.`CLNT_AM_UID`)))
        JOIN dw_simp.`v_clnt_cntct` `ct` ON (((`b`.`CLNT_ID` = `ct`.`CLNT_ID`)
            AND (`b`.`CLNT_CNTCT_ID` = `ct`.`CLNT_CNTCT_ID`)
            AND (`ct`.`CLNT_CNTCT_STS_CD` <> 0))))
        LEFT JOIN dw_simp.`dw_clnt_grp_quota` `a` ON (((`a`.`month_beg_dt` = CONCAT(DATE_FORMAT(IFNULL(`b`.`BEG_DT`, IFNULL(`b`.`TASK_STS_UPD_DT`, `b`.`END_DT`)), '%Y-%m-'), '01'))
            AND (`a`.`clnt_id` = `b`.`CLNT_ID`)
            AND (`a`.`clnt_grp_id` = `ct`.`CLNT_GRP_ID`))))
    WHERE
        (`c`.`CLNT_CHRG_TYPE_NAME` <> 'normal')
    GROUP BY CONCAT(DATE_FORMAT(IFNULL(`b`.`BEG_DT`,
                            IFNULL(`b`.`TASK_STS_UPD_DT`, `b`.`END_DT`)),
                    '%Y-%m-'),
            '01') , `b`.`CLNT_ID` , `ct`.`CLNT_CNTCT_ID` ;


    INSERT INTO dw_simp.km_clnt_quota1 SELECT 
        `a`.`month_beg_dt` AS `month_begin_dt`,
        `ct`.`CLNT_ID` AS `clnt_id`,
        `ct`.`CLNT_CNTCT_ID` AS `CLNT_CNTCT_ID`,
        `ct`.`CLNT_CNTCT_NAME` AS `CLNT_CNTCT_NAME`,
        `ct`.`CLNT_GRP_ID` AS `clnt_grp_id`,
        MAX(`uc`.`USER_ENG_NAME`) AS `clnt_am_name`,
        MAX(`c`.`CLNT_NAME`) AS `clnt_name`,
        MAX(`c`.`CLNT_TYPE_NAME`) AS `CLNT_TYPE_NAME`,
        MAX(`c`.`CLNT_TEAM`) AS `clnt_team`,
        MAX(`c`.`CLNT_CHRG_TYPE_NAME`) AS `CLNT_CHRG_TYPE`,
        MAX(`a`.`quota_hr`) AS `quota_HR`,
        0 AS `ARNG_HR`,
        0 AS `CMPLT_HR`,
        0 AS `TOTAL_HR`
    FROM
        (((dw_simp.`v_clnt` `c`
        LEFT JOIN dw_simp.`v_user` `uc` ON ((`uc`.`UID` = `c`.`CLNT_AM_UID`)))
        JOIN dw_simp.`v_clnt_cntct` `ct` ON (((`c`.`CLNT_ID` = `ct`.`CLNT_ID`)
            AND (`ct`.`CLNT_CNTCT_STS_CD` <> 0))))
        LEFT JOIN dw_simp.`dw_clnt_grp_quota` `a` ON (((`a`.`clnt_id` = `ct`.`CLNT_ID`)
            AND (`a`.`clnt_grp_id` = `ct`.`CLNT_GRP_ID`))))
    WHERE
        (`c`.`CLNT_CHRG_TYPE_NAME` <> 'normal')
    GROUP BY `a`.`month_beg_dt` , `ct`.`CLNT_ID` , `ct`.`CLNT_CNTCT_ID` ;

DROP TABLE IF EXISTS dw_simp.km_clnt_quota;
CREATE  TABLE dw_simp.km_clnt_quota AS 
   SELECT 
        `b`.`month_begin_dt` AS `month_begin_dt`,
        `b`.`clnt_id` AS `clnt_id`,
        `b`.`clnt_grp_id` AS `clnt_grp_id`,
        `b`.`clnt_am_name` AS `clnt_am_name`,
        `b`.`clnt_name` AS `clnt_name`,
        `b`.`CLNT_TYPE_NAME` AS `CLNT_TYPE_NAME`,
        `b`.`CLNT_CHRG_TYPE` AS `CLNT_CHRG_TYPE`,
        GROUP_CONCAT(DISTINCT `b`.`CLNT_CNTCT_NAME`
            SEPARATOR ',') AS `CLNT_CNTCT_NAME`,
        MAX(`b`.`quota_HR`) AS `quota_HR`,
        SUM(`b`.`ARNG_HR`) AS `ARNG_HR`,
        SUM(`b`.`CMPLT_HR`) AS `CMPLT_HR`,
        SUM(`b`.`TOTAL_HR`) AS `TOTAL_HR`,
        MAX(`b`.`clnt_team`) AS `clnt_team`
    FROM
        `dw_simp`.`km_clnt_quota1` `b`
    GROUP BY `b`.`month_begin_dt` , `b`.`clnt_id` , `b`.`clnt_grp_id` , 
    `b`.`clnt_am_name` , `b`.`clnt_name` , `b`.`CLNT_TYPE_NAME` , `b`.`CLNT_CHRG_TYPE`;

#alter table `dw_simp`.`v_prjct_task` add index ix_PRJCT_ID(PRJCT_ID);
#alter table `dw_simp`.`v_cnsltnt` add index ix_CNSLTNT_ID(CNSLTNT_ID);
CALL dw_simp.add_index('v_prjct_task','ix_PRJCT_ID','PRJCT_ID');
CALL dw_simp.add_index('v_cnsltnt','ix_CNSLTNT_ID','CNSLTNT_ID');

DROP TABLE IF EXISTS `dw_simp`.`rem_mf_prjct_task`;
CREATE TABLE  `dw_simp`.`rem_mf_prjct_task` AS  SELECT 
        `c`.`CLNT_NAME` AS `CLNT_NAME`,
        `am1`.`USER_ENG_NAME` AS `CLNT_AM_NAME`,
        `pm`.`USER_ENG_NAME` AS `PM_NAME`,
        `skm`.`USER_ENG_NAME` AS `SKM_NAME`,
        IFNULL(`t`.`BEG_DT`,
                IFNULL(`t`.`TASK_STS_UPD_DT`, `t`.`END_DT`)) AS `TASK_STS_UPD_DT`,
        `ct`.`CLNT_CNTCT_NAME` AS `CLNT_CNTCT_NAME`,
        `t`.`TASK_STS_NAME` AS `task_sts_name`,
        (CASE
            WHEN (`t`.`TASK_STS_CD` = 7) THEN 1
            ELSE 0
        END) AS `RCMND_HR`,
        (CASE
            WHEN (`t`.`TASK_STS_CD` = 8) THEN `t`.`CLNT_HR`
            ELSE 0
        END) AS `CMPLT_HR`,
        `cn`.`CNSLTNT_NAME` AS `cnsltnt_name`,
        `t`.`CNSLTN_TYPE_NAME` AS `cnsltn_type_name`,
        `p`.`PRJCT_CTGRY_NAME` AS `PRJCT_CTGRY_NAME`,
        `p`.`INDSTRY_NAME` AS `INDSTRY_NAME`,
        `p`.`SUBINDSTRY_NAME` AS `SUBINDSTRY_NAME`,
        `p`.`PRJCT_DSPLY_NAME` AS `PRJCT_DSPLY_NAME`,
        `cn`.`CMPNY_NAME` AS `CMPNY_NAME`
    FROM
        (((((((`dw_simp`.`v_prjct_task` `t`
        JOIN `dw_simp`.`v_prjct` `p` ON ((`t`.`PRJCT_ID` = `p`.`PRJCT_ID`)))
        JOIN `dw_simp`.`v_clnt` `c` ON ((`t`.`CLNT_ID` = `c`.`CLNT_ID`)))
        JOIN `dw_simp`.`v_clnt_cntct` `ct` ON ((`t`.`CLNT_CNTCT_ID` = `ct`.`CLNT_CNTCT_ID`)))
        LEFT JOIN `dw_simp`.`v_user` `am1` ON ((`c`.`CLNT_AM_UID` = `am1`.`UID`)))
        LEFT JOIN `dw_simp`.`v_user` `pm` ON ((`pm`.`UID` = `p`.`PRJCT_MNGR_UID`)))
        LEFT JOIN `dw_simp`.`v_user` `skm` ON ((`skm`.`UID` = `p`.`SKM_UID`)))
        LEFT JOIN `dw_simp`.`v_cnsltnt` `cn` ON ((`t`.`CNSLTNT_ID` = `cn`.`CNSLTNT_ID`)))  
    WHERE
        ((1 = 1)
            AND (`p`.`PRJCT_CTGRY_CD` IN (1 , 12))
            AND (`c`.`CLNT_CHRG_TYPE_NAME` <> 'normal')
            AND (`t`.`TASK_STS_CD` IN (7 , 8))
            AND (DATE_FORMAT(IFNULL(`t`.`BEG_DT`,
                        IFNULL(`t`.`TASK_STS_UPD_DT`, `t`.`END_DT`)),
                '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')));


   
	

END$$

DELIMITER ;