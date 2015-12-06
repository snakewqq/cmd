DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `create_view_table_proc`$$

CREATE DEFINER=`root`@`%` PROCEDURE `create_view_table_proc`()
BEGIN
  
DROP TABLE IF EXISTS dw_simp.v_user;
CREATE TABLE dw_simp.v_user AS 
 (SELECT 
        dw_simp.`dw_user`.`UID` AS `UID`,
        dw_simp.`dw_user`.`USER_CHN_NAME` AS `USER_CHN_NAME`,
        dw_simp.`dw_user`.`USER_ENG_NAME` AS `USER_ENG_NAME`,
        dw_simp.`dw_user`.`PSTN_NAME` AS `PSTN_NAME`,
        dw_simp.`dw_user`.`DEPT_NAME` AS `DEPT_NAME`,
        dw_simp.`dw_user`.`MNGR_IND` AS `MNGR_IND`,
        dw_simp.`dw_user`.`TEAM_ID` AS `TEAM_ID`,
        dw_simp.`dw_user`.`TEAM_NAME` AS `TEAM_NAME`,
        dw_simp.`dw_user`.`EXT_NUM` AS `EXT_NUM`,
        dw_simp.`dw_user`.`EMAIL_ADDR` AS `EMAIL_ADDR`,
        dw_simp.`dw_user`.`USER_ROLE_NAME` AS `USER_ROLE_NAME`,
        dw_simp.`dw_user`.`user_sts_cd` AS `user_sts_cd`
    FROM
        dw_simp.`dw_user`);  
DROP TABLE IF EXISTS  dw_simp.v_clnt;
CREATE TABLE dw_simp.v_clnt AS 
SELECT 
        `a`.`CLNT_ID` AS `CLNT_ID`,
        `a`.`CLNT_NAME` AS `CLNT_NAME`,
        `a`.`CLNT_TYPE_CD` AS `CLNT_TYPE_CD`,
        (CASE
            WHEN (`a`.`CLNT_TYPE_CD` = 1) THEN 'Consulting Firm'
            WHEN (`a`.`CLNT_TYPE_CD` = 2) THEN 'Private Equity'
            WHEN (`a`.`CLNT_TYPE_CD` = 3) THEN 'Hedge Fund'
            WHEN (`a`.`CLNT_TYPE_CD` = 4) THEN 'Venture Capital'
            WHEN (`a`.`CLNT_TYPE_CD` = 5) THEN 'Mutual Fund'
            WHEN (`a`.`CLNT_TYPE_CD` = 6) THEN 'Corporate'
            WHEN (`a`.`CLNT_TYPE_CD` = 7) THEN 'Financial Firm'
            WHEN (`a`.`CLNT_TYPE_CD` = 8) THEN 'Others'
            ELSE NULL
        END) AS `CLNT_TYPE_NAME`,
        `a`.`CLNT_SIZE_BKT_CD` AS `CLNT_SIZE_BKT_CD`,
        (CASE
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 1) THEN '1-49'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 2) THEN '50-99'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 3) THEN '100-499'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 4) THEN '500-999'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 5) THEN '1000-2000'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 6) THEN '2000-5000'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 7) THEN '5000-10000'
            WHEN (`a`.`CLNT_SIZE_BKT_CD` = 8) THEN '10000以上'
            ELSE NULL
        END) AS `CLNT_SIZE_BKT_NAME`,
        `a`.`CNTRY_ID` AS `CNTRY_ID`,
        `a`.`CNTRY_NAME` AS `CNTRY_NAME`,
        `a`.`PRVNC_STATE_ID` AS `PRVNC_STATE_ID`,
        `a`.`PRVNC_STATE_NAME` AS `PRVNC_STATE_NAME`,
        `a`.`CITY_ID` AS `CITY_ID`,
        `a`.`CITY_NAME` AS `CITY_NAME`,
        `a`.`CLNT_AM_PCT` AS `CLNT_AM_PCT`,
        `a`.`CLNT_AM_UID` AS `CLNT_AM_UID`,
        `a`.`CLNT_AM2_PCT` AS `CLNT_AM2_PCT`,
        `a`.`CLNT_AM2_UID` AS `CLNT_AM2_UID`,
        `a`.`CLNT_AM3_PCT` AS `CLNT_AM3_PCT`,
        `a`.`CLNT_AM3_UID` AS `CLNT_AM3_UID`,
        `a`.`CLNT_AM4_PCT` AS `CLNT_AM4_PCT`,
        `a`.`CLNT_AM4_UID` AS `CLNT_AM4_UID`,
        `a`.`CLNT_STS_CD` AS `CLNT_STS_CD`,
        (CASE
            WHEN (`a`.`CLNT_STS_CD` = 1) THEN 'Prospect'
            WHEN (`a`.`CLNT_STS_CD` = 2) THEN 'Engage'
            WHEN (`a`.`CLNT_STS_CD` = 3) THEN 'Discover'
            WHEN (`a`.`CLNT_STS_CD` = 4) THEN 'Trial'
            WHEN (`a`.`CLNT_STS_CD` = 5) THEN 'Confirm'
            WHEN (`a`.`CLNT_STS_CD` = 7) THEN 'Annual'
            WHEN (`a`.`CLNT_STS_CD` = 8) THEN 'Project'
            WHEN (`a`.`CLNT_STS_CD` = 9) THEN 'close'
            ELSE NULL
        END) AS `CLNT_STS_NAME`,
        `a`.`CLNT_STS_NOTE` AS `CLNT_STS_NOTE`,
        `a`.`CLNT_ALERT_NOTE` AS `CLNT_ALERT_NOTE`,
        `a`.`USER_CRE_UID` AS `USER_CRE_UID`,
        `cre`.`USER_ENG_NAME` AS `CREATOR_NAME`,
        `cre`.`USER_ROLE_NAME` AS `CREATOR_ROLE`,
        `cre`.`TEAM_NAME` AS `CREATOR_TEAM`,
        `am2`.`USER_ENG_NAME` AS `CLNT_AM2_NAME`,
        `am2`.`TEAM_NAME` AS `CLNT_AM2_TEAM`,
        `am3`.`USER_ENG_NAME` AS `CLNT_AM3_NAME`,
        `am3`.`TEAM_NAME` AS `CLNT_AM3_TEAM`,
        `am4`.`USER_ENG_NAME` AS `CLNT_AM4_NAME`,
        `am4`.`TEAM_NAME` AS `CLNT_AM4_TEAM`,
        `am`.`USER_ENG_NAME` AS `CLNT_AM_NAME`,
        `am`.`TEAM_NAME` AS `CLNT_AM_TEAM`,
        `a`.`CRE_DT` AS `CRE_DT`,
        `a`.`CLNT_TEAM` AS `CLNT_TEAM`,
        (CASE
            WHEN (`a`.`CLNT_CHRG_TYPE_CD` = 1) THEN '打分'
            WHEN (`a`.`CLNT_CHRG_TYPE_CD` = 2) THEN '包年'
            WHEN (`a`.`CLNT_CHRG_TYPE_CD` = 3) THEN 'normal'
            ELSE NULL
        END) AS `CLNT_CHRG_TYPE_NAME`,
        (CASE
            WHEN (`a`.`CLNT_TEAM` = 'International') THEN 'INTL'
            WHEN (`a`.`CLNT_TEAM` = 'Other') THEN 'OTHERS'
            WHEN (`a`.`CLNT_TEAM` = 'GES') THEN 'CORP'
            WHEN (`a`.`CLNT_TEAM` = 'Domestic') THEN 'DOM'
            WHEN (`a`.`CLNT_TEAM` = 'HRS') THEN 'HR'
            WHEN (`a`.`CLNT_TEAM` = 'Global') THEN 'GLO'
            WHEN
                ((`a`.`CLNT_TEAM` = 'PE/C')
                    AND (`a`.`CLNT_TYPE_CD` = 1))
            THEN
                'CONS'
            WHEN
                ((`a`.`CLNT_TEAM` = 'PE/C')
                    AND (IFNULL(`a`.`CLNT_TYPE_CD`, 0) <> 1))
            THEN
                'PE'
            ELSE NULL
        END) AS `FNC_CLNT_TEAM`,
        (CASE
            WHEN (`a`.`CLNT_TYPE_CD` IN (2 , 4)) THEN 'PE/VC'
            WHEN (`a`.`CLNT_TYPE_CD` = 1) THEN 'Consulting Firm'
            WHEN (`a`.`CLNT_TYPE_CD` = 3) THEN 'Hedge Fund'
            WHEN (`a`.`CLNT_TYPE_CD` = 5) THEN 'Mutual Fund'
            ELSE 'Others'
        END) AS `Stone_CLNT_TYPE`
    FROM
        dw_simp.`dw_clnt` `a`
        LEFT JOIN dw_simp.`v_user` `cre` ON `cre`.`UID` = `a`.`USER_CRE_UID`
        LEFT JOIN dw_simp.`v_user` `am` ON `a`.`CLNT_AM_UID` = `am`.`UID`
        LEFT JOIN dw_simp.`v_user` `am2` ON `a`.`CLNT_AM2_UID` = `am2`.`UID`
        LEFT JOIN dw_simp.`v_user` `am3` ON `a`.`CLNT_AM3_UID` = `am3`.`UID`
        LEFT JOIN dw_simp.`v_user` `am4` ON `a`.`CLNT_AM4_UID` = `am4`.`UID`;
