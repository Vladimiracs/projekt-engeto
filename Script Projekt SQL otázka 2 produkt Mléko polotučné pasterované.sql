select 
category_code ,
nazev ,
rok,
prumerna_cena,
name,
prumerny_plat,
prumerny_plat / prumerna_cena as kupni_sila
from t_vladimir_smid_project_SQL_primary_final
where rok in (2006,2018) and category_code = 114201
order by name, rok;
