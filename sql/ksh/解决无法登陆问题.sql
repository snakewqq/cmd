SELECT * FROM vesta_user WHERE email='kaven1225@163.com'

add0151ec4a1df52ca396d1877b42977f9927332

/*密码设置*/
UPDATE vesta_user 
SET PASSWORD='7ad2cd3cfd13c9cea83ad7b64ee0e5b37060e716'
WHERE email='kaven1225@163.com'

/*恢复*/
UPDATE vesta_user 
SET PASSWORD='add0151ec4a1df52ca396d1877b42977f9927332'
WHERE email='kaven1225@163.com'
