

create temporary table tmp_vsm_projekt_ceny_2006_2018 as
select 
nazev,
avg (prumerna_cena ) as prumerna_cena,
rok 
from t_vladimir_smid_project_SQL_primary_final
where rok = 2018 or rok = 2006
group by nazev, rok,t_vladimir_smid_project_sql_primary_final.prumerna_cena
order by nazev, rok;

select *,
lag ("prumerna_cena") over (order by nazev) as prumerna_cena_2006 
from tmp_vsm_projekt_ceny_2006_2018;

select 
nazev,
rok,
prumerna_cena,
prumerna_cena_2006,
(prumerna_cena - prumerna_cena_2006) / prumerna_cena_2006 *100 as vývoj_cen_mezi_2006_2018,
case when (prumerna_cena - prumerna_cena_2006 ) > 0 then 'narust'
else 'pokles'
end as vyvoj_cen_mezi_2006_2018
from (select *,
lag ("prumerna_cena") over (order by nazev) as prumerna_cena_2006 
from tmp_vsm_projekt_ceny_2006_2018 )
where rok = 2018
order by ((prumerna_cena - prumerna_cena_2006) / prumerna_cena_2006 *100 );





