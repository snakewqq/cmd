DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `update_dw_table`$$

CREATE DEFINER=`root`@`%` PROCEDURE `update_dw_table`()
BEGIN
TRUNCATE TABLE dw_simp.dw_user;
INSERT INTO dw_simp.dw_user
	(UID,
	USER_CHN_NAME,
	USER_ENG_NAME,
	PSTN_NAME,
	DEPT_NAME,
	MNGR_IND,
	TEAM_ID,
	TEAM_NAME,
	EXT_NUM,
	EMAIL_ADDR,
	USER_ROLE_NAME,
    user_sts_cd,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID	)
SELECT 
	a.id   					AS UID
	,a.chinaname			AS USER_CHN_NAME
	,a.englishname			AS USER_ENG_NAME
	,a.position				AS PSTN_NAME
	,a.department			AS DEPT_NAME
	,CASE WHEN c.position =1 THEN 1 ELSE 0 END AS MNGR_IND
	,d.id					AS TEAM_ID
	,TRIM(d.name)			AS TEAM_NAME
	,CASE WHEN TRIM(a.ext) ='' THEN NULL ELSE TRIM(ext) END		AS EXT_NUM
	,b.email				AS EMAIL_ADDR
	,etg.name				AS USER_ROLE_NAME
    ,u.status				AS user_sts_cd
	,NULL									AS SRC_CRE_TS
	,NULL									AS SRC_CRE_UID
	,NULL									AS SRC_UPD_TS
	,NULL									AS SRC_UPD_UID
	,UNIX_TIMESTAMP()						AS CRE_TS
	,1										AS CRE_UID
	,NULL									AS UPD_TS
	,NULL									AS UPD_UID
FROM ndb.ndb_employees a
LEFT JOIN ndb.ndb_user b 					ON a.id = b.id
LEFT JOIN (
	SELECT uid,MAX(teamid) AS teamid, MAX(POSITION) AS POSITION
	FROM ndb.ndb_employees_team_member 
	GROUP BY uid
) c 	ON a.id = c.uid
LEFT JOIN ndb.ndb_employees_team d		ON c.teamid = d.id
LEFT JOIN ndb.ndb_employees_team_group etg ON etg.id=d.groupid
LEFT JOIN ndb.ndb_user u ON u.id=a.id;
TRUNCATE TABLE dw_simp.dw_clnt_cntct;
INSERT INTO dw_simp.dw_clnt_cntct
	(CLNT_CNTCT_ID,
	CLNT_ID,
	CLNT_CNTCT_NAME,
	PSTN_NAME,
	CNTRY_ID,
	PRVNC_STATE_ID,
	CITY_ID,
	CNTRY_NAME,
	PRVNC_STATE_NAME,
	CITY_NAME,
	NPS_CD,
	ROLE_CD,
	MAIN_CNTCT_IND,
	CLNT_CNTCT_STS_CD,
	CPWEB_RGSTR_STS_CD,
	WANT_INVTN_IND,
	WANT_INVTN_TYPE_CD,
	CLNT_GRP_ID,
	USER_CRE_TS,
	REM_UID,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID)
	SELECT 
		cc.id 										AS CLNT_CNTCT_ID
		,cc.clientid								AS CLNT_ID
		,TRIM(cc.chinesename)						AS CLNT_CNTCT_NAME
		,TRIM(cc.position)							AS PSTN_NAME
		,CASE
			WHEN n1.level=1 THEN n1.id
			WHEN n1.level=2 THEN n2.id
			WHEN n1.level=3 THEN n3.id
			ELSE NULL
		END											AS CNTRY_ID
		,CASE 
			WHEN n1.level=2 THEN n1.id
			WHEN n1.level=3 THEN n2.id
			ELSE NULL
		END  										 AS PRVNC_ID
		,CASE
			WHEN n1.level=3 THEN n1.id
			ELSE NULL
		END   										AS CITY_ID
		,CASE
			WHEN n1.level=1 THEN n1.name
			WHEN n1.level=2 THEN n2.name
			WHEN n1.level=3 THEN n3.name
			ELSE NULL
		END											AS CNTRY_NAME
		,CASE 
			WHEN n1.level=2 THEN n1.name
			WHEN n1.level=3 THEN n2.name
			ELSE NULL
		END  										 AS PRVNC_NAME
		,CASE
			WHEN n1.level=3 THEN n1.name
			ELSE NULL
		END   										AS CITY_NAME
		,cc.nps										AS NPS_CD
		,cc.role									AS ROLE_CD
		,cc.ismain									AS MAIN_CNTCT_IND
		,cc.status									AS CLNT_CNTCT_STS_CD
		,cc.registration							AS CPWEB_RGSTR_STS_CD
		,cc.wantinvitation							AS WANT_INVTN_IND
		,cc.invitationtype							AS WANT_INVTN_TYPE_CD
		,cc.groupid									AS CLNT_GRP_ID
		,cc.createtime 								AS USER_CRE_TS
		,cc.rem 									AS REM_UID
		,NULL										AS SRC_CRE_TS
		,NULL										AS SRC_CRE_UID
		,NULL										AS SRC_UPD_TS
		,NULL										AS SRC_UPD_UID
		,UNIX_TIMESTAMP()							AS CRE_TS
		,1											AS CRE_UID
		,NULL										AS UPD_TS
		,NULL										AS UPD_UID
	FROM ndb.ndb_client_contact cc
	LEFT JOIN ndb.ndb_client c 							ON cc.clientid=c.id
	LEFT JOIN ndb.ndb_employees e 						ON e.id=cc.rem
	LEFT JOIN ndb.ndb_location n1 ON cc.location=n1.id
	LEFT JOIN ndb.ndb_location n2 ON n2.id=n1.parentid 
	LEFT JOIN ndb.ndb_location n3 ON n3.id=n2.parentid
	WHERE cc.status<>0;
	
	
