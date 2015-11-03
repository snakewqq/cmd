/*
Tele60报名参加人员
    const STATUS_PENDING = 0;
    const STATUS_PASSED = 1;
    const STATUS_NOPASS = 2;
    const STATUS_MAILED = 3;
    const STATUS_REALATTEND = 4;
*/

SELECT 
e.title,
eu.email,
eu.name, 
CASE eu.status 
    WHEN 0 THEN 'pending'
    WHEN 1 THEN 'passed'
    WHEN 2 THEN 'nopass'
    WHEN 3 THEN 'mailed'
    WHEN 4 THEN 'real_attend'
END AS `status`
FROM capweb_event_user eu 
INNER JOIN capweb_event e ON e.id = eu.eventid
AND FROM_UNIXTIME(e.starttime) BETWEEN '2015-10-26 00:00:00' AND '2015-10-31 23:59:59'


SELECT \
e.title, \
eu.email, \
eu.name, \
CASE eu.status \
    WHEN 0 THEN 'pending' \
    WHEN 1 THEN 'passed' \
    WHEN 2 THEN 'nopass' \
    WHEN 3 THEN 'mailed' \
    WHEN 4 THEN 'real_attend' \
END AS `status` \
FROM capweb_event_user eu  \
INNER JOIN capweb_event e ON e.id = eu.eventid \
AND FROM_UNIXTIME(e.starttime) BETWEEN '2015-10-26 00:00:00' AND '2015-10-31 23:59:59' \
INTO OUTFILE '/tmp/tele60_signup_1026-1030.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';

/*
select * from capweb_event where from_unixtime(starttime) between '2015-10-26 00:00:00' and '2015-10-31 23:59:59'
select * from capweb_event_user order by id desc limit 10;
*/