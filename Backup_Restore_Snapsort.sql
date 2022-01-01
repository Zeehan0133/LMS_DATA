-- GENERATE A BACKUP OF SINGLE DATABASE......
mysqldump -u root -p employeedb > C:\database_backup\employee_table1222.sql


-- GENERATE A BACKUP OF MULTIPLE TABLES...........
mysqldump -u root -p --databases studentsdb employeesdb > C:\database_backup\stu_employees_20200424.sql


-- GENERATE BACKUP FOR ALL DATABASES................
mysqldump -u root -p --all-databases > C:\database_backup\all_databases_20200424.sql

-- GENERATE BACKUP FOR STRUCTURE ONLY.............
mysqldump -u root -p --no-data employee > C:\database_backup\employeesdb_objects_definition_20200424.sql

-- GENERATE BACKUP FOR SPECIFIC TABLE................
mysqldump -u root -p employeesdb employee > C:\database_backup\employee_table_1222.sql


-- GENERATE THE BACKUP OF DATABASE DATA.................
mysqldump -u root -p studentsdb --no-create-info > C:\database_backup\students_data_only_20200424.sql


--RESTORE MYSQL DATABASE
-- (1)
mysql> use employeesdb;
Database changed
mysql> drop table employee;

mysql> create database employee_dummy;
mysql> use sakila_dummy;
mysql> source C:\database_backup\employee_table1222.sql


mysqldump -u root -p employee_dummy employee > C:\MySQLBackup\employee_dummy1222.sql

source C:\database_backup\employee_dummy1222.sql

mysql> use employeesdb;
Database changed
mysql> show tables;


-- Creating a Data Snapshot Using mysqldump....
>mysqldump -u root -p --all-databases --master-data > "C:\database_backup\aa.db"

-- Creating a data snapsort on a particular table...
mysqldump -u root -p employeesdb --master-data > "C:\database_backup\employee.db" 