DROP TABLE IF EXISTS dw_simp.v_clnt_cntct;
CREATE TABLE dw_simp.v_clnt_cntct AS 
   (SELECT 
        `a`.`CLNT_CNTCT_ID` AS `CLNT_CNTCT_ID`,
        `a`.`CLNT_CNTCT_NAME` AS `CLNT_CNTCT_NAME`,
        `a`.`CLNT_ID` AS `CLNT_ID`,
        `a`.`PSTN_NAME` AS `PSTN_NAME`,
        `a`.`CNTRY_ID` AS `CNTRY_ID`,
        `a`.`CNTRY_NAME` AS `CNTRY_NAME`,
        `a`.`PRVNC_STATE_ID` AS `PRVNC_STATE_ID`,
        `a`.`PRVNC_STATE_NAME` AS `PRVNC_STATE_NAME`,
        `a`.`CITY_ID` AS `CITY_ID`,
        `a`.`CITY_NAME` AS `CITY_NAME`,
        `a`.`NPS_CD` AS `NPS_CD`,
        (CASE
            WHEN (`a`.`NPS_CD` = 1) THEN 'promoter'
            WHEN (`a`.`NPS_CD` = 2) THEN 'neutral'
            WHEN (`a`.`NPS_CD` = 3) THEN 'detractor'
            ELSE NULL
        END) AS `NPS_NAME`,
        `a`.`ROLE_CD` AS `ROLE_CD`,
        (CASE
            WHEN (`a`.`ROLE_CD` = 1) THEN 'normal user'
            WHEN (`a`.`ROLE_CD` = 2) THEN 'legal user'
            ELSE NULL
        END) AS `ROLE_NAME`,
        `a`.`MAIN_CNTCT_IND` AS `MAIN_CNTCT_IND`,
        `a`.`CLNT_CNTCT_STS_CD` AS `CLNT_CNTCT_STS_CD`,
        (CASE
            WHEN (`a`.`CLNT_CNTCT_STS_CD` = 0) THEN 'inactive'
            WHEN (`a`.`CLNT_CNTCT_STS_CD` = 1) THEN 'active'
            WHEN (`a`.`CLNT_CNTCT_STS_CD` = 2) THEN 'transfer'
            ELSE NULL
        END) AS `CLNT_CNTCT_STS_NAME`,
        `a`.`CPWEB_RGSTR_STS_CD` AS `CPWEB_RGSTR_STS_CD`,
        (CASE
            WHEN (`a`.`CPWEB_RGSTR_STS_CD` = 1) THEN 'unsent'
            WHEN (`a`.`CPWEB_RGSTR_STS_CD` = 2) THEN 'sent'
            WHEN (`a`.`CPWEB_RGSTR_STS_CD` = 3) THEN 'registered'
            ELSE NULL
        END) AS `CPWEB_RGSTR_STS_NAME`,
        `a`.`WANT_INVTN_IND` AS `WANT_INVTN_IND`,
        `a`.`WANT_INVTN_TYPE_CD` AS `WANT_INVTN_TYPE_CD`,
        (CASE
            WHEN (`a`.`WANT_INVTN_TYPE_CD` = 1) THEN 'multiple'
            WHEN (`a`.`WANT_INVTN_TYPE_CD` = 2) THEN 'single'
            ELSE NULL
        END) AS `WANT_INVTN_TYPE_NAME`,
        `a`.`CLNT_GRP_ID` AS `CLNT_GRP_ID`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`USER_CRE_TS`)
        END) AS `USER_CRE_TS`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`USER_CRE_TS`) AS DATE)
        END) AS `USER_CRE_DT`,
        `a`.`REM_UID` AS `REM_UID`,
        `rem`.`USER_ENG_NAME` AS `rem_name`,
        `rem`.`USER_ROLE_NAME` AS `rem_role`,
        `rem`.`TEAM_NAME` AS `rem_team`
    FROM
        (dw_simp.`dw_clnt_cntct` `a`
        LEFT JOIN dw_simp.`v_user` `rem` ON ((`rem`.`UID` = `a`.`REM_UID`)))) ;
