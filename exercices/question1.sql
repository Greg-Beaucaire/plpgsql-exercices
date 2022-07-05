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
$$