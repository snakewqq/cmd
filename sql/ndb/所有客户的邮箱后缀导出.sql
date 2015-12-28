DELIMITER $$    
DROP FUNCTION IF EXISTS `func_splitString` $$    
CREATE FUNCTION `func_splitString`    
( f_string VARCHAR(1000),f_delimiter VARCHAR(5),f_order INT)   
  RETURNS VARCHAR(255) CHARSET utf8    
BEGIN    
    DECLARE result VARCHAR(255) DEFAULT '';    
    SET result = REVERSE(SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(f_string,f_delimiter,f_order)),f_delimiter,1));    
    RETURN result;    
END$$  

#############################################################################

SELECT DISTINCT(contact_domain) FROM (
SELECT 
func_splitString(c.value,'@',2) AS contact_domain
FROM ndb_contact_others c 
INNER JOIN ndb_contacts b ON b.contactid = c.`id` AND b.contacttype =9 AND b.type =2
INNER JOIN ndb_client_contact a ON a.id = b.`objectid` AND a.tele60=1 AND a.status=1
INNER JOIN ndb_client d ON a.clientid=d.id
INNER JOIN ndb_taxonomy_term e ON d.`amteamid` = e.`id`
INNER JOIN ndb_taxonomy f ON e.taxonomyid = f.id AND f.`name` = 'CLIENT AM LIST'
) a;