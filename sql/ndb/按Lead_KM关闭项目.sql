/*按Lead_KM关闭项目*/
SELECT a.`projectid`,b.`englishname` AS 'Project Manager',c.name  FROM ndb_project_team a,ndb_employees b,ndb_project c
WHERE a.role = 2 AND a.uid = b.id AND b.`englishname` IN('Han Zhou','Fay Du','Wade Liu','Wenjuan Li')
AND a.projectid = c.id AND c.`status` = 1


SELECT a.`projectid`,b.`englishname` AS 'Project Manager',c.name  FROM ndb_project_team a,ndb_employees b,ndb_project c \
WHERE a.role = 2 AND a.uid = b.id AND b.`englishname` IN('Han Zhou','Fay Du','Wade Liu','Wenjuan Li') \
AND a.projectid = c.id AND c.`status` = 1 \
INTO OUTFILE '/tmp/anisa_1019.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';