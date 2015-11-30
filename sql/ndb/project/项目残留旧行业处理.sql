SELECT COUNT(*) FROM ndb_view_report_invoicing WHERE project_industryid =0

SELECT industryid,COUNT(*) FROM ndb_project
WHERE industryid > 0 AND industryid < 1000
GROUP BY industryid
ORDER BY industryid

SELECT * FROM tmp_industry_company ORDER BY old_id

SELECT * FROM tmp_industry ORDER BY old_id

SELECT a.industryid,COUNT(*) FROM ndb_project a, tmp_industry_company b 
WHERE a.industryid = b.old_id AND a.industryid > 0 AND a.industryid < 1000 
GROUP BY a.industryid
ORDER BY a.industryid

UPDATE ndb_project a, tmp_industry_company b 
SET a.industryid = b.id
WHERE a.industryid = b.old_id AND a.industryid > 0 AND a.industryid < 1000 

SELECT * FROM ndb_project

UPDATE ndb_project a, tmp_industry b 
SET a.industryid = b.id
WHERE a.industryid = b.old_id AND a.industryid > 0 AND a.industryid < 1000 