TRUNCATE TABLE dw_simp.dw_clnt;
INSERT INTO dw_simp.dw_clnt
	(CLNT_ID,
	CLNT_NAME,
	CLNT_TYPE_CD,
	CLNT_SIZE_BKT_CD,
	CNTRY_ID,
	PRVNC_STATE_ID,
	CITY_ID,
	CNTRY_NAME,
	PRVNC_STATE_NAME,
	CITY_NAME,
	CLNT_AM_PCT,
	CLNT_AM_UID,
	CLNT_AM2_PCT,
	CLNT_AM2_UID,
	CLNT_AM3_PCT,
	CLNT_AM3_UID,
	CLNT_AM4_PCT,
	CLNT_AM4_UID,
	CLNT_STS_CD,
	CLNT_STS_NOTE,
	CLNT_ALERT_NOTE,
	USER_CRE_UID,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID,
	CRE_DT,
	CLNT_TEAM,
	CLNT_CHRG_TYPE_CD)
	
	SELECT 
		c.id 									AS CLNT_ID
		,TRIM(c.name) 							AS CLNT_NAME
		,c.type 								AS CLNT_TYPE_CD
		,c.teamsize 							AS CLNT_SIZE_BKT_CD
	
		,CASE
			WHEN n1.level=1 THEN n1.id
			WHEN n1.level=2 THEN n2.id
			WHEN n1.level=3 THEN n3.id
			WHEN l2.level=2 THEN l3.id
			ELSE c.country
		END											AS CNTRY_ID
		,CASE
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 THEN n1.id
			WHEN n1.level=3 THEN n2.id
			ELSE c.province
		END  										 AS PRVNC_STATE_ID
		,CASE 
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 AND n1.id IN (63,64,65,66) THEN n1.id
			WHEN n1.level=2 AND n1.id NOT IN (63,64,65,66) THEN NULL
			ELSE c.city	
		END												AS CITY_ID
		,CASE
			WHEN n1.level=1 THEN n1.name
			WHEN n1.level=2 THEN n2.name
			WHEN n1.level=3 THEN n3.name
			WHEN l2.level=2 THEN l3.name
			ELSE l1.name
		END											AS CNTRY_NAME
		,CASE 
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 THEN n1.name
			WHEN n1.level=3 THEN n2.name
			ELSE l2.name
		END  										 AS PRVNC_STATE_NAME
		,CASE
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 AND n1.id IN (63,64,65,66) THEN n1.name 
			WHEN n1.level=2 AND n1.id NOT IN (63,64,65,66) THEN NULL
			ELSE n1.name									
		END 											AS CITY_NAME
		
    	,am.AM_PCT								AS CLNT_AM_PCT
		,am.AM_UID								AS CLNT_AM_UID
		,CASE WHEN am.AM2_UID = am.AM_UID THEN NULL ELSE am.AM2_PCT END AS CLNT_AM2_PCT
		,CASE WHEN am.AM2_UID = am.AM_UID THEN NULL ELSE am.AM2_UID END AS CLNT_AM2_UID
		,CASE WHEN am.AM3_uid = am.AM2_UID THEN NULL ELSE am.AM3_PCT END AS CLNT_AM3_PCT
		,CASE WHEN am.AM3_uid = am.AM2_UID THEN NULL ELSE am.AM3_UID END AS CLNT_AM3_UID
		,CASE WHEN am.AM4_uid = am.AM3_UID THEN NULL ELSE am.AM4_PCT END AS CLNT_AM4_PCT
		,CASE WHEN am.AM4_uid = am.AM3_UID THEN NULL ELSE am.AM4_UID END AS CLNT_AM4_UID
		,cr.status 								AS CLNT_STS_CD
		,cr.statusnotes							AS CLNT_STS_NOTE
		,cr.alert								AS CLNT_ALERT_NOTE
		,c.uid 									AS USER_CRE_UID
		,NULL									AS SRC_CRE_TS
		,NULL									AS SRC_CRE_UID
		,NULL									AS SRC_UPD_TS
		,NULL									AS SRC_UPD_UID
		,UNIX_TIMESTAMP()						AS CRE_TS
		,1										AS CRE_UID
		,NULL									AS UPD_TS
		,NULL									AS UPD_UID
		,CASE
			WHEN IFNULL(c.CRE_DT,0)<>0 THEN DATE(FROM_UNIXTIME(c.CRE_DT))
			WHEN IFNULL(c.CRE_DT,0)=0 AND op.create_time IS NOT NULL THEN DATE(FROM_UNIXTIME(op.create_time))
			ELSE NULL
		END										AS CRE_DT
		,ntt.name 								AS CLNT_TEAM
		,c.chargetype							AS CLNT_CHRG_TYPE_CD
	FROM ndb.ndb_client c
	LEFT JOIN ndb.ndb_location l1 ON c.country=l1.id
	LEFT JOIN ndb.ndb_location l2 ON c.province=l2.id
	LEFT JOIN ndb.ndb_location l3 ON l3.id=l2.parentid
	
	LEFT JOIN ndb.ndb_location n1 ON c.city=n1.id
	LEFT JOIN ndb.ndb_location n2 ON n2.id=n1.parentid 
	LEFT JOIN ndb.ndb_location n3 ON n3.id=n2.parentid
	LEFT JOIN (
		SELECT clientid,MAX(STATUS) AS STATUS,MAX(alert) AS alert,MAX(statusnotes) AS statusnotes
		FROM ndb.ndb_client_relation 
		GROUP BY clientid
	) cr ON cr.clientid=c.id
	LEFT JOIN (
		SELECT 
			ncap.clientid AS clientid
			,SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 1 ) , '|', 1 ) AS AM_PCT
			,SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 1 ) , '|', -1 ) AS AM_UID
			,SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 2 ) , ',', -1 )  , '|', 1 ) AS AM2_PCT
			,SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 2 )  , ',', -1 ) , '|', -1 ) AS AM2_UID
			,SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 3 ) , ',', -1 )  , '|', 1 ) AS AM3_PCT
			,SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', 3 )  , ',', -1 ) , '|', -1 ) AS AM3_UID
			,SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', -1 ) , '|', 1 ) AS AM4_PCT
			,SUBSTRING_INDEX(SUBSTRING_INDEX( GROUP_CONCAT(CONCAT( percentage, "|", amid )) , ',', -1 ) , '|', -1 ) AS AM4_UID
		FROM ndb.ndb_client_am_percentage ncap
		GROUP BY ncap.clientid
	) am  ON am.clientid=c.id
	LEFT JOIN (
		SELECT 
			client_id AS clientid
			,MIN(DATE(FROM_UNIXTIME(TIME))) AS create_time  
		FROM ndb.ndb_log 
		WHERE ACTION='create client'
		GROUP BY client_id
	)op ON op.clientid=c.id
	LEFT JOIN ndb.ndb_taxonomy_term ntt ON ntt.id=c.amteamid AND ntt.taxonomyid=14;
	
	
TRUNCATE TABLE dw_simp.dw_clnt_grp_quota;
INSERT INTO dw_simp.dw_clnt_grp_quota(month_beg_dt,clnt_id,clnt_grp_id,quota_hr)  
SELECT 
CONCAT(a.year,'-'
               ,CASE WHEN a.quater='q1' AND c.mnth='m1' THEN '01'
                                WHEN a.quater='q1' AND c.mnth='m2' THEN '02'
                                WHEN a.quater='q1' AND c.mnth='m3' THEN '03'
                                WHEN a.quater='q2' AND c.mnth='m1' THEN '04'
                                WHEN a.quater='q2' AND c.mnth='m2' THEN '05'
                                WHEN a.quater='q2' AND c.mnth='m3' THEN '06'
                                WHEN a.quater='q3' AND c.mnth='m1' THEN '07'
                                WHEN a.quater='q3' AND c.mnth='m2' THEN '08'
                                WHEN a.quater='q3' AND c.mnth='m3' THEN '09'
                                WHEN a.quater='q4' AND c.mnth='m1' THEN '10'
                                WHEN a.quater='q4' AND c.mnth='m2' THEN '11'
                                WHEN a.quater='q4' AND c.mnth='m3' THEN '12'
                              ELSE NULL END,'-','01') AS month_beg_dt
,a.clientid AS CLNT_ID
,a.groupid AS clnt_grp_id
,CASE WHEN a.quater='q1' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q1' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q1' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q2' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q2' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q2' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q3' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q3' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q3' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q4' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q4' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q4' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
               ELSE NULL END AS quota_hr
FROM (
               SELECT 
               YEAR,clientid,groupid,quater
               ,SUM(CASE WHEN b.quater='q1' THEN a.q1 
                              WHEN b.quater='q2' THEN a.q2
                              WHEN b.quater='q3' THEN a.q3
                              WHEN b.quater='q4' THEN a.q4 
                              ELSE 0 END) AS quota
               FROM (
					SELECT 
						cc.groupname,cc.clientid,cc.q1,cc.q2,cc.q3,cc.q4,cc.UPD_UID,cc.year,cc.groupid
					FROM (
						SELECT * 
						FROM ndb.ndb_client_contact_group  
						ORDER BY CRE_DT
					) cc
					GROUP BY cc.groupname,cc.clientid,cc.q1,cc.q2,cc.q3,cc.q4,cc.UPD_UID,cc.year,cc.groupid
				) a
               CROSS JOIN (
                              SELECT 'q1' AS quater
                              UNION ALL SELECT 'q2' AS quater
                              UNION ALL SELECT 'q3' AS quater
                              UNION ALL SELECT 'q4' AS quater
               ) b
               GROUP BY YEAR,clientid,groupid,quater
) a
INNER JOIN ndb.ndb_client_contact_target b  ON a.year=b.year AND a.quater=b.qx
CROSS JOIN (
               SELECT 'm1' AS mnth
               UNION ALL SELECT 'm2' AS mnth
               UNION ALL SELECT 'm3' AS mnth
) c ;
TRUNCATE TABLE dw_simp.dw_clnt_quota;
INSERT INTO dw_simp.dw_clnt_quota(month_beg_dt,clnt_id,quota_hr)
SELECT 
CONCAT(a.year,'-'
               ,CASE WHEN a.quater='q1' AND c.mnth='m1' THEN '01'
                                WHEN a.quater='q1' AND c.mnth='m2' THEN '02'
                                WHEN a.quater='q1' AND c.mnth='m3' THEN '03'
                                WHEN a.quater='q2' AND c.mnth='m1' THEN '04'
                                WHEN a.quater='q2' AND c.mnth='m2' THEN '05'
                                WHEN a.quater='q2' AND c.mnth='m3' THEN '06'
                                WHEN a.quater='q3' AND c.mnth='m1' THEN '07'
                                WHEN a.quater='q3' AND c.mnth='m2' THEN '08'
                                WHEN a.quater='q3' AND c.mnth='m3' THEN '09'
                                WHEN a.quater='q4' AND c.mnth='m1' THEN '10'
                                WHEN a.quater='q4' AND c.mnth='m2' THEN '11'
                                WHEN a.quater='q4' AND c.mnth='m3' THEN '12'
                              ELSE NULL END,'-','01') AS month_beg_dt
