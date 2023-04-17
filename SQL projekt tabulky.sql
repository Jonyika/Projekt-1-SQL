# TABULKA t_veronika_smajda_SQL_primary_final

CREATE TABLE IF NOT EXISTS t_veronika_smajda_project_SQL_primary_final AS (
		SELECT cpc.name AS food_category, 
	   		  cp2.value AS food_price,
	   		  cp.value AS average_wages,
	   		  cp.payroll_year AS 'year',
	   		  cpib.name AS industry
		FROM czechia_price cp2 
		JOIN czechia_payroll cp 
			ON cp.payroll_year=YEAR(cp2.date_from) 
			AND cp.value_type_code = 5958 
			AND cp2.region_code IS NULL    # - tahle podminka mi pomuze ignorovat radky, kde jsou castecne hodnoty v jendotlivych regionech (deleni podle jinych kriterii)
		JOIN czechia_price_category cpc 
			ON cp2.category_code=cpc.code
		JOIN czechia_payroll_industry_branch cpib 
			ON cp.industry_branch_code=cpib.code);


# TABULKA t_veronika_smajda_SQL_primary_secondary

CREATE TABLE IF NOT EXISTS t_veronika_smajda_project_SQL_secondary_final AS (
		SELECT te.GDP,
	   		  te.gini,
	   		  te.population,
	   		  te.`year`,
	   		  tc.country,
	   		  tc.continent
		FROM (
				SELECT GDP,
			    	   gini,
			    	   population,
			    	   `year`,
			    	   country
				FROM economies e 
				WHERE `year` BETWEEN 2006 AND 2018)te
		LEFT JOIN (
				SELECT country,
					continent
				FROM countries c
				WHERE continent='Europe')tc
		ON te.country=tc.country);


