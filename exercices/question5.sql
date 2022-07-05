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
$$