,a.clientid AS clnt_id
,CASE WHEN a.quater='q1' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q1' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q1' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q2' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q2' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q2' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q3' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q3' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q3' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
                 WHEN a.quater='q4' AND c.mnth='m1' THEN a.quota*b.firstmonth/100
                 WHEN a.quater='q4' AND c.mnth='m2' THEN a.quota*b.middlemonth/100
                 WHEN a.quater='q4' AND c.mnth='m3' THEN a.quota*b.lastmonth/100
               ELSE NULL END AS quota_hr
FROM (
               SELECT 
               YEAR,clientid,quater
               ,SUM(CASE WHEN b.quater='q1' THEN a.q1 
                              WHEN b.quater='q2' THEN a.q2
                              WHEN b.quater='q3' THEN a.q3
                              WHEN b.quater='q4' THEN a.q4 
                              ELSE 0 END) AS quota
               FROM ndb.ndb_client_contact_group a
               CROSS JOIN (
                              SELECT 'q1' AS quater
                              UNION ALL SELECT 'q2' AS quater
                              UNION ALL SELECT 'q3' AS quater
                              UNION ALL SELECT 'q4' AS quater
               ) b
               GROUP BY YEAR,clientid,quater
) a
INNER JOIN ndb.ndb_client_contact_target b ON a.year=b.year AND a.quater=b.qx
CROSS JOIN (
               SELECT 'm1' AS mnth
               UNION ALL SELECT 'm2' AS mnth
               UNION ALL SELECT 'm3' AS mnth
) c;
DROP TABLE IF EXISTS dw_simp.tmp_tb1;
CREATE TABLE dw_simp.tmp_tb1 AS 
SELECT consultantid, SUBSTRING_INDEX( MAX( CONCAT( origin, "|", originvalue ) ) , '|', 1 ) AS origin, SUBSTRING_INDEX( MAX( CONCAT( origin, "|", originvalue ) ) , '|', -1 ) AS originvalue
		FROM ndb.ndb_consultant_origin
		GROUP BY consultantid;
DROP TABLE IF EXISTS dw_simp.tmp_tb2;
CREATE TABLE dw_simp.tmp_tb2 AS 
SELECT 
		consultantid AS CNSLTNT_ID
		,MAX(CASE WHEN TYPE =1 THEN background ELSE NULL END) AS BCKGRND_CHN_TXT
		,MAX(CASE WHEN TYPE =1 THEN expertise ELSE NULL END) AS EXPRTS_CHN_TXT
		,MAX(CASE WHEN TYPE =2 THEN background ELSE NULL END) AS BCKGRND_ENG_TXT
		,MAX(CASE WHEN TYPE =2 THEN expertise ELSE NULL END) AS EXPRTS_ENG_TXT
		FROM ndb.ndb_consultant_background
		GROUP BY consultantid;
DROP TABLE IF EXISTS dw_simp.tmp_tb3;
CREATE TABLE dw_simp.tmp_tb3 AS 
SELECT 
		    nc.objectid AS cnsltnt_id
			,MAX(CASE WHEN cm.id IS NOT NULL THEN 1 ELSE 0 END) AS mbl
			,MAX(CASE WHEN ct.id IS NOT NULL THEN 1 ELSE 0 END) AS tel
			,MAX(CASE WHEN co.id IS NOT NULL THEN 1 ELSE 0 END) AS email
		FROM ndb.ndb_contacts nc
		LEFT JOIN ndb.ndb_contact_mobile cm ON cm.id=nc.contactid AND nc.contacttype=1
		LEFT JOIN ndb.ndb_contact_telephone ct ON ct.id=nc.contactid AND nc.contacttype=2
		LEFT JOIN ndb.ndb_contact_others co ON co.id=nc.contactid AND nc.contacttype=9
		WHERE nc.type=1
		GROUP BY nc.objectid;
DROP TABLE IF EXISTS dw_simp.tmp_tb4;
CREATE TABLE dw_simp.tmp_tb4 AS 
SELECT v.ndb_id,v.sign_tnc
		FROM dw_simp.vesta_consultant v
		INNER JOIN dw_simp.vesta_user vu ON vu.id=v.id
		WHERE vu.account_type=2
		GROUP BY v.ndb_id;
DROP TABLE IF EXISTS dw_simp.tmp_tb5;
CREATE TABLE dw_simp.tmp_tb5 AS 
SELECT DISTINCT con.id AS id
		FROM ndb.ndb_consultant con
		INNER JOIN ndb.ndb_consultant_files ncf ON ncf.consultantid=con.id
		INNER JOIN ndb.ndb_files f ON f.id=ncf.fileid
		WHERE ncf.status=1 AND f.status=1;
DROP TABLE IF EXISTS dw_simp.tmp_tb6;
CREATE TABLE dw_simp.tmp_tb6 AS 
SELECT c.id AS consultantid,cm.countrycode
		FROM ndb.ndb_consultant c
		INNER JOIN ndb.ndb_contacts nc ON nc.objectid=c.id AND nc.type=1
		INNER JOIN ndb.ndb_contact_mobile cm ON cm.id=nc.contactid AND nc.contacttype=1
		WHERE cm.mobile<>cm.countrycode
		GROUP BY c.id
		ORDER BY cm.countrycode DESC;
DROP TABLE IF EXISTS dw_simp.tmp_tb7;
CREATE TABLE dw_simp.tmp_tb7 AS 
SELECT c.id AS consultantid,ct.countrycode,ct.telephone
		FROM ndb.ndb_consultant c
		INNER JOIN ndb.ndb_contacts nc ON nc.objectid=c.id AND nc.type=1
		INNER JOIN ndb.ndb_contact_telephone ct ON ct.id=nc.contactid AND nc.contacttype=2
		WHERE ct.countrycode<>ct.telephone
		GROUP BY c.id
		ORDER BY ct.countrycode;
