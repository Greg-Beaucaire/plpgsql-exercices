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