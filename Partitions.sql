-- PARTITION BY RANGE...................................................................
DROP TABLE IF EXISTS candidate_personal_det_check;
CREATE TABLE candidate_personal_det_check (
  id int NOT NULL,
  candidate_id int NOT NULL,
  field_name varchar(15) NOT NULL,
  is_verified int DEFAULT NULL,
  lastupd_stamp datetime DEFAULT NULL,
  lastupd_user int DEFAULT NULL,
  creator_stamp datetime DEFAULT NULL,
  creator_user int DEFAULT NULL
  )
  PARTITION BY RANGE (id)
  (
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (200), 
    PARTITION p3 VALUES LESS THAN (300),  
    PARTITION p7 VALUES LESS THAN MAXVALUE 
  );

  -- SHOW PARTITION................
  select TABLE_NAME,PARTITION_NAME,TABLE_ROWS
  FROM INFORMATION_SCHEMA.PARTITIONS
  WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'candidate_personal_det_check';

-- OUTPUT...........
+------------------------------+----------------+------------+
| TABLE_NAME                   | PARTITION_NAME | TABLE_ROWS |
+------------------------------+----------------+------------+
| candidate_personal_det_check | p1             |          0 |
| candidate_personal_det_check | p2             |          5 |
| candidate_personal_det_check | p3             |          0 |
| candidate_personal_det_check | p7             |          0 |
+------------------------------+----------------+------------+
4 rows in set (0.01 sec)

-- PARTITION BY LIST..................
DROP TABLE IF EXISTS company;
CREATE TABLE company (
  id int NOT NULL,
  name varchar(50) NOT NULL,
  address varchar(200) DEFAULT NULL,
  location varchar(40) DEFAULT NULL,
  status int DEFAULT '0',
  creator_stamp datetime DEFAULT NULL,
  creator_user int DEFAULT NULL,
  PRIMARY KEY (id)
 )
 PARTITION BY LIST(id)
 (
 PARTITION P1 VALUES IN (1001) ,
 PARTITION p2 VALUES IN (1002),
 PARTITION p3 VALUES IN (1003),
 PARTITION p4 VALUES IN (1004)
 );

  -- SHOW PARTITION..............
  SELECT TABLE_NAME,PARTITION_NAME,TABLE_ROWS
  FROM INFORMATION_SCHEMA.PARTITIONS
  WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'company';

-- OUTPUT............
+------------+----------------+------------+
| TABLE_NAME | PARTITION_NAME | TABLE_ROWS |
+------------+----------------+------------+
| company    | P1             |          1 |
| company    | p2             |          1 |
| company    | p3             |          1 |
| company    | p4             |          1 |
+------------+----------------+------------+
4 rows in set (0.01 sec)

-- PARTITION BY HASH...................
CREATE TABLE hired_candidates (
  Id int NOT NULL,
  First_name varchar(50) NOT NULL,
  Middle_name varchar(50) DEFAULT NULL,
  Last_name varchar(50) NOT NULL,
  Email varchar(50) NOT NULL,
  Degree varchar(80) NOT NULL,
  Hired_city varchar(40) NOT NULL,
  Hired_date datetime NOT NULL,
  Mobile_no bigint NOT NULL,
  Permanent_pincode int DEFAULT NULL,
  Hired_lab varchar(20) DEFAULT NULL,
  Attitude_remark varchar(20) DEFAULT NULL,
  Communication_remark varchar(20) DEFAULT NULL,
  Knowledge_remark varchar(20) DEFAULT NULL,
  Aggregate_remark double DEFAULT NULL,
  Status varchar(20) NOT NULL,
  Creator_stamp datetime DEFAULT NULL,
  Creator_user int DEFAULT NULL,
  PRIMARY KEY (Id)
  )
  PARTITION BY HASH(Id)
    PARTITIONS 4;

 -- SHOW PARTITION..............
  SELECT TABLE_NAME,PARTITION_NAME,TABLE_ROWS
  FROM INFORMATION_SCHEMA.PARTITIONS
  WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'hired_candidates';

-- OUTPUT..................
+------------------+----------------+------------+
| TABLE_NAME       | PARTITION_NAME | TABLE_ROWS |
+------------------+----------------+------------+
| hired_candidates | p0             |          1 |
| hired_candidates | p1             |          1 |
| hired_candidates | p2             |          1 |
| hired_candidates | p3             |          2 |
+------------------+----------------+------------+
4 rows in set (0.00 sec)

