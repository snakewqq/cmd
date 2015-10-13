<?php
return array(
    'components'=>array(
        'db'=>array(
            'connectionString' => 'mysql:host=192.168.5.133;dbname=ndb_qa',
            'emulatePrepare' => true,
            'username' => 'dev',
            'password' => 'dev',
            'charset' => 'utf8',
            'tablePrefix' => 'ndb_',
            'enableProfiling'=>true,
            'enableParamLogging'=>true,
            //	'schemaCachingDuration'=>3600,
        ),
        'cache' => array(
            'class' => 'system.caching.CFileCache',
            'keyPrefix' => 'ndb518',
        ),
        'galaxy' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=192.168.5.133;dbname=galaxy',
            'emulatePrepare' => true,
            'username' => 'root',
            'password' => '1234@qAz',
            'charset' => 'utf8',
            'enableProfiling' => true,
            'enableParamLogging' => true,
        ),
    ),
);
?>
