/*
该task的状态
1 -> Not Contacted
6 -> Recommended
18-> selected
7 -> Arranged
8 -> Completed
12 -> test
13 -> Client canceled
14 -> consultant canceled
9 -> Not interviewed
10 -> Unsuccessful interview
15 -> consultant not familiar
16 -> consultant refused
17 -> Rescheduled
0 -> deleted
19 -> interview completed
20 -> pending
*/

SELECT b.status,a.*,b.* FROM ndb_project_consultation_task a, ndb_project_task b 
WHERE a.id = b.id AND a.id = 342822

UPDATE ndb_project_task
SET `status` = 7
WHERE id = 342822
