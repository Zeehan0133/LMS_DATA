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
