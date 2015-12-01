/*
spring - 最近1月官网注册了多少用户
*/

SELECT DATE(FROM_UNIXTIME(registertime)),COUNT(*) FROM capweb_user 
WHERE registertime BETWEEN UNIX_TIMESTAMP('2015-10-31') AND UNIX_TIMESTAMP('2015-11-30')
GROUP BY DATE(FROM_UNIXTIME(registertime))
ORDER BY DATE(FROM_UNIXTIME(registertime)) ASC


/*
spring - 最近1月的登录用户数
*/

SELECT *,FROM_UNIXTIME(lastlogintime) FROM capweb_user ORDER BY id DESC

SELECT DATE(FROM_UNIXTIME(lastlogintime)),COUNT(*) FROM capweb_user 
WHERE lastlogintime BETWEEN UNIX_TIMESTAMP('2015-10-31') AND UNIX_TIMESTAMP('2015-11-30')
GROUP BY DATE(FROM_UNIXTIME(lastlogintime))
ORDER BY DATE(FROM_UNIXTIME(lastlogintime)) ASC