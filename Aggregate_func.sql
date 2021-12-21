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
