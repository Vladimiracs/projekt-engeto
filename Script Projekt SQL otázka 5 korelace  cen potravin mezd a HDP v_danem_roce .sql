
create or replace view w_vsm_projekt_vyvoj_HDP as
select
*,
(gdp-hdp_minuly_rok)/hdp_minuly_rok *100 as narust_HDP_v_procentech
from
( select
*,
lag (gdp) over ( order by year) HDP_minuly_rok
from economies
where country = 'Czech Republic'
and year between 2006 and 2018
order by economies."year" )
where year between 2007 and 2018;

select*
from w_vsm_projekt_vyvoj_HDP;

create or replace view w_vsm_projekt_vyvoj_cen_a_mezd
as
select
rok,
avg (narust_cen_v_procentech) as prumerny_narust_cen,
avg (narůst_platu_v_procentech)as prumerny_narust_mezd,
avg (narust_cen_v_procentech) - avg (narůst_platu_v_procentech) as rozdil_mezi_rustem_cen_a_mezd,
case when avg (narust_cen_v_procentech) - avg (narůst_platu_v_procentech) > 10 then 'narust_cen_potravin_je_VYRAZNE_VYSSI_nez_narust_mezd'
when avg (narust_cen_v_procentech) - avg (narůst_platu_v_procentech) > 0 then 'narust_cen_potravin_je_vyssi_nez_narust_mezd'
else 'narust_cen_potravin_je_nizsí_nez_narust_mezd'
end
from t_vladimir_smid_project_SQL_primary_final
where rok between 2007 and 2018
group by rok
order by rok;

select*
from w_vsm_projekt_vyvoj_cen_a_mezd;

create table t_vladimir_smid_project_SQL_secondary_final
as
select *
from w_vsm_projekt_vyvoj_cen_a_mezd cm
join w_vsm_projekt_vyvoj_HDP hdp on cm.rok = hdp.year;

select*
from t_vladimir_smid_project_SQL_secondary_final;

create or replace view w_vsm_projekt_korelace_HDP_v_danem_roce as
select 
rok,
country,
narust_hdp_v_procentech,
prumerny_narust_cen,
prumerny_narust_mezd,
prumerny_narust_cen - narust_hdp_v_procentech as rozdil_mezi_narustem_HDP_a_cen,
prumerny_narust_mezd - narust_hdp_v_procentech as rozdil_mezi_narustem_HDP_a_mezd
from t_vladimir_smid_project_SQL_secondary_final;

select*
from w_vsm_projekt_korelace_HDP_v_danem_roce;







