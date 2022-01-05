-- count ids from hired candidate 

Delimiter \\
create procedure spGetCount_id()
begin
SELECT COUNT(id)
FROM hired_candidates;
end \\
delimiter ;



-- get avg from candidate id


delimiter \\
create procedure spGetAvg_id()
begin
select  avg(id) as  avg_id
from candidate_personal_det_check;
end \\
delimiter ;



-- get id sum from user details table

DELIMITER \\
create procedure spGet_sum_id()
begin
SELECT SUM(id)
FROM user_details;
end \\


-- get min id from lab table

delimiter \\
create procedure spGet_Min()
begin

SELECT MIN(id)
FROM lab;
end \\
delimiter ;


-- get max name from mentor table

delimiter \\
create procedure spGet_max_name()
begin
SELECT MAX(name)
FROM mentor;
end \\
delimiter ;


-- get fellowship candidate details..
DELIMITER //
create procedure spGetAll()
BEGIN
select * from fellowship_candidates;
END //


-- call stored procedure



-- drop procedure 
 drop spGetAll();



-- get field names....
DELIMITER //
create procedure spGetField()
BEGIN
select * from candidate_personal_det_check
where field_name='BE';
END //
DELIMITER ;


-- create procedure for hired candidate
DELIMITER //
create procedure spGetHired_candidate()
BEGIN
select * from hired_candidates
where Last_name='khan'
and Degree='BE'
group by id;
END //
DELIMITER ;

-- get fellowship candidate id 
DELIMITER //
create procedure spGetcandidate_id()
BEGIN
select candidate_id from candidate_tech_stack_assignment
inner join fellowship_candidates
on candidate_tech_stack_assignment.candidate_id=fellowship_candidates.id;
END //
DELIMITER ;


-- CONTINUE Action 
DROP PROCEDURE IF EXISTS spGetExp; 

delimiter //
create procedure spGetExp(
    IN inid int)
     BEGIN
      DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Duplicate key (',inid,') occurred') AS message;
    END;
     insert into user_roles(user_id)
     values(inid);
     SELECT SUM(user_id)
     FROM user_roles
     WHERE user_id=inid;
     
     END //
     delimiter ;


-- EXIT action
DROP PROCEDURE IF EXISTS spGetExp; 

delimiter //
create procedure spGetExp(
    IN inid int, IN f1 int, IN f2 int)
     BEGIN
      DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Duplicate key (',inid,',',f1,',',f2,') occurred') AS message;
    END;
     insert into mentor_techstack(id,mentor_id,tech_stack_id)
     values(inid,f1,f2);
     SELECT COUNT(*)
     FROM mentor_techstack
     WHERE id=inid;
           
     
     END //
     delimiter ;
     
-- handler precedence
DROP PROCEDURE IF EXISTS spGetExp; 

delimiter //
create procedure spGetExp(
    IN inid int)
     BEGIN
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Duplicate keys error encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQLException encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SELECT 'SQLSTATE 23000' ErrorCode;
     
     insert into mentor(id)
     values(inid);
     SELECT SUM(id)
     FROM mentor
     WHERE id=inid;
     
     END //
     delimiter ;

-- declare condition 

DROP PROCEDURE IF EXISTS spGetTable;

DELIMITER $$

CREATE PROCEDURE spGetTable()
BEGIN
    DECLARE TableNotFound CONDITION for 1146 ; 

    DECLARE EXIT HANDLER FOR TableNotFound 
	SELECT 'Please create table abc first' Message; 
    SELECT * FROM abc;
END$$

DELIMITER ;

-- inner join 
select candidate_id from candidate_tech_stack_assignment
 inner join fellowship_candidates
 on candidate_tech_stack_assignment.candidate_id=fellowship_candidates.id;


-- right join 
select candidate_id from candidate_tech_stack_assignment
right join fellowship_candidates
on candidate_tech_stack_assignment.candidate_id=fellowship_candidates.id;



-- left join
select * from candidate_tech_stack_assignment
    -> left join fellowship_candidates
    -> on candidate_tech_stack_assignment.candidate_id=fellowship_candidates.id
    -> where First_name='mohd'
    -> order by First_name;

 
-- cross join 
select user_details.id,user_roles.user_id
    from user_details
    cross join user_roles
    order by id;

-- self join  
SELECT s1.id, s2.first_name
    from user_details s1, user_details s2
  where s1.id = s2.id;

-- create cursor in fellowship_candidates table 

DELIMITER //
CREATE PROCEDURE f_cursor1() 
 BEGIN
    DECLARE i int;
    DECLARE n1 varchar(10);
    DECLARE n2 varchar(10);
    DECLARE n3 varchar(10);
    DECLARE cur cursor FOR SELECT id,First_name,Middle_name,Last_name FROM fellowship_candidates;
    OPEN cur;
    FETCH cur into i,n1,n2,n3;
    SELECT i,n1,n2,n3;
    CLOSE cur;
    END; //
   DELIMITER ;


-- Call cursor............
  call f_cursor1();


-- continue handler in cursor in hired_candidates table

