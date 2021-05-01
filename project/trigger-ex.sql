
--dodajemy zły model części do naprawy
INSERT INTO czesc_zamienna (model_id, rodzaj, cena, naprawa_id) VALUES (7,'klej',30,13);

--dodajemy dobry model części do naprawy

INSERT INTO czesc_zamienna (model_id, rodzaj, cena, naprawa_id) VALUES (8,'klej',25,6);

--usuwamy i archiwizujemy wszystkie naprawy które się zakończyły

DELETE FROM naprawa
  WHERE data_zakonczenia IS NOT NULL
;
