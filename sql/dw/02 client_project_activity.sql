DELIMITER $$

USE `dw_simp`$$

DROP PROCEDURE IF EXISTS `client_project_activity`$$

CREATE DEFINER=`root`@`%` PROCEDURE `client_project_activity`()
BEGIN





#alter table `dw_simp`.`v_clnt_cntct` add index ix_CLNT_ID(CLNT_ID);
#alter table `dw_simp`.`v_clnt` add index ix_CLNT_ID(CLNT_ID);
#alter table `dw_simp`.`v_prjct_task` add index ix_CLNT_CNTCT_ID(CLNT_CNTCT_ID);
#alter table `dw_simp`.`v_prjct` add index ix_PRJCT_ID(PRJCT_ID);
CALL dw_simp.add_index('v_clnt_cntct','ix_CLNT_ID','CLNT_ID');
CALL dw_simp.add_index('v_clnt','ix_CLNT_ID','CLNT_ID');
CALL dw_simp.add_index('v_prjct_task','ix_CLNT_CNTCT_ID','CLNT_CNTCT_ID');
CALL dw_simp.add_index('v_prjct','ix_PRJCT_ID','PRJCT_ID');



DROP TABLE IF EXISTS dw_simp.client_project_activity;
CREATE TABLE   dw_simp.client_project_activity AS  SELECT 
        `pt`.`BEG_DT` AS `TASK_BEG_DT`,
        `p`.`BEG_DT` AS `Project_Beg_DT`,
        `cl`.`CLNT_TYPE_NAME` AS `Client_Type`,
        `cl`.`CLNT_NAME` AS `Client_Name`,
        `cc`.`CLNT_CNTCT_NAME` AS `Analyst_Name`,
        `cl`.`CLNT_TEAM` AS `Client_Team`,
        `pt`.`CNSLTNT_HR` AS `Consultant_Hour`,
        `pt`.`CLNT_HR` AS `Client_Hour`,
        `pt`.`TASK_ID` AS `TASK_ID`,
        `p`.`PRJCT_ID` AS `Project_ID`,
        (CASE
            WHEN
                ((`p`.`SKM_NAME` = 'Wei Zhu')
                    AND (`p`.`INDSTRY_ID` IN (1 , 26)))
            THEN
                'Wei-F&A'
            ELSE `p`.`SKM_NAME`
        END) AS `SKM_NAME`,
        `p`.`PM_NAME` AS `KM_NAME`,
        `pt`.`RCMND_IND` AS `Recommend_Count`,
        `pt`.`ARNG_IND` AS `Arrange_Count`,
        `pt`.`CMPLT_IND` AS `Complete_Count`,
        (CASE
            WHEN (`p`.`INDSTRY_ID` = 1) THEN '农业'
            WHEN (`p`.`INDSTRY_ID` = 9) THEN '环保'
            WHEN (`p`.`INDSTRY_ID` = 14) THEN '宏观战略'
            WHEN (`p`.`INDSTRY_ID` = 21) THEN '医疗'
            WHEN (`p`.`INDSTRY_ID` = 26) THEN '食品饮料'
            WHEN (`p`.`INDSTRY_ID` = 31) THEN '消费零售'
            WHEN (`p`.`INDSTRY_ID` = 46) THEN '能源'
            WHEN (`p`.`INDSTRY_ID` = 54) THEN '网络技术'
            WHEN (`p`.`INDSTRY_ID` = 73) THEN '房地产'
            WHEN (`p`.`INDSTRY_ID` = 78) THEN '工业制造'
            WHEN (`p`.`INDSTRY_ID` = 81) THEN '化学产品'
            WHEN (`p`.`INDSTRY_ID` = 84) THEN '金属&采矿'
            WHEN (`p`.`INDSTRY_ID` = 90) THEN '航空'
            WHEN (`p`.`INDSTRY_ID` = 94) THEN '交通运输'
            ELSE ''
        END) AS `Project_Industry_level1`,
        (CASE
            WHEN (`p`.`SUBINDSTRY_ID` = 2) THEN '种植业'
            WHEN (`p`.`SUBINDSTRY_ID` = 3) THEN '农、林、牧、渔服务业'
            WHEN (`p`.`SUBINDSTRY_ID` = 4) THEN '畜牧业'
            WHEN (`p`.`SUBINDSTRY_ID` = 5) THEN '农药&肥料'
            WHEN (`p`.`SUBINDSTRY_ID` = 6) THEN '渔业'
            WHEN (`p`.`SUBINDSTRY_ID` = 7) THEN '食品加工'
            WHEN (`p`.`SUBINDSTRY_ID` = 8) THEN '饲料'
            WHEN (`p`.`SUBINDSTRY_ID` = 10) THEN '土壤修复'
            WHEN (`p`.`SUBINDSTRY_ID` = 11) THEN '节能减排、脱硫脱硝'
            WHEN (`p`.`SUBINDSTRY_ID` = 12) THEN '固废处理'
            WHEN (`p`.`SUBINDSTRY_ID` = 13) THEN '水处理'
            WHEN (`p`.`SUBINDSTRY_ID` = 15) THEN '保险'
            WHEN (`p`.`SUBINDSTRY_ID` = 16) THEN '其他金融'
            WHEN (`p`.`SUBINDSTRY_ID` = 17) THEN '律师'
            WHEN (`p`.`SUBINDSTRY_ID` = 18) THEN '政府机关'
            WHEN (`p`.`SUBINDSTRY_ID` = 19) THEN '银行&会计'
            WHEN (`p`.`SUBINDSTRY_ID` = 20) THEN '证券公司'
            WHEN (`p`.`SUBINDSTRY_ID` = 22) THEN '医院'
            WHEN (`p`.`SUBINDSTRY_ID` = 23) THEN '医疗设备'
            WHEN (`p`.`SUBINDSTRY_ID` = 24) THEN '药品'
            WHEN (`p`.`SUBINDSTRY_ID` = 25) THEN '保健品'
            WHEN (`p`.`SUBINDSTRY_ID` = 27) THEN '奶制品'
            WHEN (`p`.`SUBINDSTRY_ID` = 28) THEN '休闲食品'
            WHEN (`p`.`SUBINDSTRY_ID` = 29) THEN '酒类&烟草'
            WHEN (`p`.`SUBINDSTRY_ID` = 30) THEN '软饮类'
            WHEN (`p`.`SUBINDSTRY_ID` = 32) THEN '体育娱乐'
            WHEN (`p`.`SUBINDSTRY_ID` = 33) THEN '奢侈品'
            WHEN (`p`.`SUBINDSTRY_ID` = 34) THEN '旅游'
            WHEN (`p`.`SUBINDSTRY_ID` = 35) THEN '皮革毛皮羽毛(绒)及其制品业'
            WHEN (`p`.`SUBINDSTRY_ID` = 36) THEN '纺织品'
            WHEN (`p`.`SUBINDSTRY_ID` = 37) THEN '连锁经营'
            WHEN (`p`.`SUBINDSTRY_ID` = 38) THEN '日化洗护产品'
            WHEN (`p`.`SUBINDSTRY_ID` = 39) THEN '百货'
            WHEN (`p`.`SUBINDSTRY_ID` = 40) THEN '鞋帽制造'
            WHEN (`p`.`SUBINDSTRY_ID` = 41) THEN '餐饮'
            WHEN (`p`.`SUBINDSTRY_ID` = 42) THEN '家用电器'
            WHEN (`p`.`SUBINDSTRY_ID` = 43) THEN '超市'
            WHEN (`p`.`SUBINDSTRY_ID` = 44) THEN '酒店'
            WHEN (`p`.`SUBINDSTRY_ID` = 45) THEN '日用品'
            WHEN (`p`.`SUBINDSTRY_ID` = 47) THEN '电力'
            WHEN (`p`.`SUBINDSTRY_ID` = 48) THEN '石油，天然气'
            WHEN (`p`.`SUBINDSTRY_ID` = 49) THEN '煤炭'
            WHEN (`p`.`SUBINDSTRY_ID` = 50) THEN '太阳能'
            WHEN (`p`.`SUBINDSTRY_ID` = 51) THEN '水利'
            WHEN (`p`.`SUBINDSTRY_ID` = 52) THEN '生物质能'
            WHEN (`p`.`SUBINDSTRY_ID` = 53) THEN '风能'
            WHEN (`p`.`SUBINDSTRY_ID` = 55) THEN '互联网'
            WHEN (`p`.`SUBINDSTRY_ID` = 56) THEN '会展'
            WHEN (`p`.`SUBINDSTRY_ID` = 57) THEN '培训机构'
            WHEN (`p`.`SUBINDSTRY_ID` = 58) THEN '安防'
            WHEN (`p`.`SUBINDSTRY_ID` = 59) THEN '广告&媒体'
            WHEN (`p`.`SUBINDSTRY_ID` = 60) THEN '照明'
            WHEN (`p`.`SUBINDSTRY_ID` = 61) THEN '猎头'
            WHEN (`p`.`SUBINDSTRY_ID` = 62) THEN '博彩'
            WHEN (`p`.`SUBINDSTRY_ID` = 63) THEN '消费类电子'
            WHEN (`p`.`SUBINDSTRY_ID` = 64) THEN '高校'
            WHEN (`p`.`SUBINDSTRY_ID` = 65) THEN '报纸、杂志&出版社'
            WHEN (`p`.`SUBINDSTRY_ID` = 66) THEN '软件'
            WHEN (`p`.`SUBINDSTRY_ID` = 67) THEN '硬件'
            WHEN (`p`.`SUBINDSTRY_ID` = 68) THEN '网络增值服务'
            WHEN (`p`.`SUBINDSTRY_ID` = 69) THEN '网络游戏'
            WHEN (`p`.`SUBINDSTRY_ID` = 70) THEN '电子商务'
            WHEN (`p`.`SUBINDSTRY_ID` = 71) THEN '通信'
            WHEN (`p`.`SUBINDSTRY_ID` = 72) THEN '软件外包服务'
            WHEN (`p`.`SUBINDSTRY_ID` = 74) THEN '建材'
            WHEN (`p`.`SUBINDSTRY_ID` = 75) THEN '建筑工程和装饰装修'
            WHEN (`p`.`SUBINDSTRY_ID` = 76) THEN '地产'
            WHEN (`p`.`SUBINDSTRY_ID` = 77) THEN '设计院'
            WHEN (`p`.`SUBINDSTRY_ID` = 79) THEN '机械制造类'
            WHEN (`p`.`SUBINDSTRY_ID` = 80) THEN '造纸及印刷'
            WHEN (`p`.`SUBINDSTRY_ID` = 82) THEN '化工产品'
            WHEN (`p`.`SUBINDSTRY_ID` = 83) THEN '非金属类'
            WHEN (`p`.`SUBINDSTRY_ID` = 85) THEN '有色金属'
            WHEN (`p`.`SUBINDSTRY_ID` = 86) THEN '采矿业'
            WHEN (`p`.`SUBINDSTRY_ID` = 87) THEN '稀土'
            WHEN (`p`.`SUBINDSTRY_ID` = 88) THEN '贵重金属'
            WHEN (`p`.`SUBINDSTRY_ID` = 89) THEN '黑色金属'
            WHEN (`p`.`SUBINDSTRY_ID` = 91) THEN '航空'
            WHEN (`p`.`SUBINDSTRY_ID` = 92) THEN '飞机部件'
            WHEN (`p`.`SUBINDSTRY_ID` = 93) THEN '飞机制造'
            WHEN (`p`.`SUBINDSTRY_ID` = 95) THEN '汽车制造'
            WHEN (`p`.`SUBINDSTRY_ID` = 96) THEN '物流'
            WHEN (`p`.`SUBINDSTRY_ID` = 97) THEN '汽车维修'
            WHEN (`p`.`SUBINDSTRY_ID` = 98) THEN '铁路交通'
            WHEN (`p`.`SUBINDSTRY_ID` = 99) THEN '汽车零部件'
            WHEN (`p`.`SUBINDSTRY_ID` = 100) THEN '船舶'
            WHEN (`p`.`SUBINDSTRY_ID` = 101) THEN '道路建设'
            WHEN (`p`.`SUBINDSTRY_ID` = 102) THEN '轨道交通'
            WHEN (`p`.`SUBINDSTRY_ID` = 103) THEN '货运'
            ELSE ''
        END) AS `Project_Industry_level2`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `pt`.`task_indstry_level1_name`
        END) AS `task_industry_level1`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `pt`.`task_indstry_level2_name`
        END) AS `task_industry_level2`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `pt`.`task_indstry_level3_name`
        END) AS `task_industry_level3`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `f`.`experttise`
        END) AS `feedback_expertise`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `f`.`communication`
        END) AS `feedback_communication`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `f`.`professionlism`
        END) AS `feedback_professionalism`,
        (CASE
            WHEN ISNULL(`p`.`PRJCT_ID`) THEN NULL
            ELSE `f`.`notes`
        END) AS `feedback_detail`
    FROM
        ((((`dw_simp`.`v_prjct` `p`
        LEFT JOIN `dw_simp`.`v_prjct_task` `pt` ON ((`pt`.`PRJCT_ID` = `p`.`PRJCT_ID`)))
        LEFT JOIN `dw_simp`.`v_clnt_cntct` `cc` ON ((`cc`.`CLNT_CNTCT_ID` = `pt`.`CLNT_CNTCT_ID`)))
        JOIN `dw_simp`.`v_clnt` `cl` ON ((`cl`.`CLNT_ID` = `cc`.`CLNT_ID`)))
        LEFT JOIN `ndb`.`ndb_consultant_feedback` `f` ON ((`pt`.`TASK_ID` = `f`.`taskid`)))
    WHERE
        ((1 = 1)
            AND (`pt`.`task_rgn_name` = 'China')
            AND (`cc`.`CLNT_CNTCT_STS_CD` = 1)
            AND (`p`.`PRJCT_CTGRY_NAME` = 'Consultation')
            AND (`p`.`PRJCT_STS_NAME` <> 'Invalid')
            AND (`p`.`SKM_NAME` IN ('Anisa Ju' , 'Bruce Huang',
            'Chris Chen',
            'Kate Ji',
            'Sherry Wang',
            'Simon Zhu',
            'Wei Zhu'))
            AND (`p`.`BEG_DT` >= '2014-01-01')) ;




END$$

DELIMITER ;