DELIMITER //
CREATE PROCEDURE candidate_cursor() 
 BEGIN
    DECLARE i int;
    DECLARE fn varchar(10);
    DECLARE mn varchar(10);
    DECLARE ln varchar(10);
    DECLARE agr_mrk int ;
    DECLARE c_finish int default 0;
    DECLARE cur1 cursor FOR SELECT Id,First_name,Middle_name,Last_name ,Aggregate_remark FROM hired_candidates WHERE Aggregate_remark>50;
    DECLARE CONTINUE HANDLER FOR not found set  c_finish=1;
    OPEN cur1;
    get_cand:loop
    FETCH cur1 into i,fn,mn,ln,agr_mrk;
    SELECT i,fn,mn,ln,agr_mrk;
    if c_finish=1 then
    leave get_cand;
    end if;
    end loop get_cand;
    END //

-- After Insert trigger..........
DELIMITER //
CREATE TRIGGER tr_AfterInsertCandidate
AFTER INSERT ON hired_candidates
FOR EACH ROW
BEGIN
INSERT INTO candidates_audit (id,audit_description) VALUES (null,concat(' A new row is inserted ', date_format(now(), '%d-%m-%y %h:%i:%s %p' ) ));
END //
DELIMITER ;

-- After Delete Trigger................
DELIMITER //
CREATE TRIGGER tr_AfterDeleteLab
AFTER DELETE ON lab
FOR EACH ROW
BEGIN
DECLARE id int;
SET id = old.id;
INSERT INTO candidates_audit (id,audit_description) VALUES (null,concat(' A new row is deleted with id ',id,'at ', date_format(now(), '%d-%m-%y %h:%i:%s %p' ) ));
END //
DELIMITER ;

-- Delete the Trigger
drop trigger tr_AfterDeleteLab;


-- After Update Trigger...........
DELIMITER //
CREATE TRIGGER tr_AfterUpdateLab
AFTER UPDATE ON tech_stack
FOR EACH ROW
BEGIN
DECLARE inserted_tech_name  varchar(50);
DECLARE deleted_tech_name varchar (50);
SET inserted_tech_name = new.tech_name;
SET deleted_tech_name = old.tech_name;
INSERT INTO candidates_audit (id,audit_description) VALUES (null,concat(' A name ', deleted_tech_name ,' is replaced with ', inserted_tech_name , ' at '  , date_format(now(), '%d-%m-%y %h:%i:%s %p' ) ));
END //
DELIMITER ;

-- Before Insert trigger.............
DELIMITER //
CREATE TRIGGER tr_BeforeInsert
BEFORE INSERT ON user_details
FOR EACH ROW
BEGIN
DECLARE user_verified int ;
SET user_verified = new.verified;
IF user_verified = 0
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user not verified ';
END IF;
END //
DELIMITER ;
 

-- Before Delete Trigger................
DELIMITER //
CREATE TRIGGER tr_BeforeDelete
BEFORE DELETE ON user_roles
FOR EACH ROW
BEGIN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'can not delete active user';
END //
DELIMITER ;




-- Before Update trigger.....
DELIMITER //
CREATE TRIGGER tr_BeforeUpdate
BEFORE UPDATE ON tech_type
FOR EACH ROW
BEGIN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'can not update or modify';
END //
DELIMITER ;

-- create index ...
 create index my_count_index ON `cpulogdata2019-11-17-new`(`Cpu Count`);
 select `Cpu Count` from `cpulogdata2019-11-17-new`
  where `Cpu Count`=4;

-- show index...
show index from `cpulogdata2019-11-17-new`;

-- drop index..
  alter table `cpulogdata2019-11-17-new`  drop index my_count_index  ;


-- create index in cpulog data table
create index tech_index on  `cpulogdata2019-11-17-new` (technology(276));
select technology from `cpulogdata2019-11-17-new` where technology ='java';

-- create cursor in fellowship_candidates table 

DELIMITER //
CREATE PROCEDURE f_cursor1() 
 BEGIN
    DECLARE i int;
    DECLARE n1 varchar(10);
    DECLARE n2 varchar(10);
    DECLARE n3 varchar(10);
    DECLARE cur cursor FOR SELECT id,First_name,Middle_name,Last_name FROM fellowship_candidates;
    OPEN cur;
    FETCH cur into i,n1,n2,n3;
    SELECT i,n1,n2,n3;
    CLOSE cur;
    END; //
   DELIMITER ;


-- Call cursor............
  call f_cursor1();


-- continue handler in cursor in hired_candidates table

DELIMITER //
CREATE PROCEDURE candidate_cursor() 
 BEGIN
    DECLARE i int;
    DECLARE fn varchar(10);
    DECLARE mn varchar(10);
    DECLARE ln varchar(10);
    DECLARE agr_mrk int ;
    DECLARE c_finish int default 0;
    DECLARE cur1 cursor FOR SELECT Id,First_name,Middle_name,Last_name ,Aggregate_remark FROM hired_candidates WHERE Aggregate_remark>50;
    DECLARE CONTINUE HANDLER FOR not found set  c_finish=1;
    OPEN cur1;
    get_cand:loop
    FETCH cur1 into i,fn,mn,ln,agr_mrk;
    SELECT i,fn,mn,ln,agr_mrk;
    if c_finish=1 then
    leave get_cand;
    end if;
    end loop get_cand;
    END //

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


-- store query in csv file
SELECT * FROM (
         SELECT 'requirement_id', 'candidate_id'
         UNION ALL
         (
             select requirement_id,sum(candidate_id) as candidates from candidate_tech_stack_assignment
     inner join fellowship_candidates  ON candidate_tech_stack_assignment.candidate_id=fellowship_candidates.id
     group by requirement_id
    
         )
     ) resulting_set
     INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/candidate.csv';
