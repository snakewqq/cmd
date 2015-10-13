<?php

return array(
    'components' => array(
        'db' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=192.168.5.133;dbname=ndb_qa',
            'emulatePrepare' => true,
            'username' => 'dev',
            'password' => 'dev',
            'charset' => 'utf8',
            'tablePrefix' => 'ndb_',
            'enableProfiling' => true,
            'enableParamLogging' => true,
        ),
        'dw' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=192.168.3.87;dbname=p_analysis_v',
            'emulatePrepare' => true,
            'username' => 'db_report',
            'password' => 'cpvsn',
            'charset' => 'utf8',
            'enableProfiling' => true,
            'enableParamLogging' => true,
        ),
        'galaxy' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=192.168.5.133;dbname=galaxy_dev',
            'emulatePrepare' => true,
            'username' => 'dev',
            'password' => 'dev',
            'charset' => 'utf8',
            'enableProfiling' => true,
            'enableParamLogging' => true,
        ),
        'cache' => array(
            'class' => 'system.caching.CFileCache',
            'keyPrefix' => 'ndb518',
        ),
    ),
);
?>
