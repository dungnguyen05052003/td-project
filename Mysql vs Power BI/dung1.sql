CREATE database Project;
use Project;

select * from hr;
alter table hr
change column ï»¿id emp_id varchar(20) null;

Describe hr;
select birthdate from hr;

set sql_safe_updates = 0;

update hr
set hire_date= case 
	when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
	when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
	else null
end;
alter table hr
modify column birthdate date;
select hire_date from hr;

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
Where termdate is not null and termdate != '';

alter table hr
modify column termdate date; 
select birthdate,age from hr;

alter table hr add column age INT;
update hr
set age = timestampdiff(YEAR,birthdate,CURDATE());
	