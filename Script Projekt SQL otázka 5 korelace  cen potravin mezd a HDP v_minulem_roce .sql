

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
