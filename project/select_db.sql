

-- wypisz naprawy które się zakończyły i nie wykorzystały części zamiennych

SELECT * FROM naprawa WHERE
  id NOT IN (
    SELECT naprawa_id FROM czesc_zamienna
  )
  AND data_zakonczenia IS NOT NULL
;

-- wypisz ile telefonów oddali do nparawy poszczególni klienci
SELECT imie, nazwisko , count(telefon.id) AS ile_telefonow
  FROM klient INNER JOIN telefon
    ON klient.id=klient_id
  GROUP BY imie, nazwisko
  ORDER BY nazwisko
;

-- wypisz czas naprawy usterki dla danego telefonu

SELECT telefon.id, rodzaj_usterki.nazwa AS rodzaj_usterki, model.nazwa AS nazwa_modelu, (data_zakonczenia-data_rozpoczecia) AS czas_naprawy_dni
  FROM ((( rodzaj_usterki INNER JOIN usterka
          ON rodzaj=rodzaj_usterki.id
        ) INNER JOIN naprawa
        ON usterka_id=usterka.id
      ) INNER JOIN telefon
      ON telefon_id=telefon.id
    ) INNER JOIN model
    ON model.id=model_id
  GROUP BY telefon.id, rodzaj_usterki.nazwa, model.nazwa,data_zakonczenia, data_rozpoczecia
  HAVING data_zakonczenia IS NOT NULL
  ORDER BY telefon.id
;

-- wypisz ile usterek danego typu zostalo przyjetych do naprawy
SELECT nazwa,
  ( SELECT COUNT(id)
    FROM usterka
    WHERE rodzaj_usterki.id=rodzaj
  ) as ilosc
FROM rodzaj_usterki
ORDER BY nazwa
;

--utwórz tabelę z kosztami napraw i kosztami części do nich użytych
CREATE VIEW naprawa_koszt AS
  SELECT id, koszt, usterka_id,
  ( SELECT COALESCE(SUM(cena), MONEY(0))
    FROM czesc_zamienna
    WHERE naprawa_id=naprawa.id
  ) as koszt_czesci
  FROM naprawa
  WHERE data_zakonczenia IS NOT NULL
;

--wypisz całkowity koszt poszczególnych napraw

SELECT id, (koszt+koszt_czesci) AS calkowity_koszt
  FROM naprawa_koszt
  ORDER BY id
;


--wypisz modele telefonów do których nie ma części zamiennych

SELECT id, nazwa FROM model
 WHERE NOT EXISTS (
   SELECT model_id FROM czesc_zamienna
   WHERE model.id=model_id
 )
;

--wypisz klientów którzy oddali Iphony do naprawy

SELECT imie, nazwisko, nazwa
  FROM (klient INNER JOIN telefon
      ON klient.id=klient_id
    ) INNER JOIN model
    ON model.id=model_id
  WHERE nazwa LIKE 'Iphone%'
;


--obniż o 10% koszt napraw jeszcze nie skończyly i trwają już powyżej 2 tyogdni

UPDATE naprawa
  SET koszt=koszt*0.9
  WHERE data_zakonczenia IS NULL
  AND (CURRENT_DATE-data_rozpoczecia)>14
;

--usuń naprawy które zakończyły się w 2019 roku

DELETE FROM naprawa
  WHERE data_zakonczenia IS NOT NULL
  AND data_zakonczenia<='2019.12.31'
;
