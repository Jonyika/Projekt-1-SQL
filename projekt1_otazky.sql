# otázka 1. 
select A.industry,A.average_wages_2006,B.average_wages_2010,C.average_wages_2018,
case when C.average_wages_2018>B.average_wages_2010 then "increase_2018"
	 when B.average_wages_2010>A.average_wages_2006 then "increase_2010"
	else "decrease"
	end as changes
from (
		select distinct industry,average_wages as average_wages_2006,`year`
		from t_veronika_smajda_project_sql_primary_final1 tvspspf
		where year="2006")A 
left join (select distinct industry,average_wages as average_wages_2010,`year`
			from t_veronika_smajda_project_sql_primary_final1 tvspspf2
			where year="2010")B
on A.industry=B.industry
left join (select distinct industry,average_wages as average_wages_2018,`year`
			from t_veronika_smajda_project_sql_primary_final1 tvspspf2
			where year="2018")C
on B.industry=C.industry
group by A.`year`,A.industry;

# otázka 2. 
select food_category,food_price,average_wages,round(average_wages/food_price,0) as amount_to_buy,`year`
from t_veronika_smajda_project_sql_primary_final1 tvspspf
where food_category in ('Chléb konzumní kmínový','Mléko polotučné pasterované') and `year` in ("2006","2018")
group by `year`,food_category
order by `year`;


 # otázka 3.
WITH TAB_1 AS (
    SELECT food_category,food_price,year  
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null
    group by food_category,year),
    TAB_2 AS(
    SELECT food_category,food_price,year+1 as prev_year
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null
    group by food_category,prev_year)
select TAB_1.food_category,TAB_1.food_price,year,prev_year,round((TAB_1.food_price-TAB_2.food_price)/TAB_1.food_price*100,2) as price_grow_percent
from TAB_1 join TAB_2 
on TAB_1.food_category=TAB_2.food_category
and TAB_1.year=TAB_2.prev_year
order by price_grow_percent;

 
 # otázka 4.
WITH TAB_A AS (
    SELECT average_wages,food_price,year  
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null and average_wages is not null
    group by year),
    TAB_B AS(
    SELECT average_wages,food_price,year+1 as prev_year
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null
    group by prev_year)
select TAB_A.*,prev_year,
round((TAB_A.food_price-TAB_B.food_price)/TAB_A.food_price*100,2) as price_grow_percent,
round((TAB_A.average_wages-TAB_B.average_wages)/TAB_A.average_wages*100,2) as wages_grow_percent,
case when (TAB_A.food_price-TAB_B.food_price)/TAB_A.food_price*100 - (TAB_A.average_wages-TAB_B.average_wages)/TAB_A.average_wages*100 >10 then "above 10"
else "NA" end as grow
from TAB_A join TAB_B 
on TAB_A.year=TAB_B.prev_year;


 # otázka 5.
create view v_vs_otazka5 as (
			select *
			from t_veronika_smajda_project_sql_secondary_final 
			where country='Czech Republic');

WITH TAB_Z AS (
    SELECT average_wages,food_price,year  
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null and average_wages is not null
    group by year),
    TAB_W AS(
    SELECT average_wages,food_price,year+1 as prev_year
    FROM t_veronika_smajda_project_sql_primary_final1 tvspspf
    where food_price is not null and average_wages is not null
    group by prev_year),
    TAB_X AS (
    SELECT GDP,year  
    FROM v_vs_otazka5
    where GDP is not null
    group by year),
    TAB_Y AS(
    SELECT GDP,year+1 as year_before
    FROM v_vs_otazka5
    where GDP is not null
    group by year_before)
SELECT TAB_Z.*,prev_year,
round((TAB_Z.food_price-TAB_W.food_price)/TAB_Z.food_price*100,2) as price_grow_percent,
round((TAB_Z.average_wages-TAB_W.average_wages)/TAB_Z.average_wages*100,2) as wages_grow_percent,
round((TAB_X.GDP-TAB_Y.GDP)/TAB_X.GDP*100,2) as GDP_grow_percent
FROM TAB_Z join TAB_W
on TAB_Z.year=TAB_W.prev_year 
join TAB_X on TAB_Z.year=TAB_X.year
join TAB_Y on TAB_Z.year=TAB_Y.year_before
;






