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
order by rozdil_mezi_rustem_cen_a_mezd DESC;

create or replace view w_vsm_projekt_korelace_HDP_v_minulem_roce as
select *,
lag (narust_hdp_v_procentech) over ( order by rok) narust_HDP_minuly_rok
from w_vsm_projekt_korelace_HDP_v_danem_roce;

select *
from w_vsm_projekt_korelace_HDP_v_minulem_roce;


select 
rok,
country,
prumerny_narust_cen,
prumerny_narust_mezd,
narust_HDP_minuly_rok,
prumerny_narust_cen - narust_HDP_minuly_rok as rozdil_mezi_narustem_HDP_minuly_rok_a_cen,
prumerny_narust_mezd - narust_HDP_minuly_rok as rozdil_mezi_narustem_HDP_minuly_rok_a_mezd
from w_vsm_projekt_korelace_HDP_v_minulem_roce
where rok between 2008 and 2018;
