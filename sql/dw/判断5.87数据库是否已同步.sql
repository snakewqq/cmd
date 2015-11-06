/*
判断5.87数据库是否已同步
*/

/*
1. ndb
*/
SELECT id,FROM_UNIXTIME(CRE_DT) FROM ndb.ndb_project ORDER BY id DESC;

/*
2. dw_simp
*/
SELECT
			 *
	FROM ndb.ndb_project p
	LEFT JOIN dw_simp.tmp_tb8 qu ON qu.projectid=p.id
	LEFT JOIN ndb.ndb_taxonomy_term ntt ON ntt.id=p.industryid AND ntt.taxonomyid=1
	LEFT JOIN ndb.ndb_taxonomy_term ntt1 ON ntt1.id=ntt.parentid AND ntt1.taxonomyid=1
	LEFT JOIN ndb.ndb_project_consultation pco ON pco.id=p.id
	LEFT JOIN ndb.ndb_project_feedback pfe ON pfe.projectid=p.id
	LEFT JOIN dw_simp.tmp_tb9 ppro ON ppro.projectid=p.id
	#LEFT JOIN ndb.ndb_project_client pclnt ON pclnt.projectid = p.id
	#LEFT JOIN dw_simp.tmp_tb10 pccon ON pccon.projectid=p.id
	#LEFT JOIN dw_simp.tmp_tb12 pccmanager ON pccmanager.projectid=p.id
	#LEFT JOIN dw_simp.tmp_tb13 pumanager ON pumanager.projectid=p.id
	WHERE p.id = 158562
	
	/*
	
	SELECT *,FROM_UNIXTIME(CRE_DT),FROM_UNIXTIME(UPD_TS) FROM ndb.ndb_project_client WHERE projectid IN( 158562,158564,158568)
	
	DELETE FROM ndb.ndb_project_client WHERE id IN (35669,35672,35675)
	
	SELECT projectid,clientid,COUNT(*) FROM ndb.ndb_project_client
	GROUP BY projectid,clientid 
	HAVING COUNT(*) > 1
	*/
	

/*
3. 手工执行同步
*/

CALL update_dw_table();
CALL create_view_table_proc();
CALL proc_clnt_quota();
CALL client_project_activity();
	
	
	
