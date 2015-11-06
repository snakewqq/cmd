SELECT * FROM ndb_location WHERE NAME LIKE '%上海%' LIMIT 10;

SELECT a.id,a.name,b.name FROM ndb_consultant a, ndb_location b
WHERE a.locationsource > 0 AND a.`locationsource` = b.`id`
LIMIT 10;

SELECT a.*,b.id,b.name,b.shortname FROM tmp2 a
LEFT JOIN ndb_location b
ON a.`location_name` = b.name;

UPDATE tmp2 a,ndb_location b
SET a.location_id = b.id
WHERE a.`location_name` = b.name;

SELECT a.*,b.locationsource FROM tmp2 a,ndb_consultant b
WHERE a.`consultant_id` = b.`id`

UPDATE tmp2 a,ndb_consultant b
SET b.`locationsource` = a.`location_id`
WHERE a.`consultant_id` = b.`id`

DROP TABLE tmp_1014

SELECT id,NAME,shortname FROM ndb_location WHERE NAME LIKE '%海西蒙%'