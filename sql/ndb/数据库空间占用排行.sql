SELECT table_schema,table_name,data_length FROM information_schema.tables 
WHERE table_schema='ndb'
ORDER BY data_length DESC;