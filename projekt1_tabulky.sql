# TABULKA 1
create table if not exists t_veronika_smajda_project_SQL_primary_final1 as (
select cpc.name AS food_category, cp2.value AS food_price,cp.value AS average_wages,cp.payroll_year as 'year',cpib.name AS industry
from czechia_price cp2 
join czechia_payroll cp on cp.payroll_year=year(cp2.date_from) and cp.value_type_code = 5958 and cp2.region_code IS NULL
join czechia_price_category cpc on cp2.category_code=cpc.code
join czechia_payroll_industry_branch cpib on cp.industry_branch_code=cpib.code);


# TABULKA 2 
create table if not exists t_veronika_smajda_project_SQL_secondary_final as (
select a.GDP,a.gini,a.population,a.`year`,b.country,b.continent
from (select GDP,gini,population,`year`,country
		from economies e 
		where `year` between 2006 and 2018)a
left join (select country,continent
		from countries c
		where continent='Europe')b
on a.country=b.country);


