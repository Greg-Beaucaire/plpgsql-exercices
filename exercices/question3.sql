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
$$