ALTER TABLE dw_simp.tmp_tb1 ADD INDEX ix_consultantid(consultantid);
ALTER TABLE dw_simp.tmp_tb2 ADD INDEX ix_CNSLTNT_ID(CNSLTNT_ID);
ALTER TABLE dw_simp.tmp_tb3 ADD INDEX ix_cnsltnt_id(cnsltnt_id);
ALTER TABLE dw_simp.tmp_tb4 ADD INDEX ix_ndb_id(ndb_id);
ALTER TABLE dw_simp.tmp_tb5 ADD INDEX ix_id(id);
ALTER TABLE dw_simp.tmp_tb6 ADD INDEX ix_consultantid(consultantid);
ALTER TABLE dw_simp.tmp_tb7 ADD INDEX ix_consultantid(consultantid);
TRUNCATE TABLE dw_simp.dw_cnsltnt;
INSERT INTO dw_simp.dw_cnsltnt
	(CNSLTNT_ID,
	CNSLTNT_NAME,
	CNSLTNT_STS_CD,
	CNTRY_ID ,
	PRVNC_STATE_ID ,
	CITY_ID ,
	CNTRY_NAME ,
	PRVNC_STATE_NAME ,
	CITY_NAME ,
	CNSLTNT_TYPE_CD,
	ORGN_CHNL_CD,
	ORGN_CHNL_DTL_NAME,
	RFRL_CNSLTNT_ID,
	RFRL_UID,
	PSTN_ID,
	PSTN_NAME,
	CMPNY_ID,
	CMPNY_NAME,
	INDSTRY_ID,
	INDSTRY_NAME,
	SUBINDSTRY_ID,
	SUBINDSTRY_NAME,
	FNCTN_ID,
	FNCTN_NAME,
	BCKGRND_CHN_TXT,
	EXPRTS_CHN_TXT,
	BCKGRND_ENG_TXT,
	EXPRTS_ENG_TXT,
	VALID_EMAIL_IND,
	VALID_TEL_IND,
	VALID_MBL_IND,
	KSH_MBR_IND,
	KSH_RGSTR_TS,
	FEE_RATE_LC_AMT,
	FEE_RATE_CRNCY_CD,
	USER_CRE_TS,
	USER_CRE_UID,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID,
	RESUMEBOX_IND,
	RESUME_ATTACH_IND,
	CRDT_CNT,
	CRDT_SPNT,
	CRDT_ERN,
	LAST_CNTCT_TS,
	CNSLTNT_MBL_CNTRY_CODE,
	CNSLTNT_TLPHN_CNTRY_CODE)
	SELECT 
		c.id 						AS CNSLTNT_ID
		,TRIM(c.name) 				AS CNSLTNT_NAME
		,c.status 					AS CNSLTNT_STS_CD
		,CASE
			WHEN n1.level=1 THEN n1.id
			WHEN n1.level=2 THEN n2.id
			WHEN n1.level=3 THEN n3.id
			WHEN l2.level=2 THEN l3.id
			ELSE c.countryid
		END											AS CNTRY_ID
		,CASE
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 THEN n1.id
			WHEN n1.level=3 THEN n2.id
			ELSE c.province
		END  										 AS PRVNC_STATE_ID
		,CASE 
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 AND n1.id IN (63,64,65,66) THEN n1.id
			WHEN n1.level=2 AND n1.id NOT IN (63,64,65,66) THEN NULL
			ELSE c.city	
		END												AS CITY_ID
		,CASE
			WHEN n1.level=1 THEN n1.name
			WHEN n1.level=2 THEN n2.name
			WHEN n1.level=3 THEN n3.name
			WHEN l2.level=2 THEN l3.name
			ELSE l1.name
		END											AS CNTRY_NAME
		,CASE 
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 THEN n1.name
			WHEN n1.level=3 THEN n2.name
			ELSE l2.name
		END  										 AS PRVNC_STATE_NAME
		,CASE
			WHEN n1.level=1 THEN NULL
			WHEN n1.level=2 AND n1.id IN (63,64,65,66) THEN n1.name 
			WHEN n1.level=2 AND n1.id NOT IN (63,64,65,66) THEN NULL
			ELSE n1.name									
		END 											AS CITY_NAME
		,c.type 										AS CNSLTNT_TYPE_CD
		,c.origin_id 									AS ORGN_CHNL_CD
		
		,CASE 
			WHEN c.origin_id = 3 			THEN TRIM(tt.name)
			WHEN c.origin_id IN (4,5,6,7) THEN TRIM(c.origin_value )
			ELSE NULL
		END						AS ORGN_CHNL_DTL_NAME
		,CAST(CASE 
			WHEN c.origin_id = 1 AND dw_simp.IsNum(c.origin_value )=1 THEN c.origin_value  
			ELSE NULL 
		END AS UNSIGNED)  						AS RFRL_CNSLTNT_ID
		,CAST(CASE 
			WHEN c.origin_id = 2 AND dw_simp.IsNum(c.origin_value )=1 THEN c.origin_value  
			ELSE NULL
		END  AS UNSIGNED) 						AS RFRL_UID
		,c.position_id 							AS PSTN_ID
		
		,TRIM(c.position_name) 					AS PSTN_NAME
		
		,c.company_id							AS CMPNY_ID
		
		,TRIM(company_name )					AS CMPNY_NAME
		
		
		,CASE
			WHEN c.industry_id IS NOT NULL THEN c.industry_id
			ELSE indstry2.id
		END										AS INDSTRY_ID
		,CASE 
			WHEN industry.name IS NOT NULL THEN industry.name
			ELSE indstry2.name
		END 									AS INDSTRY_NAME
		,cv.subindustry 						AS SUBINDSTRY_ID
		,subindstry.name						AS SUBINDSTRY_NAME
		,c.function_id							AS FNCTN_ID
		
		,ntt2.name		 						AS FNCTN_NAME
		,ba.BCKGRND_CHN_TXT 					AS BCKGRND_CHN_TXT
		,ba.EXPRTS_CHN_TXT						AS EXPRTS_CHN_TXT
		,ba.BCKGRND_ENG_TXT						AS BCKGRND_ENG_TXT
		,ba.EXPRTS_ENG_TXT						AS EXPRTS_ENG_TXT
		,IFNULL(cntct.email,0)					AS VALID_EMAIL_IND
		,IFNULL(cntct.tel,0)					AS VALID_TEL_IND
		,IFNULL(cntct.mbl,0)					AS VALID_MBL_IND
		,CASE 
			WHEN IFNULL(vc.ndb_id,0)<>0 THEN 1 
			ELSE 0
		END 									AS KSH_MBR_IND
		,vc.sign_tnc							AS KSH_RGSTR_TS
		,c.rate									AS FEE_RATE_LC_AMT
		,c.currency								AS FEE_RATE_CRNCY_CD
		,c.createtime 							AS USER_CRE_TS
		,c.uid 									AS USER_CRE_UID
		,NULL									AS SRC_CRE_TS
		,NULL									AS SRC_CRE_UID
		,NULL									AS SRC_UPD_TS
		,NULL									AS SRC_UPD_UID
		,UNIX_TIMESTAMP()						AS CRE_TS
		,1										AS CRE_UID
		,NULL									AS UPD_TS
		,NULL									AS UPD_UID
		,CASE 
			WHEN IFNULL(TRIM(c.resumebox),'')='' THEN 0
			ELSE 1
		END 									AS RESUMEBOX_IND
		,CASE
			WHEN cf.id IS NULL THEN 0
			ELSE 1
		END 									AS RESUME_ATTACH_IND
		,0										AS CRDT_CNT
		,0										AS CRDT_SPNT
		,0										AS CRDT_ERN
		,0										AS LAST_CNTCT_TS
		,cm.countrycode							AS CNSLTNT_MBL_CNTRY_CODE
		,ct.countrycode							AS CNSLTNT_TLPHN_CNTRY_CODE
	FROM ndb.ndb_consultant c
	LEFT JOIN ndb.ndb_location l1 ON c.countryid=l1.id
	LEFT JOIN ndb.ndb_location l2 ON c.province=l2.id
	LEFT JOIN ndb.ndb_location l3 ON l3.id=l2.parentid
	
	LEFT JOIN ndb.ndb_location n1 ON c.city=n1.id
	LEFT JOIN ndb.ndb_location n2 ON n2.id=n1.parentid 
	LEFT JOIN ndb.ndb_location n3 ON n3.id=n2.parentid
	LEFT JOIN ndb.ndb_taxonomy_term industry			ON industry.id = c.industry_id
	LEFT JOIN ndb.ndb_company_vocabulary cv 			ON cv.id=c.company_id
	LEFT JOIN ndb.ndb_taxonomy_term subindstry  		ON subindstry.id = cv.subindustry
	LEFT JOIN ndb.ndb_taxonomy_term indstry2			ON subindstry.parentid=indstry2.id
	
	
	LEFT JOIN 
	 dw_simp.tmp_tb1 co 	ON co.consultantid = c.id
	LEFT JOIN ndb.ndb_taxonomy_term tt 					ON tt.id = c.origin_value  AND c.origin_id = 3
	
	LEFT JOIN ndb.ndb_taxonomy_term ntt2 				ON ntt2.id=c.function_id
	LEFT JOIN dw_simp.tmp_tb2 ba ON ba.CNSLTNT_ID=c.id
	LEFT JOIN dw_simp.tmp_tb3 cntct ON cntct.cnsltnt_id = c.id 
	LEFT JOIN dw_simp.tmp_tb4 vc ON vc.ndb_id=c.id
	LEFT JOIN dw_simp.tmp_tb5 cf ON cf.id=c.id
	LEFT JOIN dw_simp.tmp_tb6 cm ON cm.consultantid=c.id
	LEFT JOIN dw_simp.tmp_tb7 ct ON ct.consultantid=c.id;
	
	
DROP TABLE IF EXISTS dw_simp.tmp_tb8;
CREATE TABLE dw_simp.tmp_tb8 AS 
SELECT projectid,MAX(VALUE) AS keyqu
		FROM ndb.ndb_project_profile
		WHERE attribute='KeyQuestions'
		GROUP BY projectid ;
		
		
DROP TABLE IF EXISTS dw_simp.tmp_tb9;
CREATE TABLE dw_simp.tmp_tb9 AS 
SELECT projectid, VALUE
		FROM ndb.ndb_project_profile
		WHERE attribute = 'ProjectNotes';
		
DROP TABLE IF EXISTS dw_simp.tmp_tb10;
CREATE TABLE dw_simp.tmp_tb10 AS 
SELECT projectid,contactid
		FROM ndb.ndb_project_client_contact
		WHERE main=1;
		
		
DROP TABLE IF EXISTS dw_simp.tmp_tb11;
CREATE TABLE dw_simp.tmp_tb11 AS 
SELECT MIN(id) AS id 
			FROM ndb.ndb_project_client_contact contract2  
			WHERE main=0  AND  NOT EXISTS (SELECT projectid FROM ndb.ndb_project_client_contact WHERE main=1 AND projectid=contract2.projectid)
			GROUP BY projectid;
			
			
