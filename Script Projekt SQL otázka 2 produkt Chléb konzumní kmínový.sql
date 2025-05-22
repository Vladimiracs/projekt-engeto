create temporary table tmp_vsm_projekt_ceny as
select
cp.category_code ,
cpc.name as nazev,
cpc.price_unit,
date_part('year', date_from) as rok ,
avg (cp.value) as prumerna_cena,
lag ( avg (cp.value)) over (order by cpc.name )as prumcena_minulyrok ,
avg (cp.value) - lag ( avg (cp.value)) over (order by cpc.name ) as narust_cen_v_Kc,
(avg (cp.value) - lag ( avg (cp.value)) over (order by cpc.name ))/lag ( avg (cp.value)) over (order by cpc.name )*100 as narust_cen_v_procentech
from czechia_price cp
join czechia_price_category cpc on cp.category_code = cpc.code
group by rok, cp.category_code, nazev, cpc.price_unit
order by nazev, rok ;


create temporary table tmp_vsm_projekt_mzdy as
select
cpib.name,
cp.payroll_year as rok_vyplaty,
cp.industry_branch_code,
avg(cp.value) as prumerny_plat,
lag (avg(cp.value)) over (order by cp.industry_branch_code,cp.payroll_year) as prumerny_plat_predchozi_rok,
avg(cp.value) - lag (avg(cp.value)) over (order by cp.industry_branch_code,cp.payroll_year) as narůst_platu_v_Kc,
(avg(cp.value) - lag (avg(cp.value)) over (order by cp.industry_branch_code,cp.payroll_year))/avg(cp.value)*100 as narůst_platu_v_procentech,
case
when avg(cp.value) - lag (avg(cp.value)) over (order by cp.industry_branch_code,cp.payroll_year) > 0 then 'rostoucí' else 'klesající'
end as trend
from czechia_payroll cp
join czechia_payroll_industry_branch cpib on cp.industry_branch_code = cpib.code
where (cp.value_type_code=5958 and cp.unit_code = 200 and cp.calculation_code = 200 )
group by cpib.name,cp.payroll_year,cp.industry_branch_code
order by cp.industry_branch_code,cp.payroll_year ;


create table t_vladimir_smid_project_SQL_primary_final as
select*
from tmp_vsm_projekt_ceny
join tmp_vsm_projekt_mzdy on tmp_vsm_projekt_ceny.rok = tmp_vsm_projekt_mzdy.rok_vyplaty ;

select 
category_code ,
nazev ,
rok,
prumerna_cena,
name,
prumerny_plat,
prumerny_plat / prumerna_cena as kupni_sila
from t_vladimir_smid_project_SQL_primary_final
where rok in (2006,2018) and category_code = 111301
order by name, rok;



