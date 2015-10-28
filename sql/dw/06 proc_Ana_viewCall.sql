DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `proc_Ana_viewCall`$$

CREATE DEFINER=`root`@`%` PROCEDURE `proc_Ana_viewCall`()
BEGIN
	SET sql_safe_updates=0;
	DROP TABLE IF EXISTS  dw_simp.tmp_byday_byuser_viewnum ;
	CREATE TABLE dw_simp.tmp_byday_byuser_viewnum AS 
	SELECT  DATE(FROM_UNIXTIME(`time`)) viewday,uid,user_name,COUNT(*) viewnum FROM ndb.ndb_log WHERE ACTION = 'view contact information' AND `time` >= 1430409600  GROUP BY  DATE(FROM_UNIXTIME(`time`)) ,uid,user_name
	ORDER  BY  viewday  ;

	

	

	DROP TABLE IF EXISTS dw_simp.tmp_byday_byuser_callnum ;
	CREATE TABLE dw_simp.tmp_byday_byuser_callnum AS 
	SELECT  DATE(FROM_UNIXTIME(`datetimeconnect`)) callday,fromEmployeeName user_name,COUNT(*) callnum FROM ndb.ndb_call_manager_log 
	WHERE `datetimeconnect` >= 1430409600  GROUP BY  DATE(FROM_UNIXTIME(`datetimeconnect`)) ,fromEmployeeName
	ORDER  BY  callday  ;

	SELECT * FROM  tmp_byday_byuser_viewnum a,tmp_byday_byuser_callnum b WHERE a.user_name =b.user_name AND a.viewday =b.callday LIMIT 10;


END$$

DELIMITER ;