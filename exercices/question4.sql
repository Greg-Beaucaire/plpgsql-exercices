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
$$