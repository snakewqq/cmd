SELECT * FROM vesta_user ORDER BY id DESC LIMIT 10;

--admin@capvision.com/111111
UPDATE vesta_user 
SET `password`='888f4cff3ffad70d6a7d01ce1a49c48ae396dbc4'
WHERE email = 'capvision083@163.com';

--
UPDATE vesta_user 
SET `password`='b7ad0bc621c870b743d1dd97e87afc51d23e11fd'
WHERE email = 'capvision083@163.com';