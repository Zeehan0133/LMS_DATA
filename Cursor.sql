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
