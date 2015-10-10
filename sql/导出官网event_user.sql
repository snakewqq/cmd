SELECT b.title, a.name,a.email,FROM_UNIXTIME(a.time),c.`chinesename`,a.status 
FROM capweb_event_user a, capweb_event b, capweb_user c 
WHERE a.`eventid` = b.`id` AND a.uid = c.`id` AND a.`email` NOT LIKE '%capvision.com%' 
ORDER BY b.id DESC, a.time DESC 
INTO OUTFILE '/tmp/event_user.csv' FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '' LINES TERMINATED BY '\n';

SELECT b.title, a.name,a.email,FROM_UNIXTIME(a.time),c.`chinesename`,a.status \
FROM capweb_event_user a, capweb_event b, capweb_user c \
WHERE a.`eventid` = b.`id` AND a.uid = c.`id` AND a.`email` NOT LIKE '%capvision.com%' \
ORDER BY b.id DESC, a.time DESC \
INTO OUTFILE '/tmp/event_user.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';