DROP TABLE IF EXISTS dw_simp.v_clnt_grp_quota;
CREATE TABLE dw_simp.v_clnt_grp_quota AS 
SELECT 
        dw_simp.`dw_clnt_grp_quota`.`month_beg_dt` AS `month_beg_dt`,
        dw_simp.`dw_clnt_grp_quota`.`clnt_id` AS `clnt_id`,
        dw_simp.`dw_clnt_grp_quota`.`clnt_grp_id` AS `clnt_grp_id`,
        dw_simp.`dw_clnt_grp_quota`.`quota_hr` AS `quota_hr`
    FROM
        dw_simp.`dw_clnt_grp_quota`;
DROP TABLE IF EXISTS dw_simp.v_clnt_quota;
CREATE TABLE dw_simp.v_clnt_quota AS 
SELECT 
        dw_simp.`dw_clnt_quota`.`month_beg_dt` AS `month_beg_dt`,
        dw_simp.`dw_clnt_quota`.`clnt_id` AS `clnt_id`,
        dw_simp.`dw_clnt_quota`.`quota_hr` AS `quota_hr`
    FROM
        dw_simp.`dw_clnt_quota` ;
DROP TABLE IF EXISTS dw_simp.v_location;
CREATE TABLE dw_simp.v_location AS 
  SELECT 
        ndb.`ndb_location`.`id` AS `id`,
        ndb.`ndb_location`.`name` AS `name`,
        ndb.`ndb_location`.`shortname` AS `shortname`,
        ndb.`ndb_location`.`parentid` AS `parentid`,
        ndb.`ndb_location`.`level` AS `level`,
        ndb.`ndb_location`.`path` AS `path`,
        ndb.`ndb_location`.`areacode` AS `areacode`,
        ndb.`ndb_location`.`CRE_DT` AS `CRE_DT`,
        ndb.`ndb_location`.`CRE_UID` AS `CRE_UID`,
        ndb.`ndb_location`.`UPD_TS` AS `UPD_TS`,
        ndb.`ndb_location`.`UPD_UID` AS `UPD_UID`
    FROM
        ndb.`ndb_location`
    WHERE
        (ndb.`ndb_location`.`name` NOT IN ('Canada' , 'Kazakhstan',
            'Réunion',
            'Saint Martin (French part)',
            'Saint Barthélemy'));