ALTER TABLE dw_simp.tmp_tb11   ADD INDEX ix_id(id);	
INSERT INTO  dw_simp.tmp_tb10
		SELECT projectid,contactid
		FROM ndb.ndb_project_client_contact contract1
		WHERE EXISTS (
			SELECT id 
			FROM dw_simp.tmp_tb11   
			WHERE id=contract1.id);
			
			
DROP TABLE IF EXISTS dw_simp.tmp_tb12;
CREATE TABLE dw_simp.tmp_tb12 AS 
SELECT projectid, MAX(contactid) AS contactid
		FROM ndb.ndb_project_client_contact_manager
		GROUP BY projectid;
		
		
DROP TABLE IF EXISTS dw_simp.tmp_tb13;
CREATE TABLE dw_simp.tmp_tb13 AS 
SELECT 
			projectid
			,MAX(CASE WHEN role = 1 THEN uid ELSE NULL END) AS am
			,MAX(CASE WHEN role = 2 THEN uid ELSE NULL END) AS pm
			,MAX(CASE WHEN role = 3 THEN uid ELSE NULL END) AS skm
		FROM ndb.ndb_project_team
		GROUP BY projectid ;
ALTER TABLE dw_simp.tmp_tb8 ADD INDEX ix_projectid(projectid);
ALTER TABLE dw_simp.tmp_tb9 ADD INDEX ix_projectid(projectid);
ALTER TABLE dw_simp.tmp_tb10 ADD INDEX ix_projectid(projectid);
ALTER TABLE dw_simp.tmp_tb12 ADD INDEX ix_projectid(projectid);
ALTER TABLE dw_simp.tmp_tb13 ADD INDEX ix_projectid(projectid);
TRUNCATE TABLE dw_simp.dw_prjct;
INSERT INTO dw_simp.dw_prjct
	(PRJCT_ID,
	PRJCT_NAME,
	PRJCT_DSPLY_NAME,
	PRJCT_DESC,
	PRJCT_CLNT_CASE_CD,
	PRJCT_CTGRY_CD,
	INDSTRY_ID,
	SUBINDSTRY_ID,
	INDSTRY_NAME,
	SUBINDSTRY_NAME,
	BEG_TS,
	END_TS,
	PRJCT_STS_CD,
	PRJCT_STS_UPD_TS,
	PRJCT_KEYQSTN_TXT,
	RQST_CNSLTNT_CNT,
	EXPCT_CNSLTNT_CNT,
	RCMND_TASK_CNT,
	ARNG_TASK_CNT,
	CMPLT_TASK_CNT,
	RCMND_CNSLTNT_CNT,
	ARNG_CNSLTNT_CNT,
	CMPLT_CNSLTNT_CNT,
	CNSLTNT_HR,
	PRJCT_QLTY_CD,
	PRJCT_WLNG_IND,
	PRJCT_NOTE,
	CNSLTN_CLNT_ID,
	CNSLTN_CLNT_CNTCT_ID,
	CNSLTN_CLNT_CNTCT_MNGR_ID,
	AM_UID,
	PRJCT_MNGR_UID,
	SKM_UID,
	ON_HOLD_DAY,
	USER_CRE_TS,
	USER_CRE_UID,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID)
	SELECT
			 p.id 																AS PRJCT_ID
			,TRIM(p.name)														AS PRJCT_NAME
			,p.codename															AS PRJCT_DSPLY_NAME
			,p.description														AS PRJCT_DESC
			,p.clientcode														AS PRJCT_CLNT_CASE_CD
			,p.category															AS PRJCT_CTGRY_CD
			,CASE 
				WHEN ntt.parentid=0 THEN ntt.id
				ELSE ntt1.id
			END																	AS INDSTRY_ID
			,CASE
				WHEN ntt.parentid<> 0 THEN ntt.id
				ELSE NULL
			END																	AS SUBINDSTRY_ID
			,CASE 
				WHEN ntt.parentid=0 THEN ntt.name
				ELSE ntt1.name
			END																	AS INDSTRY_NAME
			,CASE
				WHEN ntt.parentid<> 0 THEN ntt.name
				ELSE NULL
			END																	AS SUBINDSTRY_NAME
			,p.starttime														AS BEG_TS
			,p.endtime															AS END_TS
			,p.status															AS PRJCT_STS_CD
			,p.statustime														AS PRJCT_STS_CHNG_TS
			,qu.keyqu															AS PRJCT_KEYQSTN_TXT
			,p.requestedconsultants												AS RQST_CNSLTNT_CNT
			,p.expectedconsultants												AS EXPCT_CNSLTNT_CNT
			,0																	AS RCMND_TASK_CNT
			,0																	AS ARNG_TASK_CNT
			,0																	AS CMPLT_TASK_CNT
			,0																	AS RCMND_CNSLTNT_CNT
			,0																	AS ARNG_CNSLTNT_CNT
			,0																	AS CMPLT_CNSLTNT_CNT
			,0																	AS CNSLTNT_HR
			,pfe.quality														AS PRJCT_QLTY_CD
			,CASE WHEN pfe.willing = 2 THEN 0 ELSE pfe.willing END 				AS PRJCT_WLNG_IND
			,ppro.value															AS PRJCT_NOTE
			,pclnt.clientid														AS CNSLTN_CLNT_ID
			,pccon.contactid													AS CNSLTN_CLNT_CNTCT_ID
			,pccmanager.contactid												AS CNSLTN_CLNT_CNTCT_MNGR_ID
			,pumanager.am														AS AM_UID
			,pumanager.pm														AS PRJCT_MNGR_UID
			,pumanager.skm														AS SKM_UID
			,CASE
				WHEN p.status=1 THEN FLOOR((UNIX_TIMESTAMP() - p.updatetime)/86400)
				ELSE 0
			END
 																AS ON_HOLD_DAY
			,p.createtime														AS USER_CRE_TS
			,p.uid																AS USER_CRE_UID
		,NULL									AS SRC_CRE_TS
		,NULL									AS SRC_CRE_UID
		,NULL									AS SRC_UPD_TS
		,NULL									AS SRC_UPD_UID
		,UNIX_TIMESTAMP()						AS CRE_TS
		,1										AS CRE_UID
		,NULL									AS UPD_TS
		,NULL									AS UPD_UID
	FROM ndb.ndb_project p
	LEFT JOIN dw_simp.tmp_tb8 qu ON qu.projectid=p.id
	LEFT JOIN ndb.ndb_taxonomy_term ntt ON ntt.id=p.industryid AND ntt.taxonomyid=1
	LEFT JOIN ndb.ndb_taxonomy_term ntt1 ON ntt1.id=ntt.parentid AND ntt1.taxonomyid=1
	LEFT JOIN ndb.ndb_project_consultation pco ON pco.id=p.id
	LEFT JOIN ndb.ndb_project_feedback pfe ON pfe.projectid=p.id
	LEFT JOIN dw_simp.tmp_tb9 ppro ON ppro.projectid=p.id
	LEFT JOIN ndb.ndb_project_client pclnt ON pclnt.projectid = p.id
	LEFT JOIN dw_simp.tmp_tb10 pccon ON pccon.projectid=p.id
	LEFT JOIN dw_simp.tmp_tb12 pccmanager ON pccmanager.projectid=p.id
	LEFT JOIN dw_simp.tmp_tb13 pumanager ON pumanager.projectid=p.id
;
DROP TABLE IF EXISTS dw_simp.tmp_tb14;
CREATE TABLE dw_simp.tmp_tb14 AS 
SELECT consultantid, SUBSTRING_INDEX( MAX( CONCAT( enddate, '|', id ) ) , '|', -1 ) AS pid
			FROM ndb.ndb_consultant_position
			GROUP BY consultantid;
			
			
DROP TABLE IF EXISTS dw_simp.tmp_tb15;
CREATE TABLE dw_simp.tmp_tb15 AS 
SELECT taskid, MAX(TIME) AS completedtime
			FROM ndb.ndb_project_task_status_transition  
			WHERE newvalue=8
			GROUP BY taskid;
			
			
DROP TABLE IF EXISTS dw_simp.tmp_tb16;
CREATE TABLE dw_simp.tmp_tb16 AS 
SELECT ptst.taskid,MAX(ptst.recommend_dt) AS recommend_dt
			FROM (
				SELECT  taskid,DATE(FROM_UNIXTIME(ptst.time)) AS recommend_dt
				FROM ndb.ndb_project_task_status_transition ptst
				WHERE newvalue=6 AND TIME<>0 
				ORDER BY id ASC
				)ptst
			GROUP BY ptst.taskid;
			
			
