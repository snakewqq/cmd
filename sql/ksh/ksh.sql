SELECT * FROM vesta_consultant WHERE id = 21472;

SELECT * FROM vesta_user WHERE id = 21472;
SELECT * FROM vesta_user WHERE email = 'admin@capvision.com';

UPDATE vesta_user
SET `password` = '26db954a8fbf1dd881a0fcd796359cfb30b2ff60'
WHERE id = 21472;

UPDATE vesta_user
SET `password` = '7ad2cd3cfd13c9cea83ad7b64ee0e5b37060e716'
WHERE id = 21472;

SELECT * FROM vesta_user ORDER BY id ASC LIMIT 10;

skyzhang@capvision.com
id:9

UPDATE vesta_user
SET `password` = '905432eec3d7e16baf050b706a732b97954b5f70'
WHERE id = 9;

UPDATE vesta_user
SET `password` = '7ad2cd3cfd13c9cea83ad7b64ee0e5b37060e716'
WHERE id = 9;