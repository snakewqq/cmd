SELECT COUNT(*) FROM client_contact_tele60$ a,capweb_user b
WHERE a.contact_email = b.email AND b.`status` = 1

UPDATE client_contact_tele60$ a,capweb_user b
SET b.`status` = 0
WHERE a.contact_email = b.email

UPDATE capweb_user
SET STATUS=0
WHERE STATUS=1

CREATE TABLE tmp_block_id
AS 
SELECT id FROM capweb_user
WHERE `STATUS`=1
