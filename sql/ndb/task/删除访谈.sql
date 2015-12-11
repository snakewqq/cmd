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
删除的sql  (软删除)
*/

UPDATE ndb_project_task SET STATUS = 0 WHERE id IN (354284,354291);

Task ID: 343286
Task ID: 343121



