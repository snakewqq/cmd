DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `proc_Ana_paidconsultant`$$

CREATE DEFINER=`root`@`%` PROCEDURE `proc_Ana_paidconsultant`()
BEGIN

DROP TABLE IF EXISTS  dw_simp.tmp_dw_prjct_task_luken ;
CREATE TABLE dw_simp.tmp_dw_prjct_task_luken AS 
SELECT a.cnsltnt_id,    prjct_id,    MIN(DATE(FROM_UNIXTIME(beg_ts))) AS beg_ts,
    MIN(CASE        WHEN first_rcmnd_dt IS NOT NULL THEN first_rcmnd_dt        ELSE FIRST_ARNG_DT    END) first_rcmnd_dt,
    COUNT(*) paytimes 
FROM    dw_prjct_task a
WHERE    CNSLTNT_PAY_IND >= 0        AND DATE(FROM_UNIXTIME(end_ts)) > '2014-01-01'
GROUP BY a.cnsltnt_id;

ALTER TABLE dw_simp.tmp_dw_prjct_task_luken ADD INDEX ix1(cnsltnt_id); 
ALTER TABLE dw_simp.tmp_dw_prjct_task_luken ADD INDEX ix2(prjct_id); 
ALTER TABLE dw_simp.tmp_dw_prjct_task_luken ADD COLUMN project_categ VARCHAR(16);

SET sql_safe_updates=0;
UPDATE dw_simp.tmp_dw_prjct_task_luken a,    dw_prjct b 
SET     a.project_categ = 'consul'
WHERE    b.PRJCT_CTGRY_CD IN (1 , 12, 16)        AND a.prjct_id = b.prjct_id;

SELECT     COUNT(*) FROM    dw_simp.tmp_dw_prjct_task_luken;
SELECT     COUNT(*) FROM     dw_simp.tmp_dw_prjct_task_luken WHERE     project_categ = 'consul';


DROP TABLE IF EXISTS dw_simp.tmp_dw_consultant_luken ;
CREATE TABLE dw_simp.tmp_dw_consultant_luken AS 
SELECT cnsltnt_id,DATE(FROM_UNIXTIME(user_cre_ts))  createday FROM dw_cnsltnt ; 
ALTER TABLE dw_simp.tmp_dw_consultant_luken ADD INDEX ix1(cnsltnt_id); 

SELECT COUNT(DISTINCT b.cnsltnt_id),COUNT(*),SUM(a.paytimes)  FROM   dw_simp.tmp_dw_prjct_task_luken a , dw_simp.tmp_dw_consultant_luken b WHERE a.cnsltnt_id = b.cnsltnt_id 
AND a.cnsltnt_id = b.cnsltnt_id AND b.createday>'2014-01-01'  AND a.first_rcmnd_dt IS NOT NULL AND DATEDIFF(a.first_rcmnd_dt,b.createday)>14 LIMIT 10;


SELECT COUNT(DISTINCT b.cnsltnt_id),COUNT(*),SUM(a.paytimes) FROM   dw_simp.tmp_dw_prjct_task_luken a , dw_simp.tmp_dw_consultant_luken b WHERE a.cnsltnt_id = b.cnsltnt_id 
AND a.cnsltnt_id = b.cnsltnt_id AND b.createday<'2015-01-01'  AND b.createday > '2014-01-01' ;

END$$

DELIMITER ;