-- After Insert Trigger..........

DELIMITER //
CREATE TRIGGER tr_AfterInsertCandidate
AFTER INSERT ON hired_candidates
FOR EACH ROW
BEGIN
INSERT INTO candidates_audit (id,audit_description) VALUES (null,concat(' A new row is inserted ', date_format(now(), '%d-%m-%y %h:%i:%s %p' ) ));
END //
DELIMITER ;

-- After Delete Trigger.....

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


-- Drop Trigger.....
 drop trigger tr_AfterDeleteLab;


-- After Update Trigger ........

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
