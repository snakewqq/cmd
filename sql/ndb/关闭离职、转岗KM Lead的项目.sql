原Berlin team的成员名单
Amos Turin
Anthony Roland Duke
Emma.Benitez
Robert Guterma
Jonas Dordje Reissinger
Kamila Kowenzowska
Tania Esposito
Julie Zhou
Niall McFadden
Olga Ilieska

原APAC Team的成员名单
Jessie Xing
Ping P. Hendra
Ann Yuan

TMT组已经离职人员：
Han Zhou
Fay Du
Wade Liu
Wenjuan Li


SELECT * FROM ndb_employees WHERE englishname IN ('Amos Turin',
'Anthony Roland Duke',
'Emma.Benitez',
'Robert Guterma',
'Jonas Dordje Reissinger',
'Kamila Kowenzowska',
'Tania Esposito',
'Julie Zhou',
'Niall McFadden',
'Olga Ilieska',
'Jessie Xing',
'Ping P. Hendra',
'Ann Yuan',
'Han Zhou',
'Fay Du',
'Wade Liu',
'Wenjuan Li')


SELECT a.`projectid`,b.`englishname` AS 'Project Manager',c.name  
FROM ndb_project_team a,ndb_employees b,ndb_project c
WHERE a.role = 2 AND a.uid = b.id AND b.`englishname` IN('Amos Turin',
'Anthony Roland Duke',
'Emma.Benitez',
'Robert Guterma',
'Jonas Dordje Reissinger',
'Kamila Kowenzowska',
'Tania Esposito',
'Julie Zhou',
'Niall McFadden',
'Olga Ilieska',
'Jessie Xing',
'Ping P. Hendra',
'Ann Yuan',
'Han Zhou',
'Fay Du',
'Wade Liu',
'Wenjuan Li')
AND a.projectid = c.id AND c.`status` = 1

UPDATE ndb_project_team a,ndb_employees b,ndb_project c
SET c.`status` = 3
WHERE a.role = 2 AND a.uid = b.id AND b.`englishname` IN('Amos Turin',
'Anthony Roland Duke',
'Emma.Benitez',
'Robert Guterma',
'Jonas Dordje Reissinger',
'Kamila Kowenzowska',
'Tania Esposito',
'Julie Zhou',
'Niall McFadden',
'Olga Ilieska',
'Jessie Xing',
'Ping P. Hendra',
'Ann Yuan',
'Han Zhou',
'Fay Du',
'Wade Liu',
'Wenjuan Li')
AND a.projectid = c.id AND c.`status` = 1

