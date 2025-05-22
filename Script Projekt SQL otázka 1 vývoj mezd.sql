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

select 
name,
industry_branch_code,
rok_vyplaty,
narůst_platu_v_procentech
from tmp_vsm_projekt_mzdy
where rok_vyplaty between 2001 and 2021 ;

select 
name,
industry_branch_code,
avg (narůst_platu_v_procentech) as prumerny_narust_00_21
from 
(select 
name,
industry_branch_code,
rok_vyplaty,
narůst_platu_v_procentech
from tmp_vsm_projekt_mzdy
where rok_vyplaty between 2001 and 2021 )
group by (name, industry_branch_code)
order by (prumerny_narust_00_21);









