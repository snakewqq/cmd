#!/bin/sh
export PATH=$PATH:/usr/local/mysql/bin/
build_sql() {
    mysql -uadmin -padmin1234 ndb -e 'show tables;' | grep -vP '_view|Tables_in' > /tmp/tables.txt
    while read line
    do
        echo mysql -uadmin -padmin1234 ndb -e "\"alter table $line  discard tablespace;\""
        echo "mv /home/capvision/ndb/ndb/$line.ibd /data/mysql/ndb/"
        echo "mv /home/capvision/ndb/ndb/$line.cfg /data/mysql/ndb/"
        #echo "mv /home/capvision/ndb/ndb/$line.exp /data/mysql/ndb/"
        echo "chown -R mysql:mysql /data/mysql/ndb"
        echo mysql -uadmin -padmin1234 ndb -e "\"alter table $line import tablespace;\""
    done < /tmp/tables.txt
}

get_backup() {
    cd /home/capvision
    tar -zxvf /home/capvision/singlendb3307.tgz -C /home/capvision
    rm -rf /home/capvision/ndb
    mv /home/capvision/singlendb3307 /home/capvision/ndb
    innobackupex --apply-log --export /home/capvision/ndb/
 
    mysqldump -uadmin -padmin4321 -h192.168.5.240 --opt -R --no-data  ndb > /home/capvision/ndb_stru.sql
    mysql -uadmin -padmin1234 -e "drop database IF EXISTS ndb;"
    mysql -uadmin -padmin1234 -e "flush tables;"
    rm -rf /data/mysql/ndb/
    mysql -uadmin -padmin1234 -e "create database ndb;"
    mysql -uadmin -padmin1234 ndb < /home/capvision/ndb_stru.sql;
}

report_table(){
    echo 'begin' 
    date
    mysql -uadmin -padmin1234  ndb -e "update ndb_contact_mobile set mobile = '133';";
    mysql -uadmin -padmin1234  ndb -e "update ndb_contact_others set value = 'v';";
    mysql -uadmin -padmin1234  ndb -e "update ndb_contact_telephone set telephone = '025';";
    mysql -uadmin -padmin1234  dw_simp -e 'call update_dw_table();'
    mysql -uadmin -padmin1234  dw_simp -e 'call create_view_table_proc();'
    mysql -uadmin -padmin1234  dw_simp -e 'call proc_clnt_quota();'
    mysql -uadmin -padmin1234  dw_simp -e 'call client_project_activity();'
    echo 'end' 
    date

}

get_backup >> /home/capvision/reco_new-`date +%Y%m%d`.log 2>&1
build_sql > /tmp/myrun.sh
sh /tmp/myrun.sh >> /home/capvision/reco_new-`date +%Y%m%d`.log 2>&1
report_table >> /home/capvision/reco_new-`date +%Y%m%d`.log 2>&1
