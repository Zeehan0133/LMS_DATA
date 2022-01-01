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

Query OK, 5 rows affected (0.01 sec)
