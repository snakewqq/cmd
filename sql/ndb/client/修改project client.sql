SELECT * FROM ndb_project_client WHERE projectid = 157290;

/*修改项目所属客户*/
UPDATE ndb_project_client
SET clientid = 135040
WHERE projectid = 143069;


SELECT * FROM ndb_project_client_contact WHERE projectid = 143069

UPDATE ndb_project_client_contact 
SET contactid = 139727,
    contact_newid = 139727
WHERE projectid = 143069