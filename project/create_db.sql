SET client_encoding='utf-8';

create table klient
(
	id						serial									,
	imie					varchar(16)			NOT NULL,
	nazwisko			varchar(32)			NOT NULL,
	email					varchar(64)							,
	telefon				varchar(11)							,
	CONSTRAINT		klient_id_pk PRIMARY KEY(id),
	CONSTRAINT		check_null CHECK (email IS NOT NULL OR telefon IS NOT NULL)
);

create table model
(
	id						serial									,
	nazwa					varchar(64)			NOT NULL,
	CONSTRAINT		model_id_pk PRIMARY KEY(id)
);

create table telefon
(
	id						serial									,
	klient_id			int							NOT NULL,
	model_id			int							NOT NULL,
	data_oddania	date						NOT NULL,
	data_odbioru	date										,
	CONSTRAINT		dates CHECK(data_oddania<=data_odbioru),
	CONSTRAINT		telefon_id_pk PRIMARY KEY(id),
	CONSTRAINT		klient_fk FOREIGN KEY(klient_id)
									REFERENCES klient(id),
	CONSTRAINT		model_fk FOREIGN KEY(model_id)
									REFERENCES model(id)
);

create table rodzaj_usterki
(
	id						serial									,
	nazwa					varchar(64)			NOT NULL,
	CONSTRAINT		rodzaj_ust_id_pk PRIMARY KEY(id)

);

create table usterka
(
	id						serial									,
	telefon_id		int							NOT NULL,
	rodzaj				int							NOT NULL,
	CONSTRAINT		usterka_id_pk PRIMARY KEY(id),
	CONSTRAINT		rodzaj_ust_fk FOREIGN KEY(rodzaj)
									REFERENCES rodzaj_usterki(id),
	CONSTRAINT		telefon_fk FOREIGN KEY(telefon_id)
									REFERENCES telefon(id)
);

create table pracownik
(
	id						serial								,
	imie					varchar(16)		NOT NULL,
	nazwisko			varchar(32)		NOT NULL,
	CONSTRAINT		pracownik_id_pk PRIMARY KEY(id)
);

create table specjalizacja
(
	pracownik_id	int						NOT NULL,
	rodzaj_id			int						NOT NULL,
	CONSTRAINT		spec_prac_fk FOREIGN KEY(pracownik_id)
									REFERENCES pracownik(id),
	CONSTRAINT		spec_rodzaj_fk FOREIGN KEY(rodzaj_id)
									REFERENCES rodzaj_usterki(id)
);

create table naprawa
(
	id						serial								,
	usterka_id		int						NOT NULL,
	pracownik_id	int						NOT NULL,
	koszt					money					NOT NULL,
	data_rozpoczecia 	date			NOT NULL,
	data_zakonczenia 	date							,
	CONSTRAINT		dates CHECK(data_rozpoczecia<=data_zakonczenia),
	CONSTRAINT		naprawa_id_pk PRIMARY KEY(id),
	CONSTRAINT		usterka_fk FOREIGN KEY(usterka_id)
									REFERENCES usterka(id),
	CONSTRAINT		pracownik_fk FOREIGN KEY(pracownik_id)
									REFERENCES pracownik(id)
);

create table czesc_zamienna
(
	id						serial								,
	model_id			int						NOT NULL,
	rodzaj				varchar(64)		NOT NULL,
	cena					money					NOT NULL,
	naprawa_id		int										,
	CONSTRAINT		czesc_id_pk PRIMARY KEY(id),
	CONSTRAINT		model_fk FOREIGN KEY(model_id)
									REFERENCES model(id),
	CONSTRAINT		naprawa_fk FOREIGN KEY(naprawa_id)
									REFERENCES naprawa(id)
									ON DELETE SET NULL
);

create table naprawa_arch
(
	id						int						NOT NULL,
	usterka_id		int						NOT NULL,
	pracownik_id	int						NOT NULL,
	koszt					money					NOT NULL,
	data_rozpoczecia 	date			NOT NULL,
	data_zakonczenia 	date							,
	CONSTRAINT		naprawa_arch_pk PRIMARY KEY(id),
	czas_usuniecia	timestamp						
);
