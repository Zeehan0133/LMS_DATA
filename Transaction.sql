-- insert update and delete ....
DROP PROCEDURE IF EXISTS spIUD; 
 DELIMITER //
  CREATE PROCEDURE spIUD()
  BEGIN
  DECLARE CONTINUE HANDLER FOR 1062
  BEGIN 
  insert into user_roles(user_id,role_name) values (998,'xyz');
  update user_roles SET role_name='zee' where user_id = 901;
  DELETE FROM user_details where user_id = 902;
  SELECT * FROM user_roles;
  END;
  ROLLBACK;
  END //









-- ROLLBACK...........
DROP PROCEDURE IF EXISTS TRANSACTION_COMMIT;
DELIMITER //
 CREATE PROCEDURE TRANSACTION_COMMIT()
     BEGIN
     DECLARE EXIT HANDLER FOR sqlexception
     BEGIN
     ROLLBACK;
     END;
     DECLARE EXIT HANDLER FOR sqlwarning
     BEGIN
     ROLLBACK;
     END;
     START TRANSACTION;
     DELETE FROM user_roles;
     SELECT * FROM student2;
     ROLLBACK;
     END //


-- COMMIT ......
DROP PROCEDURE IF EXISTS TRANSACTION_ROLLBACK;
DELIMITER //
 CREATE PROCEDURE TRANSACTION_ROLLBACK()
     BEGIN
     DECLARE EXIT HANDLER FOR sqlexception
     BEGIN
     ROLLBACK;
     END;
     DECLARE EXIT HANDLER FOR sqlwarning
     BEGIN
     ROLLBACK;
     END;
     START TRANSACTION;
     DELETE FROM user_roles;
     SELECT * FROM student2;
     ROLLBACK;
     END //
