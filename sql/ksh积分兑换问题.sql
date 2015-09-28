SELECT * FROM vesta_consultant WHERE mobile = '13671505414';

SELECT * FROM vesta_user WHERE id = 21472;

email:zyfjx99@163.com
PASSWORD:C@pvisi0n

--21472 26db954a8fbf1dd881a0fcd796359cfb30b2ff60
--admin 7ad2cd3cfd13c9cea83ad7b64ee0e5b37060e716

--admin
UPDATE vesta_user
SET PASSWORD = '7ad2cd3cfd13c9cea83ad7b64ee0e5b37060e716'
WHERE id = 21472

--user
UPDATE vesta_user
SET PASSWORD = '26db954a8fbf1dd881a0fcd796359cfb30b2ff60'
WHERE id = 21472

SELECT * FROM vesta_user WHERE USER = 'admin';