#alter table dw_simp.v_location add index ix_areacode_level (`areacode`,`level`);
#alter table dw_simp.dw_cnsltnt add index ix_dw_cnsltnt_USER_CRE_UID (USER_CRE_UID);
#alter table dw_simp.`v_user`  add index ix_UID(UID);
CALL dw_simp.add_index('v_location','ix_areacode_level','`areacode`,`level`');
CALL dw_simp.add_index('dw_cnsltnt','ix_dw_cnsltnt_USER_CRE_UID','USER_CRE_UID');
CALL dw_simp.add_index('v_user','ix_UID','UID');
DROP TABLE IF EXISTS dw_simp.v_cnsltnt;
CREATE TABLE dw_simp.v_cnsltnt AS 
 (SELECT 
        `a`.`CNSLTNT_ID` AS `CNSLTNT_ID`,
        `a`.`CNSLTNT_NAME` AS `CNSLTNT_NAME`,
        `a`.`CNSLTNT_STS_CD` AS `CNSLTNT_STS_CD`,
        (CASE
            WHEN (`a`.`CNSLTNT_STS_CD` = 1) THEN 'Enrolled'
            WHEN (`a`.`CNSLTNT_STS_CD` = 2) THEN 'Communicated'
            WHEN (`a`.`CNSLTNT_STS_CD` = 3) THEN 'Not Contacted'
            WHEN (`a`.`CNSLTNT_STS_CD` = 4) THEN 'Prospect'
            WHEN (`a`.`CNSLTNT_STS_CD` = 5) THEN 'Invalid'
            WHEN (`a`.`CNSLTNT_STS_CD` = 6) THEN 'Blacklist'
            ELSE NULL
        END) AS `CNSLTNT_STS_NAME`,
        (CASE
            WHEN (IFNULL(`a`.`CNTRY_ID`, 0) <> 0) THEN `a`.`CNTRY_ID`
            WHEN
                ((IFNULL(`a`.`CNTRY_ID`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_MBL_CNTRY_CODE`, 0) <> 0))
            THEN
                `n1`.`id`
            WHEN
                ((IFNULL(`a`.`CNTRY_ID`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_MBL_CNTRY_CODE`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_TLPHN_CNTRY_CODE`, 0) <> 0))
            THEN
                `n2`.`id`
            ELSE NULL
        END) AS `CNTRY_ID`,
        (CASE
            WHEN (IFNULL(`a`.`CNTRY_ID`, 0) <> 0) THEN `a`.`CNTRY_NAME`
            WHEN
                ((IFNULL(`a`.`CNTRY_ID`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_MBL_CNTRY_CODE`, 0) <> 0))
            THEN
                `n1`.`name`
            WHEN
                ((IFNULL(`a`.`CNTRY_ID`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_MBL_CNTRY_CODE`, 0) = 0)
                    AND (IFNULL(`a`.`CNSLTNT_TLPHN_CNTRY_CODE`, 0) <> 0))
            THEN
                `n2`.`name`
            ELSE NULL
        END) AS `CNTRY_NAME`,
        `a`.`PRVNC_STATE_ID` AS `PRVNC_STATE_ID`,
        `a`.`PRVNC_STATE_NAME` AS `PRVNC_STATE_NAME`,
        `a`.`CITY_ID` AS `CITY_ID`,
        `a`.`CITY_NAME` AS `CITY_NAME`,
        `a`.`CNSLTNT_TYPE_CD` AS `CNSLTNT_TYPE_CD`,
        (CASE
            WHEN (`a`.`CNSLTNT_TYPE_CD` = 2) THEN 'Qualified'
            WHEN (`a`.`CNSLTNT_TYPE_CD` = 3) THEN 'Non-qualified'
            WHEN (`a`.`CNSLTNT_TYPE_CD` = 4) THEN 'Capvision Elite'
            WHEN (`a`.`CNSLTNT_TYPE_CD` = 5) THEN 'Capvision Elite Plus'
            ELSE NULL
        END) AS `CNSLTNT_TYPE_NAME`,
        `a`.`ORGN_CHNL_CD` AS `ORGN_CHNL_CD`,
        (CASE
            WHEN (`a`.`ORGN_CHNL_CD` = 0) THEN 'Legacy'
            WHEN (`a`.`ORGN_CHNL_CD` = 1) THEN 'Consultant Referral'
            WHEN (`a`.`ORGN_CHNL_CD` = 2) THEN 'Internal Referral'
            WHEN (`a`.`ORGN_CHNL_CD` = 3) THEN 'Internet Search'
            WHEN (`a`.`ORGN_CHNL_CD` = 4) THEN 'Events'
            WHEN (`a`.`ORGN_CHNL_CD` = 5) THEN 'Organization'
            WHEN (`a`.`ORGN_CHNL_CD` = 6) THEN 'Database'
            WHEN (`a`.`ORGN_CHNL_CD` = 7) THEN 'Other'
            WHEN (`a`.`ORGN_CHNL_CD` = 8) THEN 'Galaxy'
            ELSE NULL
        END) AS `ORGN_CHNL_NAME`,
        `a`.`ORGN_CHNL_DTL_NAME` AS `ORGN_CHNL_DTL_NAME`,
        `a`.`RFRL_CNSLTNT_ID` AS `RFRL_CNSLTNT_ID`,
        `a`.`RFRL_UID` AS `RFRL_UID`,
        `a`.`PSTN_ID` AS `PSTN_ID`,
        `a`.`PSTN_NAME` AS `PSTN_NAME`,
        `a`.`CMPNY_ID` AS `CMPNY_ID`,
        `a`.`CMPNY_NAME` AS `CMPNY_NAME`,
        `a`.`INDSTRY_ID` AS `INDSTRY_ID`,
        `a`.`INDSTRY_NAME` AS `INDSTRY_NAME`,
        `a`.`SUBINDSTRY_ID` AS `SUBINDSTRY_ID`,
        `a`.`SUBINDSTRY_NAME` AS `SUBINDSTRY_NAME`,
        `a`.`FNCTN_ID` AS `FNCTN_ID`,
        `a`.`FNCTN_NAME` AS `FNCTN_NAME`,
        `a`.`BCKGRND_CHN_TXT` AS `BCKGRND_CHN_TXT`,
        `a`.`EXPRTS_CHN_TXT` AS `EXPRTS_CHN_TXT`,
        `a`.`BCKGRND_ENG_TXT` AS `BCKGRND_ENG_TXT`,
        `a`.`EXPRTS_ENG_TXT` AS `EXPRTS_ENG_TXT`,
        `a`.`VALID_EMAIL_IND` AS `VALID_EMAIL_IND`,
        `a`.`VALID_TEL_IND` AS `VALID_TEL_IND`,
        `a`.`VALID_MBL_IND` AS `VALID_MBL_IND`,
        `a`.`KSH_MBR_IND` AS `KSH_MBR_IND`,
        (CASE
            WHEN (`a`.`FEE_RATE_CRNCY_CD` IN (0 , 637)) THEN CAST(`a`.`FEE_RATE_LC_AMT` AS DECIMAL (18 , 2 ))
            WHEN (`a`.`FEE_RATE_CRNCY_CD` = 638) THEN CAST((`a`.`FEE_RATE_LC_AMT` * 6.2) AS DECIMAL (18 , 2 ))
            WHEN (`a`.`FEE_RATE_CRNCY_CD` = 639) THEN CAST((`a`.`FEE_RATE_LC_AMT` * 8) AS DECIMAL (18 , 2 ))
            WHEN (`a`.`FEE_RATE_CRNCY_CD` = 640) THEN CAST((`a`.`FEE_RATE_LC_AMT` * 10) AS DECIMAL (18 , 2 ))
            WHEN (`a`.`FEE_RATE_CRNCY_CD` = 641) THEN CAST((`a`.`FEE_RATE_LC_AMT` * 4) AS DECIMAL (18 , 2 ))
            WHEN (`a`.`FEE_RATE_CRNCY_CD` = 642) THEN CAST((`a`.`FEE_RATE_LC_AMT` * 1.2) AS DECIMAL (18 , 2 ))
            ELSE 0
        END) AS `CNSLTNT_FEE_RATE_CNY_AMT`,
        (CASE
            WHEN (`a`.`KSH_RGSTR_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`KSH_RGSTR_TS`)
        END) AS `KSH_RGSTR_TS`,
        (CASE
            WHEN (`a`.`KSH_RGSTR_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`KSH_RGSTR_TS`) AS DATE)
        END) AS `KSH_RGSTR_DT`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`USER_CRE_TS`)
        END) AS `USER_CRE_TS`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`USER_CRE_TS`) AS DATE)
        END) AS `USER_CRE_DT`,
        `a`.`USER_CRE_UID` AS `USER_CRE_UID`,
        `cre`.`USER_ENG_NAME` AS `CREATOR_NAME`,
        `cre`.`USER_ROLE_NAME` AS `CREATOR_ROLE`,
        `cre`.`TEAM_NAME` AS `CREATOR_TEAM`,
        `rfrl`.`USER_ENG_NAME` AS `REFERRAL_USER_NAME`,
        `rfrl`.`USER_ROLE_NAME` AS `REFERRAL_USER_ROLE`,
        `rfrl`.`TEAM_NAME` AS `REFERRAL_USER_TEAM`,
        (CASE
            WHEN (`a`.`INDSTRY_ID` IN (1 , 26, 31)) THEN '快消零售 - FMCG'
            WHEN (`a`.`INDSTRY_ID` = 21) THEN '医疗卫生 - Heathcare'
            WHEN (`a`.`INDSTRY_ID` = 54) THEN '汽车交通运输 - TMT'
            WHEN (`a`.`INDSTRY_ID` = 94) THEN '通讯网络技术 - Transportation'
            WHEN (`a`.`INDSTRY_ID` IN (90 , 81, 9, 78, 46, 84, 14, 73)) THEN '宏观 - Others'
            ELSE NULL
        END) AS `NWSLTR_INDSTRY_NAME`,
        `a`.`RESUMEBOX_IND` AS `RESUMEBOX_IND`,
        `a`.`RESUME_ATTACH_IND` AS `RESUME_ATTACH_IND`,
        `a`.`CRDT_CNT` AS `CRDT_CNT`,
        `a`.`CRDT_SPNT` AS `CRDT_SPNT`,
        `a`.`CRDT_ERN` AS `CRDT_ERN`,
        (CASE
            WHEN (`a`.`LAST_CNTCT_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`LAST_CNTCT_TS`)
        END) AS `LAST_CNTCT_TS`,
        (CASE
            WHEN (`a`.`LAST_CNTCT_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`LAST_CNTCT_TS`) AS DATE)
        END) AS `LAST_CNTCT_DT`,
        (CASE
            WHEN
                (`a`.`CNTRY_ID` IN (1 , 4,
                    22,
                    24,
                    25,
                    29,
                    31,
                    32,
                    35,
                    36,
                    40,
                    43,
                    49,
                    56,
                    964,
                    965,
                    966,
                    967,
                    968,
                    970,
                    977))
            THEN
                'Asia-Pacific'
            WHEN
                ((`a`.`PRVNC_STATE_ID` IN (22 , 947, 35, 56))
                    OR (`a`.`CITY_ID` IN (22 , 947, 35, 56)))
            THEN
                'Asia-Pacific'
            WHEN (`a`.`CNTRY_ID` = 12) THEN 'china'
            ELSE 'Global'
        END) AS `REGION_NAME`,
        `a`.`CNSLTNT_MBL_CNTRY_CODE` AS `CNSLTNT_MBL_CNTRY_CODE`,
        `a`.`CNSLTNT_TLPHN_CNTRY_CODE` AS `CNSLTNT_TLPHN_CNTRY_CODE`
    FROM
        ((((dw_simp.`dw_cnsltnt` `a`
        LEFT JOIN dw_simp.`v_user` `cre` ON ((`cre`.`UID` = `a`.`USER_CRE_UID`)))
        LEFT JOIN dw_simp.`v_user` `rfrl` ON ((`rfrl`.`UID` = `a`.`RFRL_UID`)))
        LEFT JOIN dw_simp.`v_location` `n1` ON (((`n1`.`areacode` = `a`.`CNSLTNT_MBL_CNTRY_CODE`)
            AND (`n1`.`areacode` <> 0)
            AND (`n1`.`level` = 1))))
        LEFT JOIN dw_simp.`v_location` `n2` ON (((`n2`.`areacode` = `a`.`CNSLTNT_TLPHN_CNTRY_CODE`)
            AND (`n2`.`areacode` <> 0)
            AND (`n2`.`level` = 1))))) ;
	
DROP TABLE IF EXISTS dw_simp.v_cnsltnt_work_exprnce;
CREATE TABLE dw_simp.v_cnsltnt_work_exprnce AS 
  SELECT 
        `cp`.`id` AS `id`,
        `cp`.`consultantid` AS `Cnsltnt_id`,
        `pv`.`name` AS `Pstn_name`,
        `cp`.`position` AS `Pstn_id`,
        `cv`.`name` AS `Cmpny_name`,
        `cp`.`company` AS `Cmpny_id`,
        `cp`.`startdate_string` AS `Beg_dt`,
        `cp`.`enddate_string` AS `End_dt`,
        `cp`.`iscurrent` AS `Iscurrent`,
        `ntt`.`name` AS `Fnct_name`,
        `cp`.`position_hist` AS `Pstn_hst`
    FROM
        ((((ndb.`ndb_consultant_position` `cp`
        LEFT JOIN ndb.`ndb_position_vocabulary` `pv` ON ((`pv`.`id` = `cp`.`position`)))
        LEFT JOIN ndb.`ndb_company_vocabulary` `cv` ON ((`cv`.`id` = `cp`.`company`)))
        LEFT JOIN ndb.`ndb_consultant_position_function` `cpf` ON ((`cpf`.`positionid` = `cp`.`id`)))
        LEFT JOIN ndb.`ndb_taxonomy_term` `ntt` ON (((`ntt`.`id` = `cpf`.`functionid`)
            AND (`ntt`.`taxonomyid` = 5)))) ;
#alter table dw_simp.`dw_prjct` add index ix_USER_CRE_UID(USER_CRE_UID);
#alter table dw_simp.`dw_prjct` add index ix_AM_UID(AM_UID);
#alter table dw_simp.`dw_prjct` add index ix_PRJCT_MNGR_UID(PRJCT_MNGR_UID);
#alter table dw_simp.`dw_prjct` add index ix_SKM_UID(SKM_UID);
CALL dw_simp.add_index('dw_prjct','ix_USER_CRE_UID','USER_CRE_UID');
CALL dw_simp.add_index('dw_prjct','ix_AM_UID','AM_UID');
CALL dw_simp.add_index('dw_prjct','ix_PRJCT_MNGR_UID','PRJCT_MNGR_UID');
CALL dw_simp.add_index('dw_prjct','ix_SKM_UID','SKM_UID');
DROP TABLE IF EXISTS dw_simp.v_prjct;
CREATE TABLE dw_simp.v_prjct AS 
 (SELECT 
        `a`.`PRJCT_ID` AS `PRJCT_ID`,
        `a`.`PRJCT_NAME` AS `PRJCT_NAME`,
        `a`.`PRJCT_DSPLY_NAME` AS `PRJCT_DSPLY_NAME`,
        `a`.`PRJCT_DESC` AS `PRJCT_DESC`,
        `a`.`PRJCT_CLNT_CASE_CD` AS `PRJCT_CLNT_CASE_CD`,
        `a`.`PRJCT_CTGRY_CD` AS `PRJCT_CTGRY_CD`,
        (CASE
            WHEN (`a`.`PRJCT_CTGRY_CD` = 1) THEN 'Consultation'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 2) THEN 'Capvision Data Services'
            WHEN (`a`.`PRJCT_CTGRY_CD` IN (6 , 7, 13, 14)) THEN 'GES Convey TM'
            WHEN (`a`.`PRJCT_CTGRY_CD` IN (8 , 9, 10, 11)) THEN 'Conference'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 5) THEN 'Hr Service'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 12) THEN 'International Consultation'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 16) THEN 'Asia Pacific Consultation'
            ELSE NULL
        END) AS `PRJCT_CTGRY_NAME`,
        (CASE
            WHEN (`a`.`PRJCT_CTGRY_CD` = 6) THEN 'Capvision Survey'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 7) THEN 'Investigative Due Diligence'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 8) THEN 'Newstalk'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 9) THEN 'Tele60'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 10) THEN 'Capvision Live'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 11) THEN 'Events'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 13) THEN 'GES Consultation'
            WHEN (`a`.`PRJCT_CTGRY_CD` = 14) THEN 'GES Data'
            ELSE NULL
        END) AS `PRJCT_SUBCTGRY_NAME`,
        `a`.`INDSTRY_ID` AS `INDSTRY_ID`,
        `a`.`INDSTRY_NAME` AS `INDSTRY_NAME`,
        `a`.`SUBINDSTRY_ID` AS `SUBINDSTRY_ID`,
        `a`.`SUBINDSTRY_NAME` AS `SUBINDSTRY_NAME`,
        (CASE
            WHEN (`a`.`BEG_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`BEG_TS`)
        END) AS `BEG_TS`,
        (CASE
            WHEN (`a`.`BEG_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`BEG_TS`) AS DATE)
        END) AS `BEG_DT`,
        (CASE
            WHEN (`a`.`END_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`END_TS`)
        END) AS `END_TS`,
        (CASE
            WHEN (`a`.`END_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`END_TS`) AS DATE)
        END) AS `END_DT`,
        `a`.`PRJCT_STS_CD` AS `PRJCT_STS_CD`,
        (CASE
            WHEN (`a`.`PRJCT_STS_CD` = 1) THEN 'In Process'
            WHEN (`a`.`PRJCT_STS_CD` = 2) THEN 'On Hold'
            WHEN (`a`.`PRJCT_STS_CD` = 3) THEN 'Complete'
            WHEN (`a`.`PRJCT_STS_CD` = 4) THEN 'Invalid'
            WHEN (`a`.`PRJCT_STS_CD` = 5) THEN 'Deleted'
            ELSE NULL
        END) AS `PRJCT_STS_NAME`,
        (CASE
            WHEN (`a`.`PRJCT_STS_UPD_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`PRJCT_STS_UPD_TS`)
        END) AS `PRJCT_STS_UPD_TS`,
        (CASE
            WHEN (`a`.`PRJCT_STS_UPD_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`PRJCT_STS_UPD_TS`) AS DATE)
        END) AS `PRJCT_STS_UPD_DT`,
        `a`.`PRJCT_KEYQSTN_TXT` AS `PRJCT_KEYQSTN_TXT`,
        `a`.`RQST_CNSLTNT_CNT` AS `RQST_CNSLTNT_CNT`,
        `a`.`EXPCT_CNSLTNT_CNT` AS `EXPCT_CNSLTNT_CNT`,
        `a`.`RCMND_TASK_CNT` AS `RCMND_TASK_CNT`,
        `a`.`ARNG_TASK_CNT` AS `ARNG_TASK_CNT`,
        `a`.`CMPLT_TASK_CNT` AS `CMPLT_TASK_CNT`,
        `a`.`RCMND_CNSLTNT_CNT` AS `RCMND_CNSLTNT_CNT`,
        `a`.`ARNG_CNSLTNT_CNT` AS `ARNG_CNSLTNT_CNT`,
        `a`.`CMPLT_CNSLTNT_CNT` AS `CMPLT_CNSLTNT_CNT`,
        `a`.`CNSLTNT_HR` AS `CNSLTNT_HR`,
        `a`.`PRJCT_QLTY_CD` AS `PRJCT_QLTY_CD`,
        (CASE
            WHEN (`a`.`PRJCT_QLTY_CD` = 1) THEN 'No Help'
            WHEN (`a`.`PRJCT_QLTY_CD` = 2) THEN 'Helps A Little'
            WHEN (`a`.`PRJCT_QLTY_CD` = 3) THEN 'Slightly Helpful'
            WHEN (`a`.`PRJCT_QLTY_CD` = 4) THEN 'Helpful'
            WHEN (`a`.`PRJCT_QLTY_CD` = 5) THEN 'Very Helpful'
            ELSE NULL
        END) AS `PRJCT_QLTY_NAME`,
        `a`.`PRJCT_WLNG_IND` AS `PRJCT_WLNG_IND`,
        `a`.`PRJCT_NOTE` AS `PRJCT_NOTE`,
        `a`.`CNSLTN_CLNT_ID` AS `CNSLTN_CLNT_ID`,
        `a`.`CNSLTN_CLNT_CNTCT_ID` AS `CNSLTN_CLNT_CNTCT_ID`,
        `a`.`CNSLTN_CLNT_CNTCT_MNGR_ID` AS `CNSLTN_CLNT_CNTCT_MNGR_ID`,
        `a`.`AM_UID` AS `AM_UID`,
        `a`.`PRJCT_MNGR_UID` AS `PRJCT_MNGR_UID`,
        `a`.`SKM_UID` AS `SKM_UID`,
        `a`.`ON_HOLD_DAY` AS `ON_HOLD_DAY`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`USER_CRE_TS`)
        END) AS `USER_CRE_TS`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`USER_CRE_TS`) AS DATE)
        END) AS `USER_CRE_DT`,
        `a`.`USER_CRE_UID` AS `USER_CRE_UID`,
        `cre`.`USER_ENG_NAME` AS `CREATOR_NAME`,
        `cre`.`USER_ROLE_NAME` AS `CREATOR_ROLE`,
        `cre`.`TEAM_NAME` AS `CREATOR_TEAM`,
        `am`.`USER_ENG_NAME` AS `PRJCT_AM_NAME`,
        `am`.`TEAM_NAME` AS `PRJCT_AM_TEAM`,
        `pm`.`USER_ENG_NAME` AS `PM_NAME`,
        `pm`.`TEAM_NAME` AS `PM_TEAM`,
        `skm`.`USER_ENG_NAME` AS `SKM_NAME`,
        `skm`.`TEAM_NAME` AS `SKM_TEAM`
    FROM
        ((((dw_simp.`dw_prjct` `a`
        LEFT JOIN dw_simp.`v_user` `cre` ON ((`cre`.`UID` = `a`.`USER_CRE_UID`)))
        LEFT JOIN dw_simp.`v_user` `am` ON ((`am`.`UID` = `a`.`AM_UID`)))
        LEFT JOIN dw_simp.`v_user` `pm` ON ((`pm`.`UID` = `a`.`PRJCT_MNGR_UID`)))
        LEFT JOIN dw_simp.`v_user` `skm` ON ((`skm`.`UID` = `a`.`SKM_UID`)))) ;
DROP TABLE IF EXISTS dw_simp.v_task_industry;
CREATE TABLE dw_simp.v_task_industry AS 
  SELECT 
        `ntt`.`id` AS `level1_id`,
        `ntt`.`name` AS `level1_name`,
        `ntt1`.`id` AS `level2_id`,
        `ntt1`.`name` AS `level2_name`,
        `ntt2`.`id` AS `level3_id`,
        `ntt2`.`name` AS `level3_name`
    FROM
        ((ndb.`ndb_taxonomy_term` `ntt`
        LEFT JOIN ndb.`ndb_taxonomy_term` `ntt1` ON ((`ntt`.`parentid` = `ntt1`.`id`)))
        LEFT JOIN ndb.`ndb_taxonomy_term` `ntt2` ON ((`ntt2`.`id` = `ntt1`.`parentid`)))
    WHERE
        (`ntt`.`taxonomyid` = 1) ;
#alter table dw_simp.`dw_prjct_task`  add index ix_task_indstry_id(TASK_INDSTRY_ID);
#alter table dw_simp.`v_task_industry`  add index ix_level1_id(level1_id);
CALL dw_simp.add_index('dw_prjct_task','ix_task_indstry_id','TASK_INDSTRY_ID');
CALL dw_simp.add_index('v_task_industry','ix_level1_id','level1_id');
DROP TABLE  IF EXISTS dw_simp.v_prjct_task;
CREATE TABLE dw_simp.v_prjct_task AS 
(SELECT 
        `a`.`TASK_ID` AS `TASK_ID`,
        `a`.`PRJCT_ID` AS `PRJCT_ID`,
        `a`.`TASK_STS_CD` AS `TASK_STS_CD`,
        (CASE
            WHEN (`a`.`TASK_STS_CD` = 1) THEN 'Not Contacted'
            WHEN (`a`.`TASK_STS_CD` = 0) THEN 'deleted'
            WHEN (`a`.`TASK_STS_CD` = 6) THEN 'Recommended'
            WHEN (`a`.`TASK_STS_CD` = 7) THEN 'Arranged'
            WHEN (`a`.`TASK_STS_CD` = 8) THEN 'Completed'
            WHEN (`a`.`TASK_STS_CD` = 9) THEN 'Not interviewed'
            WHEN (`a`.`TASK_STS_CD` = 10) THEN 'Unsuccessful interview'
            WHEN (`a`.`TASK_STS_CD` = 11) THEN 'not selected'
            WHEN (`a`.`TASK_STS_CD` = 12) THEN '10mins test'
            WHEN (`a`.`TASK_STS_CD` = 13) THEN 'Client canceled'
            WHEN (`a`.`TASK_STS_CD` = 14) THEN 'consultant canceled'
            WHEN (`a`.`TASK_STS_CD` = 15) THEN 'consultant not familiar'
            WHEN (`a`.`TASK_STS_CD` = 16) THEN 'consultant refused'
            WHEN (`a`.`TASK_STS_CD` = 17) THEN 'Rescheduled'
            WHEN (`a`.`TASK_STS_CD` = 18) THEN 'need approeval'
            WHEN (`a`.`TASK_STS_CD` = 19) THEN 'interview completed'
            WHEN (`a`.`TASK_STS_CD` = 20) THEN 'pending'
            ELSE NULL
        END) AS `TASK_STS_NAME`,
        (CASE
            WHEN (`a`.`TASK_STS_UPD_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`TASK_STS_UPD_TS`)
        END) AS `TASK_STS_UPD_TS`,
        (CASE
            WHEN (`a`.`TASK_STS_UPD_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`TASK_STS_UPD_TS`) AS DATE)
        END) AS `TASK_STS_UPD_DT`,
        `a`.`TASK_TYPE_CD` AS `TASK_TYPE_CD`,
        (CASE
            WHEN (`a`.`TASK_TYPE_CD` = 1) THEN 'Consultation Task'
            WHEN (`a`.`TASK_TYPE_CD` = 2) THEN 'Other Consultant Task'
            WHEN (`a`.`TASK_TYPE_CD` = 3) THEN 'Other Client Contact Task'
            ELSE NULL
        END) AS `TASK_TYPE_NAME`,
        (CASE
            WHEN (`a`.`task_rgn_cd` = 1) THEN 'China'
            WHEN (`a`.`task_rgn_cd` = 2) THEN 'Asia-Pacific'
            WHEN (`a`.`task_rgn_cd` = 3) THEN 'GLO'
            ELSE NULL
        END) AS `task_rgn_name`,
        (CASE
            WHEN (`a`.`BEG_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`BEG_TS`)
        END) AS `BEG_TS`,
        (CASE
            WHEN (`a`.`BEG_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`BEG_TS`) AS DATE)
        END) AS `BEG_DT`,
        (CASE
            WHEN (`a`.`END_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`END_TS`)
        END) AS `END_TS`,
        (CASE
            WHEN (`a`.`END_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`END_TS`) AS DATE)
        END) AS `END_DT`,
        `a`.`TASK_MNGR_ID` AS `TASK_MNGR_ID`,
        `a`.`CLNT_ID` AS `CLNT_ID`,
        `a`.`CLNT_CNTCT_ID` AS `CLNT_CNTCT_ID`,
        `a`.`CNSLTNT_ID` AS `CNSLTNT_ID`,
        `a`.`PAY_STS_CD` AS `PAY_STS_CD`,
        (CASE
            WHEN (`a`.`PAY_STS_CD` = 1) THEN 'in process'
            WHEN (`a`.`PAY_STS_CD` = 2) THEN 'incompleted'
            WHEN (`a`.`PAY_STS_CD` = 3) THEN 'completed'
            ELSE NULL
        END) AS `PAY_STS_NAME`,
        `a`.`CNSLTNT_PAY_IND` AS `CNSLTNT_PAY_IND`,
        `a`.`CNSLTNT_CNY_AMT` AS `CNSLTNT_CNY_AMT`,
        `a`.`CNSLTNT_HR` AS `CNSLTNT_HR`,
        (CASE
            WHEN (`a`.`CNSLTNT_PAY_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`CNSLTNT_PAY_TS`)
        END) AS `CNSLTNT_PAY_TS`,
        (CASE
            WHEN (`a`.`CNSLTNT_PAY_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`CNSLTNT_PAY_TS`) AS DATE)
        END) AS `CNSLTNT_PAY_DT`,
        `a`.`CNSLTNT_PAY_TYPE_CD` AS `CNSLTNT_PAY_TYPE_CD`,
        `a`.`CNSLTNT_PAY_CRNCY_CD` AS `CNSLTNT_PAY_CRNCY_CD`,
        `a`.`CNSLTNT_PAY_NOTE` AS `CNSLTNT_PAY_NOTE`,
        (CASE
            WHEN (`a`.`CNSLTNT_PAY_TYPE_CD` = 1) THEN 'bank transfer'
            WHEN (`a`.`CNSLTNT_PAY_TYPE_CD` = 2) THEN 'credits'
            WHEN (`a`.`CNSLTNT_PAY_TYPE_CD` = 3) THEN 'charge calls'
            WHEN (`a`.`CNSLTNT_PAY_TYPE_CD` = 4) THEN 'donation'
            ELSE NULL
        END) AS `CNSLTNT_PAY_TYPE_NAME`,
        `a`.`CLNT_CNY_AMT` AS `CLNT_CNY_AMT`,
        `a`.`CLNT_HR` AS `CLNT_HR`,
        (CASE
            WHEN (`a`.`CLNT_PAY_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`CLNT_PAY_TS`)
        END) AS `CLNT_PAY_TS`,
        (CASE
            WHEN (`a`.`CLNT_PAY_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`CLNT_PAY_TS`) AS DATE)
        END) AS `CLNT_PAY_DT`,
        `a`.`CNSLTN_TYPE_CD` AS `CNSLTN_TYPE_CD`,
        (CASE
            WHEN (`a`.`CNSLTN_TYPE_CD` = 1) THEN 'Phone'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 2) THEN 'In-Person'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 3) THEN 'Roadshow'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 4) THEN 'Phone Exchange'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 5) THEN 'Phone Conference'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 6) THEN 'data'
            WHEN (`a`.`CNSLTN_TYPE_CD` = 7) THEN 'accompanysurvey'
            ELSE NULL
        END) AS `CNSLTN_TYPE_NAME`,
        `a`.`CNSLTNT_FDBK_CMNCTN_SCORE` AS `CNSLTNT_FDBK_CMNCTN_SCORE`,
        `a`.`CNSLTNT_FDBK_EXPRTS_SCORE` AS `CNSLTNT_FDBK_EXPRTS_SCORE`,
        `a`.`CNSLTNT_FDBK_PRFSNLSM_SCORE` AS `CNSLTNT_FDBK_PRFSNLSM_SCORE`,
        `a`.`CNSLTNT_FDBK_NOTE` AS `CNSLTNT_FDBK_NOTE`,
        `a`.`CNSLTNT_FIRST_CALL_IND` AS `CNSLTNT_FIRST_CALL_IND`,
        `a`.`CNSLTNT_PSTN_ID` AS `CNSLTNT_PSTN_ID`,
        `a`.`CNSLTNT_PSTN_NAME` AS `CNSLTNT_PSTN_NAME`,
        `a`.`CNSLTNT_CMPNY_ID` AS `CNSLTNT_CMPNY_ID`,
        `a`.`CNSLTNT_CMPNY_NAME` AS `CNSLTNT_CMPNY_NAME`,
        `a`.`CNSLTNT_INDSTRY_ID` AS `CNSLTNT_INDSTRY_ID`,
        `a`.`CNSLTNT_INDSTRY_NAME` AS `CNSLTNT_INDSTRY_NAME`,
        `a`.`CNSLTNT_SUBINDSTRY_ID` AS `CNSLTNT_SUBINDSTRY_ID`,
        `a`.`CNSLTNT_SUBINDSTRY_NAME` AS `CNSLTNT_SUBINDSTRY_NAME`,
        `a`.`TASK_INDSTRY_ID` AS `TASK_INDSTRY_ID`,
        (CASE
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) = 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level1_id`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level2_id`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) <> 0))
            THEN
                `ti`.`level3_id`
        END) AS `task_indstry_level1_id`,
        (CASE
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) = 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level1_name`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level2_name`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) <> 0))
            THEN
                `ti`.`level3_name`
        END) AS `task_indstry_level1_name`,
        (CASE
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) = 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                0
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level1_id`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) <> 0))
            THEN
                `ti`.`level2_id`
            ELSE 0
        END) AS `task_indstry_level2_id`,
        (CASE
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) = 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                NULL
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) = 0))
            THEN
                `ti`.`level1_name`
            WHEN
                ((IFNULL(`ti`.`level2_id`, 0) <> 0)
                    AND (IFNULL(`ti`.`level3_id`, 0) <> 0))
            THEN
                `ti`.`level2_name`
            ELSE NULL
        END) AS `task_indstry_level2_name`,
        (CASE
            WHEN (IFNULL(`ti`.`level3_id`, 0) = 0) THEN 0
            ELSE `ti`.`level1_id`
        END) AS `task_indstry_level3_id`,
        (CASE
            WHEN (IFNULL(`ti`.`level3_id`, 0) = 0) THEN 0
            ELSE `ti`.`level1_name`
        END) AS `task_indstry_level3_name`,
        (CASE
            WHEN (`a`.`CMPLT_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`CMPLT_TS`)
        END) AS `CMPLT_TS`,
        (CASE
            WHEN (`a`.`CMPLT_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`CMPLT_TS`) AS DATE)
        END) AS `CMPLT_DT`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE FROM_UNIXTIME(`a`.`USER_CRE_TS`)
        END) AS `USER_CRE_TS`,
        (CASE
            WHEN (`a`.`USER_CRE_TS` = 0) THEN NULL
            ELSE CAST(FROM_UNIXTIME(`a`.`USER_CRE_TS`) AS DATE)
        END) AS `USER_CRE_DT`,
        `a`.`USER_CRE_UID` AS `USER_CRE_UID`,
        `cre`.`USER_ENG_NAME` AS `CREATOR_NAME`,
        `cre`.`USER_ROLE_NAME` AS `CREATOR_ROLE`,
        `cre`.`TEAM_NAME` AS `CREATOR_TEAM`,
        `mngr`.`USER_ENG_NAME` AS `MANAGER_NAME`,
        `mngr`.`USER_ROLE_NAME` AS `MANAGER_ROLE`,
        `mngr`.`TEAM_NAME` AS `MANAGER_TEAM`,
        `a`.`RCMND_IND` AS `RCMND_IND`,
        `a`.`FIRST_RCMND_DT` AS `FIRST_RCMND_DT`,
        `a`.`LAST_RCMND_DT` AS `LAST_RCMND_DT`,
        `a`.`ARNG_IND` AS `ARNG_IND`,
        `a`.`FIRST_ARNG_DT` AS `FIRST_ARNG_DT`,
        `a`.`LAST_ARNG_DT` AS `LAST_ARNG_DT`,
        `a`.`RCMND_CNTCT_IND` AS `RCMND_CNTCT_IND`,
        `a`.`CMPLT_IND` AS `CMPLT_IND`
    FROM
        (((dw_simp.`dw_prjct_task` `a`
        LEFT JOIN dw_simp.`v_task_industry` `ti` ON ((`a`.`TASK_INDSTRY_ID` = `ti`.`level1_id`)))
        LEFT JOIN dw_simp.`v_user` `cre` ON ((`cre`.`UID` = `a`.`USER_CRE_UID`)))
        LEFT JOIN dw_simp.`v_user` `mngr` ON ((`mngr`.`UID` = `a`.`TASK_MNGR_ID`)))) ;
    
    
END$$

DELIMITER ;