DROP TABLE IF EXISTS dw_simp.tmp_tb17;
CREATE TABLE dw_simp.tmp_tb17 AS 
SELECT ptst.taskid,MAX(ptst.arange_dt) AS arange_dt
			FROM (
				SELECT  taskid,DATE(FROM_UNIXTIME(ptst.time)) AS arange_dt
				FROM ndb.ndb_project_task_status_transition ptst
				WHERE newvalue=7 AND TIME<>0 
				ORDER BY id ASC
				)ptst
			GROUP BY ptst.taskid;
ALTER TABLE dw_simp.tmp_tb14 ADD INDEX ix_consultantid(consultantid);
ALTER TABLE dw_simp.tmp_tb15 ADD INDEX ix_taskid(taskid);
ALTER TABLE dw_simp.tmp_tb16 ADD INDEX ix_taskid(taskid);
ALTER TABLE dw_simp.tmp_tb17 ADD INDEX ix_taskid(taskid);
TRUNCATE TABLE dw_simp.dw_prjct_task;
INSERT INTO dw_simp.dw_prjct_task
	(TASK_ID,
	PRJCT_ID,
	TASK_STS_CD,
	TASK_STS_UPD_TS,
	TASK_TYPE_CD,
	task_rgn_cd,
	BEG_TS,
	END_TS,
	TASK_MNGR_ID,
	CLNT_ID,
	CLNT_CNTCT_ID,
	CNSLTNT_ID,
	PAY_STS_CD,
	CNSLTNT_PAY_IND,
	CNSLTNT_CNY_AMT,
	CNSLTNT_HR,
	CNSLTNT_PAY_TS,
	CNSLTNT_PAY_TYPE_CD,
	CNSLTNT_PAY_CRNCY_CD,
	CNSLTNT_PAY_NOTE,
	CLNT_CNY_AMT,
	CLNT_HR,
	CLNT_PAY_TS,
	CNSLTN_TYPE_CD,
	CNSLTNT_FDBK_CMNCTN_SCORE,
	CNSLTNT_FDBK_EXPRTS_SCORE,
	CNSLTNT_FDBK_PRFSNLSM_SCORE,
	CNSLTNT_FDBK_NOTE,
	CNSLTNT_FIRST_CALL_IND,
	CNSLTNT_PSTN_ID,
	CNSLTNT_PSTN_NAME,
	CNSLTNT_CMPNY_ID,
	CNSLTNT_CMPNY_NAME,
	CNSLTNT_INDSTRY_ID,
	CNSLTNT_INDSTRY_NAME,
	CNSLTNT_SUBINDSTRY_ID,
	CNSLTNT_SUBINDSTRY_NAME,
	TASK_INDSTRY_ID,
	TASK_INDSTRY_NAME,
	CMPLT_TS,
	USER_CRE_TS,
	USER_CRE_UID,
	SRC_CRE_TS,
	SRC_CRE_UID,
	SRC_UPD_TS,
	SRC_UPD_UID,
	CRE_TS,
	CRE_UID,
	UPD_TS,
	UPD_UID,
	RCMND_IND,
	FIRST_RCMND_DT,
	LAST_RCMND_DT,
	ARNG_IND,
	FIRST_ARNG_DT,
	LAST_ARNG_DT,
	RCMND_CNTCT_IND,
	CMPLT_IND
	)
SELECT 
			 pt.id 																AS TASK_ID
			,IFNULL(IFNULL(pct.projectid,ptc.projectid),ptcc.projectid)			AS PRJCT_ID
			,pt.status															AS TASK_STS_CD
			,pt.statustime														AS TASK_STS_UPD_TS
			,CASE
				WHEN pct.id IS NOT NULL THEN 1 
				WHEN ptc.id IS NOT NULL THEN 2 
				WHEN ptcc.id IS NOT NULL THEN 3 
				ELSE NULL
			END																	AS TASK_TYPE_CD
			,pct.type															AS task_rgn_cd
			,IFNULL(IFNULL(pct.starttime,ptc.starttime),ptcc.starttime)			AS BEG_TS
			,IFNULL(IFNULL(pct.endtime,ptc.endtime),ptcc.endtime)				AS END_TS
			,IFNULL(IFNULL(pct.taskmanagerid,ptc.manageuid),ptcc.manageuid)		AS TASK_MNGR_ID
			,IFNULL(pct.clientid,ptcc.clientid)									AS CLNT_ID
			,IFNULL(pct.contactid,ptcc.contactid)								AS CLNT_CNTCT_ID
			,IFNULL(pct.consultantid,ptc.consultantid)							AS CNSLTNT_ID
			,pt.paymentstatus													AS PAY_STS_CD
			,IFNULL(pct.paid,ptc.paid)											AS CNSLTNT_PAY_IND
			,ptp.cash															AS CNSLTNT_CNY_AMT
			,ptp.hours															AS CNSLTNT_HR
			,ptp.paytime														AS CNSLTNT_PAY_TS
			,ptp.type															AS CNSLTNT_PAY_TYPE_CD
			,ptp.currency														AS CNSLTNT_PAY_CRNCY_CD
			,ptp.paymentnotes													AS CNSLTNT_PAY_NOTE
			,ptr.cash															AS CLNT_CNY_AMT
			,ptr.hours															AS CLNT_HR
			,ptr.paytime														AS CLNT_PAY_TS
			,pct.typeofinterview												AS CNSLTN_TYPE_CD
			,CASE WHEN cf.experttise =0 OR cf.communication=0 OR cf.professionlism=0 THEN NULL
				ELSE cf.communication END										AS CNSLTNT_FDBK_CMNCTN_SCORE
			,CASE WHEN cf.experttise =0 OR cf.communication=0 OR cf.professionlism=0 THEN NULL
				ELSE cf.experttise END											AS CNSLTNT_FDBK_EXPRTS_SCORE
			,CASE WHEN cf.experttise =0 OR cf.communication=0 OR cf.professionlism=0 THEN NULL
				ELSE cf.professionlism END										AS CNSLTNT_FDBK_PRFSNLSM_SCORE
			,cf.notes															AS CNSLTNT_FDBK_NOTE
			,0																	AS CNSLTNT_FIRST_CALL_IND
			,pv.id	 															AS CNSLTNT_PSTN_ID
			,TRIM(pv.name) 														AS CNSLTNT_PSTN_NAME
			,cp.company															AS CNSLTNT_CMPNY_ID
			,TRIM(cv.name)														AS CNSLTNT_CMPNY_NAME
			,CASE
				WHEN indstry2.id IS NOT NULL THEN indstry2.id
				ELSE indstry.id
			END																	AS CNSLTNT_INDSTRY_ID
			,CASE 
				WHEN indstry2.id IS NOT NULL THEN indstry2.name
				ELSE indstry.name
			END 																AS CNSLTNT_INDSRTY_NAME
			,cv.subindustry 													AS CNSLTNT_SUBINDSTRY_ID
			,subindstry.name 													AS CNSLTNT_SUBINDSTRY_NAME
			,pct.industry														AS TASK_INDSTRY_ID
			,pctIND.name														AS TASK_INDSTRY_NAME
			,cmt.completedtime													AS CMPLT_TS
			,pt.createtime														AS USER_CRE_TS
			,pt.uid	 															AS USER_CRE_UID
			,NULL																AS SRC_CRE_TS
			,NULL																AS SRC_CRE_UID
			,NULL																AS SRC_UPD_TS
			,NULL																AS SRC_UPD_UID
			,UNIX_TIMESTAMP()													AS CRE_TS
			,1																	AS CRE_UID
			,NULL																AS UPD_TS
			,NULL																AS UPD_UID
			,CASE
				WHEN rec.recommend_dt IS NOT NULL THEN 1
				WHEN pt.status IN (6,7,8)	THEN 1
				ELSE 0
			END 									AS RCMND_IND
			,CASE
				WHEN rec.recommend_dt IS NOT NULL THEN rec.recommend_dt
				ELSE NULL
			END										AS FIRST_RCMND_DT
			,CASE
				WHEN rec1.recommend_dt IS NOT NULL THEN rec1.recommend_dt
				ELSE NULL
			END										AS LAST_RCMND_DT
			,CASE
				WHEN ara.arange_dt IS NOT NULL		THEN 1
				WHEN pt.status IN (7,8)	THEN 1
				ELSE 0
			END 									AS ARNG_IND
			,CASE
				WHEN ara.arange_dt IS NOT NULL		THEN ara.arange_dt
				ELSE NULL
			END										AS FIRST_ARNG_DT
			,CASE
				WHEN ara1.arange_dt IS NOT NULL		THEN ara1.arange_dt
				ELSE NULL
			END										AS LAST_ARNG_DT
			,CASE WHEN ptc.contacted=2 THEN 1
				  WHEN pct.contacted=2 THEN 1
				  WHEN ptc.contacted=1 THEN 0
				  WHEN pct.contacted=1 THEN 0
				  ELSE NULL
			END										AS RCMND_CNTCT_IND,
			CASE WHEN IFNULL(cmt.completedtime,0)=0 AND pt.status<>8 THEN 0 
				ELSE 1
			END 									AS cmplt_ind
		FROM ndb.ndb_project_task pt
		LEFT JOIN ndb.ndb_project_consultation_task pct					ON pct.id=pt.id
		LEFT JOIN ndb.ndb_project_task_common ptc 						ON ptc.id=pt.id
		LEFT JOIN ndb.ndb_project_task_common_contact ptcc 				ON ptcc.id=pt.id
		LEFT JOIN ndb.ndb_project_task_payment ptp						ON ptp.taskid=pt.id
		LEFT JOIN ndb.ndb_project_task_receipts ptr						ON ptr.taskid=pt.id
		LEFT JOIN ndb.ndb_consultant_feedback cf 						ON cf.taskid=pt.id
		LEFT JOIN dw_simp.tmp_tb14 p ON IFNULL(pct.consultantid,ptc.consultantid) = p.consultantid
		LEFT JOIN ndb.ndb_consultant_position cp ON cp.id = (CASE WHEN pct.positionid>0 THEN pct.positionid ELSE p.pid END)
		LEFT JOIN ndb.ndb_position_vocabulary pv 						ON pv.id = cp.position
		LEFT JOIN ndb.ndb_company_vocabulary cv 						ON cv.id = cp.company
		LEFT JOIN ndb.ndb_taxonomy_term indstry							ON indstry.id = cv.industry
		LEFT JOIN ndb.ndb_taxonomy_term subindstry						ON subindstry.id = cv.subindustry
		LEFT JOIN ndb.ndb_taxonomy_term indstry2						ON subindstry.parentid=indstry2.id
		LEFT JOIN ndb.ndb_taxonomy_term pctIND ON pctIND.taxonomyid  = 8 AND pctIND.id = pct.industry
		LEFT JOIN dw_simp.tmp_tb15 cmt ON cmt.taskid=pt.id
		LEFT JOIN dw_simp.tmp_tb16 rec ON rec.taskid=pt.id
		LEFT JOIN dw_simp.tmp_tb16 rec1 ON rec1.taskid=pt.id
		LEFT JOIN dw_simp.tmp_tb17 ara ON ara.taskid=pt.id 
		LEFT JOIN dw_simp.tmp_tb17 ara1 ON ara1.taskid=pt.id 