-- PARTITION BY KEY..................
CREATE TABLE lab (
  id int NOT NULL  UNIQUE,
  name varchar(20) NOT NULL,
  location varchar(30) NOT NULL,
  address varchar(50) NOT NULL,
  status int DEFAULT 1,
  creator_stamp datetime DEFAULT NULL,
  creator_user int DEFAULT NULL
  )
  PARTITION BY KEY(Id)
    PARTITIONS 4;

 -- SHOW PARTITION..............
  SELECT TABLE_NAME,PARTITION_NAME,TABLE_ROWS
  FROM INFORMATION_SCHEMA.PARTITIONS
  WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'lab';

-- OUTPUT.............................
+------------+----------------+------------+
| TABLE_NAME | PARTITION_NAME | TABLE_ROWS |
+------------+----------------+------------+
| lab        | p0             |          1 |
| lab        | p1             |          2 |
| lab        | p2             |          1 |
| lab        | p3             |          1 |
+------------+----------------+------------+
4 rows in set (0.00 sec)

-- PARTITION BY RANGE COLUMN...........
DROP TABLE IF EXISTS user_roles;
CREATE TABLE user_roles 
(
  user_id int NOT NULL,
  role_name varchar(100) DEFAULT NULL
)
  PARTITION BY RANGE COLUMNS(user_id,role_name)   
 (PARTITION p0 VALUES LESS THAN (50, 'corp'),   
 PARTITION p1 VALUES LESS THAN (100, 'laima'),
 PARTITION p3 VALUES LESS THAN (MAXVALUE, MAXVALUE));  

-- SHOW PARTITION.... 
SELECT TABLE_NAME,PARTITION_NAME,TABLE_ROWS
 FROM INFORMATION_SCHEMA.PARTITIONS
 WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'user_roles';
 
-- OUTPUT................... 
+------------+----------------+------------+
| TABLE_NAME | PARTITION_NAME | TABLE_ROWS |
+------------+----------------+------------+
| user_roles | p0             |          0 |
| user_roles | p1             |          1 |
| user_roles | p3             |          3 |
+------------+----------------+------------+
3 rows in set (0.01 sec)


--  PARTITION BY LIST COLUMNS.............
DROP TABLE IF EXISTS tech_type;
CREATE TABLE tech_type (
  id int NOT NULL,
  type_name varchar(20) NOT NULL,
  cur_status int DEFAULT 0,
  creator_stamp datetime DEFAULT NULL,
  creator_user int DEFAULT NULL
 ) 
PARTITION BY LIST COLUMNS(id) (   
PARTITION pN VALUES IN(101),   
PARTITION pT VALUES IN(102),   
PARTITION pC VALUES IN (103)); 

-- SHOW PARTITION.......
select TABLE_NAME,PARTITION_NAME,TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'tech_type';

-- OUTPUT....
+------------+----------------+------------+
| TABLE_NAME | PARTITION_NAME | TABLE_ROWS |
+------------+----------------+------------+
| tech_type  | pC             |          0 |
| tech_type  | pN             |          0 |
| tech_type  | pT             |          0 |
+------------+----------------+------------+
3 rows in set (0.01 sec)

-- SUBPARTITION...........
CREATE TABLE app_parameter (
  id int NOT NULL,
  key_type varchar(20) NOT NULL,
  key_value varchar(20) NOT NULL,
  key_text varchar(100) DEFAULT NULL,
  cur_status char(5) DEFAULT NULL,
  lastupd_user int DEFAULT NULL,
  lastupd_stamp datetime DEFAULT NULL,
  creator_stamp datetime DEFAULT NULL,
  creator_user int DEFAULT NULL,
  seq_num int DEFAULT NULL
)
PARTITION BY RANGE( id )  
    SUBPARTITION BY HASH( creator_user )  
    SUBPARTITIONS 2 (  
        PARTITION p0 VALUES LESS THAN (111),  
        PARTITION p1 VALUES LESS THAN (121),  
        PARTITION p2 VALUES LESS THAN MAXVALUE  
    ); 

-- SHOW PARTITION...
SELECT TABLE_NAME,PARTITION_NAME,TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'lms_partition' AND TABLE_NAME = 'app_parameter';

-- OUTPUT.....................
+---------------+----------------+------------+
| TABLE_NAME    | PARTITION_NAME | TABLE_ROWS |
+---------------+----------------+------------+
| app_parameter | p0             |          0 |
| app_parameter | p0             |          0 |
| app_parameter | p1             |          0 |
| app_parameter | p1             |          0 |
| app_parameter | p2             |          4 |
| app_parameter | p2             |          5 |
+---------------+----------------+------------+
6 rows in set (0.01 sec)
 
