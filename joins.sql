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
  where s1.id <> s2.first_name;
