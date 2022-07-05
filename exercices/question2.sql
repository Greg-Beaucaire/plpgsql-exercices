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
$$