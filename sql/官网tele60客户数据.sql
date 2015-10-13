/*官网tele60客户数据*/
SELECT 
id AS table_id,
am_name AS client_am,
client_company_name AS `client`,
client_name AS client_contact_name,
am_team,
location,
`status` AS client_status,
email AS client_contact_email
FROM capweb_edm_email_industry 
WHERE am_team = 'PE/C';

SELECT DISTINCT am_team FROM capweb_edm_email_industry;

SELECT \
id AS table_id, \
am_name AS client_am, \
client_company_name AS `client`, \
client_name AS client_contact_name, \
am_team, \
location, \
`status` AS client_status, \
email AS client_contact_email \
FROM capweb_edm_email_industry  \
/*WHERE am_team = 'PE/C' \*/
INTO OUTFILE '/tmp/tele60_all.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';