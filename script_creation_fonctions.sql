create or replace function exo1()
   returns int[]
   language plpgsql
as
$$
declare 
-- variable declaration
v_ptac int;
v_poids_vide int;
v_poids_chauffeur int;
v_id_chauffeur int;
v_camions_array int[];

BEGIN
 -- logic
  FOR index in 1..(select count(*) from camion) LOOP
    SELECT
      camion.id_chauffeur
    INTO
      v_id_chauffeur
    FROM
      camion
    WHERE
      camion.id_camion = index;

    if v_id_chauffeur is null then
      SELECT
        ptac,
        poids_vide
      INTO
        v_ptac,
        v_poids_vide
      FROM
        camion
      WHERE
        camion.id_camion = index;
      
      v_camions_array[index] := v_ptac - v_poids_vide;
    else
      SELECT
        ptac,
        poids_vide,
        poids
      INTO
        v_ptac,
        v_poids_vide,
        v_poids_chauffeur
      FROM
        camion
      INNER JOIN
        chauffeur ON camion.id_chauffeur = chauffeur.id_chauffeur
      WHERE
        camion.id_camion = index;
      v_camions_array[index] := v_ptac - v_poids_vide - v_poids_chauffeur;
    end if;
    
  END LOOP;

  return v_camions_array;

end;
$$;

create or replace function exo2(v_destination varchar)
    returns int
    language plpgsql
as
$$
declare 
-- variable declaration
selected_colis record;
total_poids_colis int := 0;
poids_colis int;

begin
 -- logic
for selected_colis in
select
  poids
FROM
  colis
WHERE
  destination = v_destination
LOOP
  poids_colis := selected_colis.poids;
  total_poids_colis := total_poids_colis + poids_colis;
end loop;

RETURN total_poids_colis;

end;
$$;

create or replace function exo3(v_immatriculation_camion varchar)
    returns int
    language plpgsql
as
$$
declare 
-- variable declaration
selected_chauffeur record;
poids_camion_theorique int;
v_ptac int;
v_poids_vide int;
v_poids_chauffeur_max int;

begin
 -- logic

select
  poids_vide,
  ptac
into
  v_poids_vide,
  v_ptac
FROM
  camion
WHERE
  immatriculation = v_immatriculation_camion;


SELECT
  chauffeur.poids
INTO
  v_poids_chauffeur_max
FROM
  chauffeur
ORDER BY
  poids DESC;

poids_camion_theorique := v_ptac - v_poids_vide - v_poids_chauffeur_max;

    
RETURN poids_camion_theorique;

end;
$$;

create or replace procedure exo4(v_numero_colis varchar, v_immatriculation_camion varchar)
    language plpgsql
as
$$
declare 
-- variable declaration
selected_colis record;
v_poids_effectif int;
v_poids_colis int;
v_id_camion int;
v_colis_id_camion int;
poids_colis_deja_present int := 0;

begin
 -- logic
LOCK TABLE colis IN ACCESS EXCLUSIVE MODE;
v_poids_effectif := (select exo3(v_immatriculation_camion));

-- extract camion id
SELECT
  camion.id_camion
INTO
  v_id_camion
FROM
  camion
WHERE
  camion.immatriculation = v_immatriculation_camion;

-- extract poids colis déjà présent dans le camion
for selected_colis in
select
  poids
FROM
  colis
WHERE
  id_camion = v_id_camion
LOOP
  poids_colis_deja_present := poids_colis_deja_present + selected_colis.poids;
end loop;

-- extract poids colis
SELECT
  poids,
  colis.id_camion
INTO
  v_poids_colis,
  v_colis_id_camion
FROM
  colis
WHERE
  numero = v_numero_colis;

IF(v_colis_id_camion = v_id_camion) THEN
  RAISE exception 'Le colis est déjà présent dans le camion %', v_immatriculation_camion;
END IF;

IF (v_poids_effectif - poids_colis_deja_present) < v_poids_colis THEN
  RAISE exception 'Le poids du colis est supérieur au poids effectif du camion %', v_immatriculation_camion;
ELSE
  UPDATE
    colis
  SET
    id_camion = v_id_camion
  WHERE
    numero = v_numero_colis;
  RAISE INFO 'Le colis a été affecté au camion %', v_immatriculation_camion;
END IF;

commit;
end;
$$;

create or replace function exo5(v_param_destination varchar, v_param_index int)
    returns varchar
    language plpgsql
as
$$
declare 
-- variable declaration
rec_colis record;
cur_colis cursor(v_param_destination varchar)
  for select numero from colis where destination = v_param_destination;


begin
-- logic

open cur_colis(v_param_destination);

move forward (v_param_index - 1) from cur_colis;

fetch cur_colis into rec_colis;

if rec_colis.numero is null then
  return 'Colis inexistant';
else
  return rec_colis.numero;
end if;

end;
$$;

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
$$;

CREATE FUNCTION update_camion_chauffeur() RETURNS trigger AS $trig_update_camion_chauffeur$
    
    declare
    -- variable declaration
    v_id_colis int;
    
    BEGIN

    select
      id_colis
    into
      v_id_colis
    from
      colis
    where
      id_camion = OLD.id_camion;

    IF OLD.id_chauffeur is not null AND v_id_colis is not null THEN
      RAISE EXCEPTION 'Un chauffeur et au moins un colis sont déjà affectés au camion %', OLD.immatriculation;
    END IF;

    IF OLD.id_chauffeur = NEW.id_chauffeur THEN
        RAISE EXCEPTION 'Ce chaffeur est déjà affecté à ce camion';
    END IF;

    IF NEW.id_chauffeur is null then
      UPDATE chauffeur
      SET disponible = true
      WHERE id_chauffeur = OLD.id_chauffeur;
      RAISE INFO 'Le chauffeur % est à nouveau disponible.', OLD.id_chauffeur;
    END IF;

    RETURN NEW;
    END;
$trig_update_camion_chauffeur$ LANGUAGE plpgsql;

CREATE TRIGGER trig_update_camion_chauffeur BEFORE UPDATE ON camion
    FOR EACH ROW EXECUTE PROCEDURE update_camion_chauffeur();