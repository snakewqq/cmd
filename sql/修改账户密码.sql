SELECT * FROM sms_user LIMIT 10;

UPDATE sms_user
SET `password` = 'a310e5b12bb3b09a5f3c3a8fe702c790',
    salt = 'f02866'
WHERE id = 1;

SELECT * FROM ndb_user LIMIT 10;

UPDATE ndb_user
SET `password` = 'a310e5b12bb3b09a5f3c3a8fe702c790',
    salt = 'f02866'
WHERE id = 1;


--123456
a310e5b12bb3b09a5f3c3a8fe702c790   
f02866


2019416238ee0ba775c0e5d0a14a9077
014034