;
TRUNCATE TABLE dw_simp.dw_cnsltnt_err;
TRUNCATE TABLE dw_simp.dw_clnt_err;
TRUNCATE TABLE dw_simp.dw_clnt_cntct_err;
TRUNCATE TABLE dw_simp.dw_prjct_err;
TRUNCATE TABLE dw_simp.dw_prjct_task_err;
INSERT INTO dw_simp.dw_cnsltnt_err
SELECT c.*
FROM dw_simp.dw_cnsltnt c
LEFT JOIN dw_simp.dw_user u ON u.uid=c.USER_CRE_UID
WHERE c.CNSLTNT_NAME LIKE '%test%' OR c.CNSLTNT_NAME LIKE '%测试%' 
	
	OR c.USER_CRE_UID IN (1010,944,856,846,751)
;
INSERT INTO dw_simp.dw_clnt_err
SELECT c.*
FROM dw_simp.dw_clnt c
LEFT JOIN dw_simp.dw_user u ON u.uid=c.USER_CRE_UID
WHERE c.CLNT_NAME LIKE '%test%' 
	OR c.CLNT_NAME LIKE '%virtual client%' 
	OR u.user_eng_name LIKE '%test%' 
	OR c.USER_CRE_UID IN (1010,944,856,846,751)
;
INSERT INTO dw_simp.dw_clnt_cntct_err
SELECT c.*
FROM dw_simp.dw_clnt_cntct c
WHERE CLNT_CNTCT_NAME LIKE '%test%' 
	OR clnt_id IN (SELECT clnt_id FROM dw_simp.dw_clnt_err)
;
INSERT INTO dw_simp.dw_prjct_err
SELECT p.*
FROM dw_simp.dw_prjct p
LEFT JOIN dw_simp.dw_user u ON u.uid=p.USER_CRE_UID
WHERE p.PRJCT_NAME LIKE '%xtest%'
	OR p.PRJCT_NAME LIKE 'Test'
	OR p.PRJCT_NAME REGEXP '^test '
	OR u.user_eng_name LIKE '%test%' 
	OR p.USER_CRE_UID IN (1010,944,856,846,751)
	OR p.CNSLTN_CLNT_ID IN (SELECT clnt_id FROM dw_simp.dw_clnt_err)
	OR p.CNSLTN_CLNT_CNTCT_ID IN (SELECT CLNT_CNTCT_ID FROM dw_simp.dw_clnt_cntct_err)
	OR p.CNSLTN_CLNT_CNTCT_MNGR_ID IN (SELECT CLNT_CNTCT_ID FROM dw_simp.dw_clnt_cntct_err)
;
INSERT INTO dw_simp.dw_prjct_task_err
SELECT pt.* 
FROM dw_simp.dw_prjct_task pt
LEFT JOIN dw_simp.dw_user u ON u.uid=pt.USER_CRE_UID
WHERE  u.user_eng_name LIKE '%test%' 
OR pt.USER_CRE_UID IN (1010,944,856,846,751)
OR pt.CLNT_ID IN (SELECT clnt_id FROM dw_simp.dw_clnt_err)
OR pt.CLNT_CNTCT_ID IN (SELECT CLNT_CNTCT_ID FROM dw_simp.dw_clnt_cntct_err)
OR pt.CNSLTNT_ID IN (SELECT CLNT_CNTCT_ID FROM dw_simp.dw_cnsltnt_err) 
OR pt.PRJCT_ID IN (SELECT PRJCT_ID FROM dw_simp.dw_prjct_err)
;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM dw_simp.dw_cnsltnt WHERE cnsltnt_id IN (SELECT cnsltnt_id FROM dw_simp.dw_cnsltnt_err);
DELETE FROM dw_simp.dw_clnt WHERE clnt_id IN (SELECT clnt_id FROM dw_simp.dw_clnt_err);
DELETE FROM dw_simp.dw_clnt_cntct WHERE clnt_cntct_id IN (SELECT clnt_cntct_id FROM dw_simp.dw_clnt_cntct_err);
DELETE FROM dw_simp.dw_prjct WHERE PRJCT_ID IN (SELECT PRJCT_ID	FROM dw_simp.dw_prjct_err);
DELETE FROM dw_simp.dw_prjct_task WHERE TASK_ID IN (SELECT TASK_ID FROM dw_simp.dw_prjct_task_err);
	
SET SQL_SAFE_UPDATES=0;
UPDATE dw_simp.dw_cnsltnt c
INNER JOIN ndb.ndb_credit_consultant crecon ON crecon.consultantid=c.cnsltnt_id
LEFT JOIN (
		SELECT 
			cl.objectid						AS consultantid
			,SUM(CASE WHEN cl.credit1<0 AND cl.status=1 THEN cl.credit1 ELSE 0 END 	)					AS credit_spent
			,SUM(CASE WHEN cl.credit1>0 AND cl.status=1 THEN cl.credit1 ELSE 0 END 	)					AS credit_earn
		FROM ndb.ndb_credit_log cl 
		WHERE cl.type=1
		GROUP BY cl.objectid
			)cre ON cre.consultantid=c.cnsltnt_id
SET c.CRDT_CNT=crecon.total,
	c.CRDT_SPNT=cre.credit_spent,
	c.CRDT_ERN=cre.credit_earn;
SET sql_safe_updates=0;
UPDATE dw_simp.dw_cnsltnt c
INNER JOIN (
		SELECT 
			SUBSTRING_INDEX(MAX(CONCAT(VALUE,'|',consultantid)),'|',1) AS lasttime
			,SUBSTRING_INDEX(MAX(CONCAT(VALUE,'|',consultantid)),'|',-1) AS consultantid
		FROM ndb.ndb_consultant_profile nf
		WHERE nf.attribute='contact_time'
		GROUP BY consultantid
	)lct ON lct.consultantid=c.CNSLTNT_ID 
