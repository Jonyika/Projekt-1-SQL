# otázka 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
# Pro ukázku vývoje mezd v daném časovém rozpětí jsem si zvolila roky 2006,2010 a 2018.
SELECT t_2006.industry,
	   ROUND(AVG(t_2006.average_wages_2006),2) AS avg_wages_2006,
	   ROUND(AVG(t_2010.average_wages_2010),2) AS avg_wages_2010,
	   ROUND(AVG(t_2018.average_wages_2018),2) AS avg_wages_2018,
CASE WHEN AVG(t_2018.average_wages_2018) > AVG(t_2010.average_wages_2010) THEN 'increase_2018'
	 WHEN AVG(t_2010.average_wages_2010) > AVG(t_2006.average_wages_2006) THEN 'increase_2010'
	 ELSE 'decrease'
	 END AS changes
FROM (
		SELECT DISTINCT industry,
						average_wages AS average_wages_2006,
						`year`
		FROM t_veronika_smajda_project_sql_primary_final pf
		WHERE YEAR ='2006') t_2006
LEFT JOIN (
			SELECT DISTINCT industry,
							average_wages as average_wages_2010,
							`year`
			FROM t_veronika_smajda_project_sql_primary_final spf
			WHERE YEAR='2010') t_2010
	ON t_2006.industry=t_2010.industry
LEFT JOIN (
			SELECT DISTINCT industry,
							average_wages as average_wages_2018,
							`year`
			FROM t_veronika_smajda_project_sql_primary_final spf
			WHERE YEAR='2018') t_2018
ON t_2010.industry=t_2018.industry
GROUP BY t_2006.`year`,
		 t_2006.industry;


# otázka 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT food_category,
	   ROUND(AVG(food_price),2) AS avg_food_price,
	   ROUND(AVG(average_wages),2) AS avg_wages,
	   ROUND(AVG(average_wages)/AVG(food_price),0) AS amount_to_buy,
	   `year`
FROM t_veronika_smajda_project_sql_primary_final pf
WHERE food_category IN ('Chléb konzumní kmínový','Mléko polotučné pasterované') 
	  AND `year` IN ('2006','2018')
GROUP BY `year`,
		 food_category
ORDER BY `year`;


 # otázka 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH t_year AS (
    	SELECT food_category,
    	   		AVG(food_price) AS avg_price_year,
    	   		YEAR  
    	FROM t_veronika_smajda_project_sql_primary_final pf
    	GROUP BY food_category,
    			YEAR),
    t_prev_year AS (
       SELECT food_category,
    	      AVG(food_price) AS avg_price_prev_year,
    	      YEAR+1 AS prev_year
       FROM t_veronika_smajda_project_sql_primary_final pf
       WHERE food_price IS NOT NULL
       GROUP BY food_category,
    		    prev_year)
SELECT t_year.food_category,
	   t_year.YEAR,
	   prev_year,
ROUND((avg_price_year - avg_price_prev_year)/avg_price_year*100,2) AS price_grow_percent
FROM t_year 
JOIN t_prev_year
	ON t_year.food_category=t_prev_year.food_category
	AND t_year.YEAR=t_prev_year.prev_year
ORDER BY price_grow_percent;

 
 # otázka 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH t_year AS (
      SELECT AVG(average_wages) AS avg_wages_year,
      		 AVG(food_price) AS avg_price_year,
    	     YEAR  
      FROM t_veronika_smajda_project_sql_primary_final pf
      WHERE food_price IS NOT NULL 
    	    AND average_wages IS NOT NULL
      GROUP BY YEAR),
    t_prev_year AS(
       SELECT AVG(average_wages) AS avg_wages_prev_year,
      		  AVG(food_price) AS avg_price_prev_year,
    		  YEAR+1 AS prev_year
      FROM t_veronika_smajda_project_sql_primary_final pf
      WHERE food_price IS NOT null
      		AND average_wages IS NOT NULL
      GROUP BY prev_year)
SELECT t_year.YEAR,
		prev_year,
		ROUND((avg_price_year - avg_price_prev_year)/avg_price_year * 100,2) AS price_grow_percent,
		ROUND((avg_wages_year - avg_wages_prev_year)/avg_wages_year * 100,2) AS wages_grow_percent,
CASE WHEN (avg_price_year - avg_price_prev_year)/avg_price_year * 100 - (avg_wages_year - avg_wages_prev_year)/avg_wages_year * 100 >10 THEN 'above 10'
	 ELSE 'below 10'
	 END AS grow
FROM t_year 
JOIN t_prev_year 
	ON t_year.YEAR=t_prev_year.prev_year;


 # otázka 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 # Pro zodpovězení této otázky jsem si vytvořila pomocný pohled v_vs_otazka5
CREATE VIEW IF NOT EXISTS  v_vs_otazka5 AS (
			SELECT *
			FROM t_veronika_smajda_project_sql_secondary_final 
			WHERE country='Czech Republic');

WITH t_year AS (
    			SELECT AVG(average_wages) AS avg_wages_year,
    	   			   AVG(food_price) AS avg_food_price_year,
    	   				YEAR  
    			FROM t_veronika_smajda_project_sql_primary_final pf
    			WHERE food_price IS NOT NULL 
    	  		AND average_wages IS NOT NULL
    			GROUP BY YEAR),
    t_prev_year AS (
    			SELECT AVG(average_wages) AS avg_wages_prev_year,
    	   			   AVG(food_price) AS avg_food_price_prev_year,
    	   				YEAR+1 AS prev_year
    					FROM t_veronika_smajda_project_sql_primary_final pf
    					WHERE food_price IS NOT NULL 
    	  				AND average_wages IS NOT NULL
    			GROUP BY prev_year),
    t_year_GDP AS (
    			SELECT AVG(GDP) AS avg_gdp_year,
    	   				YEAR  
    			FROM v_vs_otazka5
    			WHERE GDP IS NOT NULL
    			GROUP BY YEAR),
    t_prev_GDP AS (
    			SELECT AVG(GDP) AS avg_gdp_prev_year,
    	   				YEAR+1 AS year_before
    			FROM v_vs_otazka5
    			WHERE GDP IS NOT NULL
    			GROUP BY year_before)
SELECT t_year.YEAR,
	   prev_year,
	   ROUND((avg_food_price_year  - avg_food_price_prev_year)/avg_food_price_year * 100,2) AS price_grow_percent,
	   ROUND((avg_wages_year - avg_wages_prev_year)/avg_wages_year * 100,2) AS wages_grow_percent,
	   ROUND((avg_gdp_year - avg_gdp_prev_year)/avg_gdp_year * 100,2) AS GDP_grow_percent
FROM t_year 
JOIN t_prev_year
	ON t_year.YEAR=t_prev_year.prev_year 
JOIN t_year_GDP
	ON t_year.YEAR=t_year_GDP.YEAR
JOIN t_prev_GDP
	ON t_year.YEAR=t_prev_GDP.year_before;






