# Projekt-SQL

V této analýze se zabývám životní úrovní občanů ČR v letech 2006-2018, zejména dostupností základních potravin široké veřejnosti a pokusím se odpovědět na několik základních otázek:
1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuálně meziroční nárůst)?
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném       nebo následujícím roce výraznějším růstem?

Pro zodpovězení výzkumných otázek jsem si vytvořila dvě finální tabulky:

1.	t_veronika_smajda_SQL_primary_final

Jako podklad jsem použila datové sady z Portálu otevřených dat ČR:
-	czechia_payroll - Informace o mzdách v různých odvětvích za několikaleté období
-	czechia_price - Informace o cenách vybraných potravin za několikaleté období
-	czechia_price_category - Číselník kategorií potravin, které se vyskytují v přehledu
-	czechia_payroll_industry_branch - Číselník odvětví v tabulce mezd
V této tabulce jsem shrnula ceny potravin v jednotlivých kategoriích a mzdy v různých odvětvích v daném časovém rozmezí. Potřebovala jsem získat data ve stejných letech, proto jsem v tabulce czechia_price použila funkci YEAR a ze zadaných datumů (sloupec date_from) získala pouze rok.
Finální tabulku jsem vytvořila použitím funkce JOIN, kde jsem nejdřív k tabulce czechia_price přidala tabulku czechia_payroll (spojení přes year). K tomu jsem připojila tabulku czechia_price_category (spojení přes category_code) a závěrem tabulku czechia_payroll_industry_branch (spojení přes industry_branch_code).
Finální tabulka obsahuje sloupce: food_category, food_price, average_wages, year, industry.

2.	t_veronika_smajda_SQL_secondary_final

Jako podklad jsem použila doplňující datové sady:
-	countries – Různé informace o státech světa
-	economies – HDP, gini, daňová zátěž atd. pro jednotlivé země světa
V této tabulce jsem shrnula HDP, koeficient gini a populaci v jednotlivých státech Evropy v zadaných letech.
Jelikož tabulka economies obsahuje údaje za větší časové období, než je požadavek naší analýzy, proto jsem si připravila mezi-tabulku, která obsahuje jenom údaje pro roky 2006-2018.
Tabulka countries uvádí data všech zemí světa, přičemž pro potřeby analýzy jsou postačující Evropské státy. Tím pádem jsem si i tady vytvořila mezi-tabulku s daty jenom pro Evropské státy.
Finální tabulka vznikla spojením těchto dvou mezi-tabulek, pomocí funkce LEFT JOIN, přes sloupec country.
Tabulka obsahuje sloupce: GDP, gini, population, year, country, continent.

Jednotlivé SQL dotazy pro tvorbu tabulek najdete v scriptu SQL projekt tabulky.

SQL dotazy pro jednotlivé výzkumné otázky jsem definovala ve scriptu SQL projekt otazky.

Výsledná zjištění popisuji v dokumentu Výsledky.