SET c.LAST_CNTCT_TS=lct.lasttime;
SET SQL_SAFE_UPDATES=0; 
DELETE
FROM dw_simp.dw_prjct_task
WHERE IFNULL(prjct_id,0)=0 ;
SET sql_safe_updates=0;
UPDATE dw_simp.dw_prjct_task pt
INNER JOIN (
	SELECT task_id
			,(CASE WHEN IFNULL(cmplt_ts,0)=0 AND IFNULL(END_TS,0)<>0 THEN end_ts
				   WHEN IFNULL(cmplt_ts,0)=0 AND IFNULL(END_TS,0)=0 THEN BEG_ts
				ELSE cmplt_ts
			END) AS cmplt_ts
	FROM dw_simp.dw_prjct_task 
)ptcm
SET pt.cmplt_ts=ptcm.cmplt_ts
WHERE pt.task_id=ptcm.task_id;
	
SET sql_safe_updates=0;
UPDATE dw_simp.dw_prjct_task  pt 
INNER JOIN (
	SELECT pt1.cnsltnt_id
			,SUBSTRING_INDEX(MIN(CONCAT(CMPLT_TS,'|',task_id)),'|',1) AS cmplt_ts
			,SUBSTRING_INDEX(MIN(CONCAT(CMPLT_TS,'|',task_id)),'|',-1)AS taskid
	FROM dw_simp.dw_prjct_task pt1 
	WHERE pt1.task_sts_cd=8
	GROUP BY pt1.cnsltnt_id
) fc 
SET CNSLTNT_FIRST_CALL_IND=1 
WHERE pt.task_id=fc.taskid AND fc.cnsltnt_id=pt.cnsltnt_id
;
SET sql_safe_updates=0;
UPDATE dw_simp.dw_prjct p
INNER JOIN (SELECT pt.prjct_id
			,SUM(CASE WHEN RCMND_IND=1 THEN 1 ELSE 0 END) 		AS RCMND_TASK_CNT
			,SUM(CASE WHEN ARNG_IND=1 THEN 1 ELSE 0 END) 			AS ARNG_TASK_CNT
			,SUM(CASE WHEN task_sts_cd=8 THEN 1 ELSE 0 END) 			AS CMPLT_TASK_CNT	
			,COUNT(DISTINCT CASE WHEN RCMND_IND=1 THEN cnsltnt_id END) 		AS RCMND_CNSLTNT_CNT
			,COUNT(DISTINCT CASE WHEN ARNG_IND=1 THEN cnsltnt_id END) 		AS ARNG_CNSLTNT_CNT
			,COUNT(DISTINCT CASE WHEN task_sts_cd=8 THEN cnsltnt_id END) 			AS CMPLT_CNSLTNT_CNT
			,SUM(pt.CNSLTNT_HR)												AS CNSLTNT_HR
			FROM dw_simp.dw_prjct_task pt
			GROUP BY pt.prjct_id
			) num
SET p.RCMND_TASK_CNT=num.RCMND_TASK_CNT,
	p.ARNG_TASK_CNT=num.ARNG_TASK_CNT,
	p.CMPLT_TASK_CNT=num.CMPLT_TASK_CNT,
	p.RCMND_CNSLTNT_CNT=num.RCMND_CNSLTNT_CNT,
	p.ARNG_CNSLTNT_CNT=num.ARNG_CNSLTNT_CNT,
	p.CMPLT_CNSLTNT_CNT=num.CMPLT_CNSLTNT_CNT,
	p.CNSLTNT_HR=num.CNSLTNT_HR
WHERE num.prjct_id=p.prjct_id;
SET sql_safe_updates=0;
UPDATE dw_simp.dw_prjct p
INNER JOIN (SELECT pt.prjct_id
			,SUM(CASE WHEN task_sts_cd IN (6,7,8) THEN 1 ELSE 0 END) 		AS RCMND_TASK_CNT
			,SUM(CASE WHEN task_sts_cd IN (7,8) THEN 1 ELSE 0 END) 			AS ARNG_TASK_CNT
			,SUM(CASE WHEN task_sts_cd IN (8) THEN 1 ELSE 0 END) 			AS CMPLT_TASK_CNT	
			,COUNT(DISTINCT CASE WHEN task_sts_cd IN (6,7,8) THEN cnsltnt_id END) 		AS RCMND_CNSLTNT_CNT
			,COUNT(DISTINCT CASE WHEN task_sts_cd IN (7,8) THEN cnsltnt_id END) 		AS ARNG_CNSLTNT_CNT
			,COUNT(DISTINCT CASE WHEN task_sts_cd IN (8) THEN cnsltnt_id END) 			AS CMPLT_CNSLTNT_CNT
			,SUM(CASE WHEN task_sts_cd IN (8) THEN pt.CNSLTNT_HR END)					AS CNSLTNT_HR
			FROM dw_simp.dw_prjct_task pt
			GROUP BY pt.prjct_id
			) num
SET p.RCMND_TASK_CNT=num.RCMND_TASK_CNT,
	p.ARNG_TASK_CNT=num.ARNG_TASK_CNT,
	p.CMPLT_TASK_CNT=num.CMPLT_TASK_CNT,
	p.RCMND_CNSLTNT_CNT=num.RCMND_CNSLTNT_CNT,
	p.ARNG_CNSLTNT_CNT=num.ARNG_CNSLTNT_CNT,
	p.CMPLT_CNSLTNT_CNT=num.CMPLT_CNSLTNT_CNT,
	p.CNSLTNT_HR=num.CNSLTNT_HR
WHERE num.prjct_id=p.prjct_id;
ALTER TABLE dw_simp.tmp_tb1 DROP INDEX ix_consultantid;
ALTER TABLE dw_simp.tmp_tb2 DROP INDEX ix_CNSLTNT_ID;
ALTER TABLE dw_simp.tmp_tb3 DROP INDEX ix_cnsltnt_id;
ALTER TABLE dw_simp.tmp_tb4 DROP INDEX ix_ndb_id;
ALTER TABLE dw_simp.tmp_tb5 DROP INDEX ix_id;
ALTER TABLE dw_simp.tmp_tb6 DROP INDEX ix_consultantid;
ALTER TABLE dw_simp.tmp_tb7 DROP INDEX ix_consultantid;
ALTER TABLE dw_simp.tmp_tb8 DROP INDEX ix_projectid;
ALTER TABLE dw_simp.tmp_tb9 DROP INDEX ix_projectid;
ALTER TABLE dw_simp.tmp_tb10 DROP INDEX ix_projectid;
ALTER TABLE dw_simp.tmp_tb12 DROP INDEX ix_projectid;
ALTER TABLE dw_simp.tmp_tb13 DROP INDEX ix_projectid;
ALTER TABLE dw_simp.tmp_tb11   DROP INDEX ix_id;
ALTER TABLE dw_simp.tmp_tb14 DROP INDEX ix_consultantid;
ALTER TABLE dw_simp.tmp_tb15 DROP INDEX ix_taskid;
ALTER TABLE dw_simp.tmp_tb16 DROP INDEX ix_taskid;
ALTER TABLE dw_simp.tmp_tb17 DROP INDEX ix_taskid;
DROP TABLE IF EXISTS dw_simp.tmp_tb1;
DROP TABLE IF EXISTS dw_simp.tmp_tb2;
DROP TABLE IF EXISTS dw_simp.tmp_tb3;
DROP TABLE IF EXISTS dw_simp.tmp_tb4;
DROP TABLE IF EXISTS dw_simp.tmp_tb5;
DROP TABLE IF EXISTS dw_simp.tmp_tb6;
DROP TABLE IF EXISTS dw_simp.tmp_tb7;
DROP TABLE IF EXISTS dw_simp.tmp_tb8;
DROP TABLE IF EXISTS dw_simp.tmp_tb9;
DROP TABLE IF EXISTS dw_simp.tmp_tb10;
DROP TABLE IF EXISTS dw_simp.tmp_tb11;
DROP TABLE IF EXISTS dw_simp.tmp_tb12;
DROP TABLE IF EXISTS dw_simp.tmp_tb13;
DROP TABLE IF EXISTS dw_simp.tmp_tb14;
DROP TABLE IF EXISTS dw_simp.tmp_tb15;
DROP TABLE IF EXISTS dw_simp.tmp_tb16;
DROP TABLE IF EXISTS dw_simp.tmp_tb17;
END$$

DELIMITER ;