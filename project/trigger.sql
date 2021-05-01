

--reguła sprawdza czy do naprawy danego modelu telefonu
--jeśli została użyta zła część informuje o błędzie i wskazuje która część powinna zostać użyta

CREATE OR REPLACE FUNCTION check_model()
  RETURNS TRIGGER AS $$
DECLARE model_naprawa int;
BEGIN
  SELECT model.id
    FROM ((( model INNER JOIN telefon
          ON model.id=telefon.model_id
        ) INNER JOIN usterka
        ON telefon_id=telefon.id
      ) INNER JOIN naprawa
      ON usterka_id=usterka.id
    ) INNER JOIN czesc_zamienna
    ON NEW.naprawa_id=naprawa.id
  INTO model_naprawa;
  IF NEW.model_id <> model_naprawa THEN
    RAISE NOTICE 'Użyto złego modelu części do naprawy, powinno się użyć modelu nr%', model_naprawa;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE 'plpgsql'
;

CREATE TRIGGER check_same_model
    AFTER INSERT ON czesc_zamienna
    FOR EACH ROW
    EXECUTE PROCEDURE check_model()
;

-- Po usunięciu naprawy dodaje ja do archiwum z datą usunięcia

CREATE RULE archiwizuj AS
  ON DELETE TO naprawa
  DO ALSO INSERT INTO naprawa_arch
    VALUES (old.id, old.usterka_id, old.pracownik_id, old.koszt, old.data_rozpoczecia, old.data_zakonczenia, current_timestamp)
;
