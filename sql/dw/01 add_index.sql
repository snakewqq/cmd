DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `add_index`$$

CREATE DEFINER=`admin`@`%` PROCEDURE `add_index`(IN tab_name VARCHAR(100) ,IN idx_name VARCHAR(100),IN idx_column_name VARCHAR(100))
BEGIN

DECLARE str VARCHAR(250);  
  SET @str=CONCAT(' alter table ',tab_name,' add index ',idx_name,'(',idx_column_name,')');   
    #f
  SELECT COUNT(*) INTO @cnt FROM information_schema.statistics WHERE table_name=tab_name AND index_name=idx_name ;  
  IF @cnt<=0 THEN   
    PREPARE stmt FROM @str;  
    EXECUTE stmt ;  
  END IF;  

END$$

DELIMITER ;