SELECT id,`name`,REPLACE(`name`,'凯盛咨询','凯盛融英') AS name1,`subject`,REPLACE(`subject`,'凯盛咨询','凯盛融英') AS subject1 FROM ndb_email_template LIMIT 10;

UPDATE ndb_email_template
SET `name` = REPLACE(`name`,'凯盛融英融英','凯盛融英'),
    `subject` = REPLACE(`subject`,'凯盛融英融英','凯盛融英'),
    `body` = REPLACE(`body`,'凯盛融英融英','凯盛融英');
    
UPDATE ndb_email_template
SET `name` = REPLACE(`name`,'凯盛集团','凯盛融英'),
    `subject` = REPLACE(`subject`,'凯盛集团','凯盛融英'),
    `body` = REPLACE(`body`,'凯盛集团','凯盛融英');

UPDATE ndb_email_template
SET `name` = REPLACE(`name`,'凯仁投资','凯盛融英'),
    `subject` = REPLACE(`subject`,'凯仁投资','凯盛融英'),
    `body` = REPLACE(`body`,'凯仁投资','凯盛融英');
    
UPDATE ndb_email_template
SET `name` = REPLACE(`name`,'凯盛投资咨询','凯盛融英'),
    `subject` = REPLACE(`subject`,'凯盛投资咨询','凯盛融英'),
    `body` = REPLACE(`body`,'凯盛投资咨询','凯盛融英');
    
UPDATE ndb_email_template
SET `name` = REPLACE(`name`,'上海凯盛','凯盛融英'),
    `subject` = REPLACE(`subject`,'上海凯盛','凯盛融英'),
    `body` = REPLACE(`body`,'上海凯盛','凯盛融英');
    
SELECT id,`name`,content FROM ndb_sms_template LIMIT 10;


UPDATE ndb_sms_template
SET `name` = REPLACE(`name`,'凯盛咨询','凯盛融英'),
    `content` = REPLACE(`content`,'凯盛咨询','凯盛融英');
    
UPDATE ndb_sms_template
SET `name` = REPLACE(`name`,'凯盛集团','凯盛融英'),
    `content` = REPLACE(`content`,'凯盛集团','凯盛融英');

UPDATE ndb_sms_template
SET `name` = REPLACE(`name`,'凯仁投资','凯盛融英'),
    `content` = REPLACE(`content`,'凯仁投资','凯盛融英');
    
UPDATE ndb_sms_template
SET `name` = REPLACE(`name`,'凯盛投资咨询','凯盛融英'),
    `content` = REPLACE(`content`,'凯盛投资咨询','凯盛融英');
    
UPDATE ndb_sms_template
SET `name` = REPLACE(`name`,'上海凯盛','凯盛融英'),
    `content` = REPLACE(`content`,'上海凯盛','凯盛融英');
    
SELECT id,signature FROM ndb_employees LIMIT 10;