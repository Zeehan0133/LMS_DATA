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
