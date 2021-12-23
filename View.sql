-- create view.....
DROP VIEW IF EXISTS sample_view
CREATE VIEW sample_view AS 
select tech_stack_id from mentor_techstack
inner join mentor
on mentor_techstack.tech_stack_id=mentor.id;


-- Delete view
 DROP VIEW sample_view



-- update view ..........
ALTER VIEW sample_view
insert into mentor (id,name) values (1306,'Rohaan');
update mentor SET name='Rehan' WHERE id=1301;
select id,name from mentor
WHERE name='piyush';
