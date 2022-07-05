create or replace function exo6()
    returns varchar
    language plpgsql
as
$$
declare 
-- variable declaration
v_chauffeur_name varchar;
infos_camion record;
infos_chauffeur record;
v_id_chauffeur_array int[];
v_chauffeur_name_array varchar[];
_elem int;


begin
-- logic
SELECT
  nom
INTO
  v_chauffeur_name
FROM
  chauffeur
WHERE
  chauffeur.disponible = true;

IF v_chauffeur_name IS NOT NULL THEN
  RETURN CONCAT('Le chauffeur ',v_chauffeur_name, ' est noté comme disponible dans la base de donnée.');
END IF;

FOR infos_camion in SELECT id_chauffeur FROM camion WHERE id_chauffeur is not null
LOOP
  v_id_chauffeur_array := v_id_chauffeur_array || infos_camion.id_chauffeur;
END LOOP;

-- à l'attention de Manu: c'est toi qui a voulu ça. Un foreach dans un for, affronte son regard. 
FOR infos_chauffeur in SELECT nom, id_chauffeur FROM chauffeur
loop
  FOREACH _elem IN ARRAY v_id_chauffeur_array
  loop
    if infos_chauffeur.id_chauffeur != _elem then
    v_chauffeur_name_array := v_chauffeur_name_array || infos_chauffeur.nom;
    end if;
  end loop;

end loop;


IF v_chauffeur_name_array[1] IS NOT NULL THEN

  RETURN CONCAT('Le chauffeur ',v_chauffeur_name_array[1], ' n a pas de camion attribué.');
ELSE
  RETURN CONCAT('Aucun chauffeur n est disponible');
END IF;

END;
$$