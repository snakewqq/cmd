/*
麻烦发我看看，顾问要顾问ID、顾问名，顾问状态、手机号
顾问的状态
1-> Enrolled（已登记）
2-> Communicated（已联系）
3-> Not Contacted（未联系）
4-> Prospect（待争取）
5-> Invalid（联系方式无效）
6-> Blacklist（黑名单）
*/

/*
select * from ndb_taxonomy_term where taxonomyid = 1 and id=94

select b.industry from ndb_consultant_position a, ndb_company_vocabulary b
where a.company = b.id and a.consultantid = 47006

select countryid,province,city from ndb_consultant where id=47006

select * from ndb_location where id in (12,88,933)

SELECT 
#c.mobile,LENGTH(trim(c.mobile)) as len 
COUNT(*)
FROM ndb_consultant a, ndb_contacts b, ndb_contact_mobile c  
WHERE a.id = b.objectid AND b.contactid = c.id AND b.contacttype=1 AND b.type=1 AND LENGTH(TRIM(c.mobile)) > 12 
	
SELECT LENGTH('	13488658280')

select * from ndb_consultant order by id desc limit 10;

select * from ndb_taxonomy where id = 1
select * from ndb_taxonomy_term where taxonomyid = 1
*/


SELECT 
a.id AS consultant_id, 
a.name AS consultant_name,
CASE a.status   
    WHEN 1 THEN 'Enrolled（已登记）'  
    WHEN 2 THEN 'Communicated（已联系）'  
    WHEN 3 THEN 'Not Contacted（未联系）'  
    WHEN 4 THEN 'Prospect（待争取）'
    WHEN 5 THEN 'Invalid（联系方式无效）'
    WHEN 6 THEN 'Blacklist（黑名单）'
END   
AS consultant_status,
c.mobile AS consultant_mobile,
g.name AS industry_name,
CONCAT(l1.name,'-',l2.name,'-',l3.name) AS location
FROM ndb_consultant a
INNER JOIN ndb_contacts b ON a.id = b.objectid 
INNER JOIN ndb_contact_mobile c ON b.contactid = c.id AND b.contacttype=1 AND b.type=1 
INNER JOIN (  
	SELECT c.mobile,COUNT(*) FROM ndb_consultant a, ndb_contacts b, ndb_contact_mobile c  
	WHERE a.id = b.objectid AND b.contactid = c.id AND b.contacttype=1 AND b.type=1
	GROUP BY c.mobile  
	HAVING COUNT(*) > 1) d ON c.mobile = d.mobile 
INNER JOIN ndb_consultant_position e ON a.id = e.consultantid
INNER JOIN ndb_company_vocabulary f ON  e.company=f.id
INNER JOIN ndb_taxonomy_term g ON f.industry=g.id
LEFT JOIN ndb_location l1 ON a.countryid = l1.id
LEFT JOIN ndb_location l2 ON a.province = l2.id
LEFT JOIN ndb_location l3 ON a.city = l3.id
INTO OUTFILE '/tmp/spring_consultant_mobile_duplicate_3.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';


