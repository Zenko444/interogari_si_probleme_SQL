DROP TABLE IF EXISTS rezervari_restaurante CASCADE;
DROP TABLE IF EXISTS rezervari_mese CASCADE;
DROP TABLE IF EXISTS com_mancare CASCADE;
DROP TABLE IF EXISTS com_bauturi CASCADE;
DROP TABLE IF EXISTS bonuri_fiscale CASCADE;
DROP TABLE IF EXISTS ture CASCADE;
DROP TABLE IF EXISTS chelneri CASCADE;
DROP TABLE IF EXISTS bucatari CASCADE;
DROP TABLE IF EXISTS manageri CASCADE;
DROP TABLE IF EXISTS comenzi_produse_furnizori CASCADE;
DROP TABLE IF EXISTS comenzi CASCADE;
DROP TABLE IF EXISTS rezervari CASCADE;
DROP TABLE IF EXISTS mancaruri CASCADE;
DROP TABLE IF EXISTS bauturi CASCADE;
DROP TABLE IF EXISTS clienti CASCADE;
DROP TABLE IF EXISTS angajati CASCADE;
DROP TABLE IF EXISTS mese CASCADE;
DROP TABLE IF EXISTS restaurante CASCADE;
DROP TABLE IF EXISTS produse CASCADE;
DROP TABLE IF EXISTS furnizori CASCADE;
DROP TABLE IF EXISTS localitati CASCADE;

CREATE TABLE localitati (
    id_localitate NUMERIC(5) PRIMARY KEY NOT NULL,
    nume_localitate VARCHAR(70) NOT NULL,
    judet VARCHAR(30) NOT NULL
);

CREATE TABLE restaurante (
    id_restaurant NUMERIC(5) PRIMARY KEY,
    den_rest VARCHAR(50) NOT NULL,
    adresa_rest VARCHAR NOT NULL,
    id_localitate NUMERIC(5) NOT NULL REFERENCES localitati(id_localitate),
    nr_locuri_restaurant INT4 NOT NULL
);

CREATE TABLE clienti (
    id_client NUMERIC(7) PRIMARY KEY,
    nume VARCHAR(40) NOT NULL,
    prenume VARCHAR(40) NOT NULL,
    telefon VARCHAR(20) UNIQUE NOT NULL,
    e_mail VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE mese (
    id_masa NUMERIC(5) PRIMARY KEY NOT NULL,
    id_restaurant NUMERIC(5) NOT NULL REFERENCES restaurante(id_restaurant),
    masa_nr INT2 NOT NULL,
    nr_locuri_masa INT2 NOT NULL,
	observatii VARCHAR(100) NOT NULL
);

CREATE TABLE rezervari (
    id_rezervare NUMERIC(10) PRIMARY KEY,
    data_ore_rezervare TIMESTAMP NOT NULL,
	id_client NUMERIC(7) REFERENCES clienti(id_client),
    data_ora_sosire TIMESTAMP NOT NULL,
    data_ora_plecare TIMESTAMP NOT NULL
);

CREATE TABLE angajati (
    id_angajat NUMERIC(5) PRIMARY KEY,
    nume_angajat VARCHAR(50) NOT NULL,
    prenume_angajat VARCHAR(50) NOT NULL,
    cnp_angajat BPCHAR(13) UNIQUE NOT NULL,
    data_nasterii DATE NOT NULL,
    data_angajarii DATE NOT NULL,
    id_restaurant NUMERIC(5) NOT NULL REFERENCES restaurante(id_restaurant),
    telefon BPCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE chelneri (
    id_chelner NUMERIC(5) PRIMARY KEY,
    punctaj_ultima_evaluare NUMERIC(4,2),
    data_ultimei_evaluari DATE,
	FOREIGN KEY (id_chelner) REFERENCES angajati(id_angajat)
);

CREATE TABLE bucatari (
    id_bucatar NUMERIC(5) PRIMARY KEY,
    specializari VARCHAR(1000),
    data_ultimei_specializari DATE,
	FOREIGN KEY (id_bucatar) REFERENCES angajati(id_angajat)
);

CREATE TABLE manageri (
	id_manager NUMERIC(5) PRIMARY KEY,
	id_restaurant NUMERIC(5) REFERENCES restaurante(id_restaurant),
	data_numirii DATE,
	FOREIGN KEY (id_manager) REFERENCES angajati(id_angajat)

);

CREATE TABLE ture (
    id_angajat NUMERIC(5), -- Add column for id_angajat
    data_ora_inceput_tura TIMESTAMP NOT NULL, -- Add column for data_ora_inceput_tura
    data_ora_sfarsit_tura TIMESTAMP NOT NULL,
    observatii VARCHAR(500) NOT NULL,
    PRIMARY KEY (id_angajat, data_ora_inceput_tura),  -- Composite primary key
    FOREIGN KEY (id_angajat) REFERENCES angajati(id_angajat)  -- Foreign key constraint
);

CREATE TABLE rezervari_restaurante (
    id_rezervare NUMERIC(10),
    id_restaurant NUMERIC(5),
    observatii VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_rezervare, id_restaurant),  -- Composite primary key
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant),
	FOREIGN KEY (id_rezervare) REFERENCES rezervari(id_rezervare)-- Foreign key constraint
);


CREATE TABLE furnizori (
    id_furnizor numeric(5) PRIMARY KEY NOT NULL,
    den_furn VARCHAR(70) NOT NULL,
    tip_furn VARCHAR(50) NOT NULL,
	adresa_furn VARCHAR NOT NULL,
    id_localitate_furnizor NUMERIC(5) REFERENCES localitati(id_localitate)
);

CREATE TABLE produse (
    id_produs NUMERIC(6) PRIMARY KEY,
    den_produs VARCHAR(70) NOT NULL,
    categorie_produs VARCHAR(50) NOT NULL
);

CREATE TABLE comenzi (
    id_comanda NUMERIC(12) PRIMARY KEY NOT NULL,
    data_ora_comanda TIMESTAMP NOT NULL, 
    id_chelner NUMERIC(5) REFERENCES chelneri(id_chelner),
    id_masa NUMERIC(5) REFERENCES mese(id_masa),
    observatii VARCHAR(100) NOT NULL
);

CREATE TABLE bauturi (
    id_bautura NUMERIC(5) PRIMARY KEY,
    denumire_in_meniu VARCHAR(40) NOT NULL,
	data_adaugarii_in_meniu DATE NOT NULL, 
	tip_bautura VARCHAR(35) NOT NULL, 
	alcoolemie FLOAT(8),
    id_produs NUMERIC(5) REFERENCES produse(id_produs),
	cantitate_portie NUMERIC NOT NULL, 
    pret_unitar NUMERIC(10,2) NOT NULL
);

CREATE TABLE com_bauturi (
    id_comanda NUMERIC(12),
    id_bautura NUMERIC(6),
    cantitate_comandata NUMERIC(3) NOT NULL,
    pret_unitar NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (id_comanda, id_bautura),  -- Composite primary key
    FOREIGN KEY (id_bautura) REFERENCES bauturi(id_bautura),  -- Foreign key reference to bauturi
    FOREIGN KEY (id_comanda) REFERENCES comenzi(id_comanda)  -- Foreign key reference to comenzi
);


CREATE TABLE mancaruri (
    id_sortiment_mancare NUMERIC(6) PRIMARY KEY,
    denumire_in_meniu VARCHAR(40) NOT NULL,
	data_adaugarii_in_meniu DATE NOT NULL, 
	tip_mancare VARCHAR(35) NOT NULL, 
    id_produs NUMERIC(6) REFERENCES produse(id_produs),
	gramaj_portie NUMERIC NOT NULL, 
    pret_unitar NUMERIC NOT NULL
);


CREATE TABLE com_mancare (
    id_comanda NUMERIC(12),
    id_sortiment_mancare NUMERIC(6),
    nr_portii_comandate NUMERIC(3) NOT NULL,
    pret_unitar NUMERIC(6,2) NOT NULL,
    PRIMARY KEY (id_comanda, id_sortiment_mancare),  -- Primary key defined after column definitions
    FOREIGN KEY (id_sortiment_mancare) REFERENCES mancaruri(id_sortiment_mancare),
    FOREIGN KEY (id_comanda) REFERENCES comenzi(id_comanda)
);

CREATE TABLE rezervari_mese (
    id_rezervare NUMERIC(10),
    id_masa NUMERIC(5),
    observatii VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_rezervare, id_masa),  -- Primary key constraint should come after all columns
    FOREIGN KEY (id_masa) REFERENCES mese(id_masa),
    FOREIGN KEY (id_rezervare) REFERENCES rezervari(id_rezervare)
);

CREATE TABLE bonuri_fiscale(
	id_bon_f NUMERIC(10) PRIMARY KEY,
	nr_bon_f VARCHAR(20) NOT NULL,
	data_ora_bon_f TIMESTAMP NOT NULL, 
	id_comanda NUMERIC(12) REFERENCES comenzi(id_comanda),
	suma_bon_f NUMERIC(10,2) NOT NULL, 
	mod_incasare VARCHAR(20) NOT NULL, 
	id_client NUMERIC(7) REFERENCES clienti(id_client)
);

CREATE TABLE comenzi_produse_furnizori (
	id_comanda_furnizor NUMERIC(10,0) PRIMARY KEY,
	data_ora_comanda TIMESTAMP NOT NULL,
	id_restaurant NUMERIC(5,0)  NOT NULL REFERENCES restaurante(id_restaurant),
	id_furnizor NUMERIC(5,0) REFERENCES furnizori(id_furnizor),
	id_produs NUMERIC(6,0) REFERENCES produse(id_produs),
	cantitate NUMERIC NOT NULL,
	pret_total NUMERIC NOT NULL


);

INSERT INTO localitati (id_localitate, nume_localitate, judet) VALUES
(1, 'Bucuresti', 'Bucuresti'),
(2, 'Iasi', 'Iasi'),
(3, 'Cluj-Napoca', 'Cluj'),
(4, 'Timisoara', 'Timis'),
(5, 'Constanta', 'Constanta'),
(6, 'Craiova', 'Dolj'),
(7, 'Brasov', 'Brasov'),
(8, 'Galati', 'Galati'),
(9, 'Ploiesti', 'Prahova'),
(10, 'Braila', 'Braila'),
(11, 'Bacau', 'Bacau'),
(12, 'Arad', 'Arad'),
(13, 'Pitesti', 'Arges'),
(14, 'Sibiu', 'Sibiu'),
(15, 'Targu Mures', 'Mures'),
(16, 'Baia Mare', 'Maramures'),
(17, 'Buzau', 'Buzau'),
(18, 'Satu Mare', 'Satu Mare'),
(19, 'Botosani', 'Botosani'),
(20, 'Ramnicu Valcea', 'Valcea');

-- Populare tabel restaurante
INSERT INTO restaurante (id_restaurant, den_rest, adresa_rest, id_localitate, nr_locuri_restaurant) VALUES
(20, 'Restaurantul Central', 'Strada Principala 1', 1, 150),
(21, 'Terasa cu Flori', 'Strada Florilor 5', 2, 80),
(22, 'Restaurantul Italian', 'Strada Italiana 10', 3, 120),
(23, 'Restaurantul Chinezesc', 'Strada Chineza 15', 4, 100),
(24, 'Restaurantul Grecesc', 'Strada Greceasca 20', 5, 90),
(25, 'Restaurantul Mexican', 'Strada Mexicana 25', 6, 110),
(26, 'Restaurantul Frantuzesc', 'Strada Franceza 30', 7, 130),
(27, 'Restaurantul Spaniol', 'Strada Spaniola 35', 8, 140),
(28, 'Restaurantul Japonez', 'Strada Japoneza 40', 9, 160),
(29, 'Restaurantul Indian', 'Strada Indiana 45', 10, 170),
(30, 'Restaurantul Românesc', 'Strada Romaneasca 50', 11, 180),
(31, 'Restaurantul American', 'Strada Americana 55', 12, 190),
(32, 'Restaurantul Turcesc', 'Strada Turceasca 60', 13, 200),
(33, 'Restaurantul Libanez', 'Strada Libaneza 65', 14, 210),
(34, 'Restaurantul Coreean', 'Strada Coreeana 70', 15, 220),
(35, 'Restaurantul Thai', 'Strada Thailandeza 75', 16, 230),
(36, 'Restaurantul Vietnamez', 'Strada Vietnameza 80', 17, 240),
(37, 'Restaurantul Argentinian', 'Strada Argentiniana 85', 18, 250),
(38, 'Restaurantul Brazilian', 'Strada Braziliana 90', 19, 260),
(39, 'Restaurantul Peruan', 'Strada Peruana 95', 20, 270);

-- Populare tabel clienti
INSERT INTO clienti (id_client, nume, prenume, telefon, e_mail) VALUES
(1, 'Popescu', 'Ion', '0722123456', 'ion.popescu@gmail.com'),
(2, 'Ionescu', 'Maria', '0723123456', 'maria.ionescu@gmail.com'),
(3, 'Georgescu', 'Andrei', '0724123456', 'andrei.georgescu@gmail.com'),
(4, 'Dumitrescu', 'Elena', '0725123456', 'elena.dumitrescu@gmail.com'),
(5, 'Avram', 'Mihai', '0726123456', 'mihai.avram@gmail.com'),
(6, 'Stoica', 'Ana', '0727123456', 'ana.stoica@gmail.com'),
(7, 'Radu', 'Cristian', '0728123456', 'cristian.radu@gmail.com'),
(8, 'Constantin', 'Laura', '0729123456', 'laura.constantin@gmail.com'),
(9, 'Gheorghe', 'Daniel', '0730123456', 'daniel.gheorghe@gmail.com'),
(10, 'Marin', 'Ioana', '0731123456', 'ioana.marin@gmail.com'),
(11, 'Dinu', 'Alexandru', '0732123456', 'alexandru.dinu@gmail.com'),
(12, 'Stan', 'Gabriela', '0733123456', 'gabriela.stan@gmail.com'),
(13, 'Vlad', 'Bogdan', '0734123456', 'bogdan.vlad@gmail.com'),
(14, 'Tudor', 'Simona', '0735123456', 'simona.tudor@gmail.com'),
(15, 'Petre', 'Razvan', '0736123456', 'razvan.petre@gmail.com'),
(16, 'Diaconu', 'Alina', '0737123456', 'alina.diaconu@gmail.com'),
(17, 'Popa', 'Sorin', '0739123456', 'sorin.popa@gmail.com'),
(18, 'Luca', 'Mihaela', '0740123456', 'mihaela.luca@gmail.com'),
(19, 'Nistor', 'Adrian', '0741123456', 'adrian.nistor@gmail.com'),
(20, 'Dumitru', 'Carmen', '0742123456', 'carmen.dumitru@gmail.com');

-- Populare tabel mese
INSERT INTO mese (id_masa, id_restaurant, masa_nr, nr_locuri_masa, observatii) VALUES
(1, 20, 1, 4, 'Masa langa fereastra'),
(2, 21, 2, 2, 'Masa pentru cupluri'),
(3, 22, 3, 6, 'Masa pentru grupuri'),
(4, 23, 1, 4, 'Masa in aer liber'),
(5, 24, 2, 2, 'Masa cu umbrela'),
(6, 25, 1, 4, 'Masa cu vedere spre bucatarie'),
(7, 26, 2, 2, 'Masa langa bar'),
(8, 27, 1, 4, 'Masa cu decor specific chinezesc'),
(9, 28, 2, 2, 'Masa cu lampa rosie'),
(10, 29, 1, 4, 'Masa cu vedere spre mare'),
(11, 30, 2, 2, 'Masa cu scoici si stele de mare'),
(12, 31, 1, 4, 'Masa cu decor specific mexican'),
(13, 32, 2, 2, 'Masa cu sombrero si maracas'),
(14, 33, 1, 4, 'Masa cu decor specific francez'),
(15, 34, 2, 2, 'Masa cu lumanari si flori'),
(16, 35, 1, 4, 'Masa cu decor specific spaniol'),
(17, 36, 2, 2, 'Masa cu evantai si castaniete'),
(18, 37, 1, 4, 'Masa cu decor specific japonez'),
(19, 38, 2, 2, 'Masa cu bonsai si origami'),
(20, 39, 1, 4, 'Masa cu decor specific indian');

INSERT INTO rezervari (id_rezervare, data_ore_rezervare, id_client, data_ora_sosire, data_ora_plecare) VALUES
(1, '2023-10-27 18:00:00', 1, '2023-10-27 18:30:00', '2023-10-27 20:30:00'),
(2, '2023-10-27 19:00:00', 2, '2023-10-27 19:30:00', '2023-10-27 21:30:00'),
(3, '2023-10-27 20:00:00', 3, '2023-10-27 20:30:00', '2023-10-27 22:30:00'),
(4, '2023-10-27 21:00:00', 4, '2023-10-27 21:30:00', '2023-10-27 23:30:00'),
(5, '2023-10-27 22:00:00', 5, '2023-10-27 22:30:00', '2023-10-28 00:30:00'),
(6, '2023-10-28 12:00:00', 6, '2023-10-28 12:30:00', '2023-10-28 14:30:00'),
(7, '2023-10-28 13:00:00', 7, '2023-10-28 13:30:00', '2023-10-28 15:30:00'),
(8, '2023-10-28 14:00:00', 8, '2023-10-28 14:30:00', '2023-10-28 16:30:00'),
(9, '2023-10-28 15:00:00', 9, '2023-10-28 15:30:00', '2023-10-28 17:30:00'),
(10, '2023-10-28 16:00:00', 10, '2023-10-28 16:30:00', '2023-10-28 18:30:00'),
(11, '2023-10-28 17:00:00', 11, '2023-10-28 17:30:00', '2023-10-28 19:30:00'),
(12, '2023-10-28 18:00:00', 12, '2023-10-28 18:30:00', '2023-10-28 20:30:00'),
(13, '2023-10-28 19:00:00', 13, '2023-10-28 19:30:00', '2023-10-28 21:30:00'),
(14, '2023-10-28 20:00:00', 14, '2023-10-28 20:30:00', '2023-10-28 22:30:00'),
(15, '2023-10-28 21:00:00', 15, '2023-10-28 21:30:00', '2023-10-28 23:30:00'),
(16, '2023-10-28 22:00:00', 16, '2023-10-28 22:30:00', '2023-10-29 00:30:00'),
(17, '2023-10-29 12:00:00', 17, '2023-10-29 12:30:00', '2023-10-29 14:30:00'),
(18, '2023-10-29 13:00:00', 18, '2023-10-29 13:30:00', '2023-10-29 15:30:00'),
(19, '2023-10-29 14:00:00', 19, '2023-10-29 14:30:00', '2023-10-29 16:30:00'),
(20, '2023-10-29 15:00:00', 20, '2023-10-29 15:30:00', '2023-10-29 17:30:00');

INSERT INTO angajati (id_angajat, nume_angajat, prenume_angajat, cnp_angajat, data_nasterii, data_angajarii, id_restaurant, telefon) VALUES
(1, 'Popescu', 'Ion', '1900101000001', '1990-01-01', '2020-01-01', 20, '0721000001'),
(2, 'Ionescu', 'Maria', '2920202000002', '1992-02-02', '2020-02-02', 21, '0722000002'),
(3, 'Georgescu', 'Andrei', '1950303000003', '1995-03-03', '2020-03-03', 22, '0723000003'),
(4, 'Dumitrescu', 'Elena', '2980404000004', '1998-04-04', '2020-04-04', 23, '0724000004'),
(5, 'Avram', 'Mihai', '1850505000005', '1985-05-05', '2020-05-05', 24, '0725000005'),
(6, 'Stoica', 'Ana', '2880606000006', '1988-06-06', '2020-06-06', 25, '0726000006'),
(7, 'Radu', 'Cristian', '1910707000007', '1991-07-07', '2020-07-07', 26, '0727000007'),
(8, 'Constantin', 'Laura', '2940808000008', '1994-08-08', '2020-08-08', 27, '0728000008'),
(9, 'Gheorghe', 'Daniel', '1870909000009', '1987-09-09', '2020-09-09', 28, '0729000009'),
(10, 'Marin', 'Ioana', '2901010000010', '1990-10-10', '2020-10-10', 29, '0730000010'),
(11, 'Dinu', 'Alexandru', '1931111000011', '1993-11-11', '2020-11-11', 30, '0731000011'),
(12, 'Stan', 'Gabriela', '2961212000012', '1996-12-12', '2020-12-12', 31, '0732000012'),
(13, 'Vlad', 'Bogdan', '1890101000013', '1989-01-01', '2021-01-01', 32, '0733000013'),
(14, 'Tudor', 'Simona', '2920202000014', '1992-02-02', '2021-02-02', 33, '0734000014'),
(15, 'Petre', 'Razvan', '1950303000015', '1995-03-03', '2021-03-03', 34, '0735000015'),
(16, 'Diaconu', 'Alina', '2980404000016', '1998-04-04', '2021-04-04', 35, '0736000016'),
(17, 'Iordache', 'Sergiu', '1850505000017', '1985-05-05', '2021-05-05', 36, '0737000017'),
(18, 'Enache', 'Camelia', '2880606000018', '1988-06-06', '2021-06-06', 37, '0738000018'),
(19, 'Balan', 'Constantin', '1910707000019', '1991-07-07', '2021-07-07', 38, '0739000019'),
(20, 'Gavrila', 'Oana', '2940808000020', '1994-08-08', '2021-08-08', 39, '0740000020');
INSERT INTO angajati (id_angajat, nume_angajat, prenume_angajat, cnp_angajat, data_nasterii, data_angajarii, id_restaurant, telefon) VALUES
(21, 'Grigole', 'Moisil', '12962489239', '2006-08-01', '2024-08-09', 20, '0742919299');

INSERT INTO chelneri (id_chelner, punctaj_ultima_evaluare, data_ultimei_evaluari) VALUES
(1, 4.5, '2023-10-20'),
(2, 4.8, '2023-10-21'),
(3, 4.2, '2023-10-22'),
(4, 4.9, '2023-10-23'),
(5, 4.6, '2023-10-24'),
(6, 4.3, '2023-10-25'),
(7, 4.7, '2023-10-26'),
(8, 4.4, '2023-10-27'),
(9, 4.1, '2023-10-28'),
(10, 5.0, '2023-10-29'),
(11, 4.8, '2023-10-20'),
(12, 4.5, '2023-10-21'),
(13, 4.2, '2023-10-22'),
(14, 4.9, '2023-10-23'),
(15, 4.6, '2023-10-24'),
(16, 4.3, '2023-10-25'),
(17, 4.7, '2023-10-26'),
(18, 4.4, '2023-10-27'),
(19, 4.1, '2023-10-28'),
(20, 5.0, '2023-10-29');

INSERT INTO bucatari (id_bucatar, specializari, data_ultimei_specializari) VALUES
(1, 'Bucatarie franceza', '2023-10-20'),
(2, 'Bucatarie italiana', '2023-10-21'),
(3, 'Bucatarie asiatica', '2023-10-22'),
(4, 'Bucatarie mexicana', '2023-10-23'),
(5, 'Bucatarie greceasca', '2023-10-24'),
(6, 'Bucatarie spaniola', '2023-10-25'),
(7, 'Bucatarie indiana', '2023-10-26'),
(8, 'Bucatarie romaneasca', '2023-10-27'),
(9, 'Bucatarie americana', '2023-10-28'),
(10, 'Bucatarie turceasca', '2023-10-29'),
(11, 'Patiserie', '2023-10-20'),
(12, 'Bucatarie vegana', '2023-10-21'),
(13, 'Bucatarie fructe de mare', '2023-10-22'),
(14, 'Bucatarie moleculara', '2023-10-23'),
(15, 'Bucatarie de lux', '2023-10-24'),
(16, 'Bucatarie traditionala', '2023-10-25'),
(17, 'Bucatarie fusion', '2023-10-26'),
(18, 'Bucatarie raw-vegana', '2023-10-27'),
(19, 'Bucatarie cu specific bio', '2023-10-28'),
(20, 'Bucatarie cu specific vanatoresc', '2023-10-29');

INSERT INTO manageri (id_manager, id_restaurant, data_numirii) VALUES
(1, 20, '2020-01-01'),
(2, 21, '2021-03-15'),
(3, 22, '2022-05-20'),
(4, 23, '2020-02-10'),
(5, 24, '2021-04-25'),
(6, 25, '2022-06-30'),
(7, 26, '2020-03-05'),
(8, 27, '2021-05-10'),
(9, 28, '2022-07-15'),
(10, 29, '2020-04-20'),
(11, 30, '2021-06-25'),
(12, 31, '2022-08-30'),
(13, 32, '2020-05-01'),
(14, 33, '2021-07-15'),
(15, 34, '2022-09-20'),
(16, 35, '2020-06-10'),
(17, 36, '2021-08-25'),
(18, 37, '2022-10-30'),
(19, 38, '2020-07-05'),
(20, 39, '2021-09-10');

INSERT INTO ture (id_angajat, data_ora_inceput_tura, data_ora_sfarsit_tura, observatii) VALUES
(1, '2023-10-27 10:00:00', '2023-10-27 18:00:00', 'Tura de dimineata'),
(2, '2023-10-27 12:00:00', '2023-10-27 20:00:00', 'Tura de pranz'),
(3, '2023-10-27 14:00:00', '2023-10-27 22:00:00', 'Tura de dupa-amiaza'),
(4, '2023-10-27 16:00:00', '2023-10-28 00:00:00', 'Tura de seara'),
(5, '2023-10-28 10:00:00', '2023-10-28 18:00:00', 'Tura de dimineata'),
(6, '2023-10-28 12:00:00', '2023-10-28 20:00:00', 'Tura de pranz'),
(7, '2023-10-28 14:00:00', '2023-10-28 22:00:00', 'Tura de dupa-amiaza'),
(8, '2023-10-28 16:00:00', '2023-10-29 00:00:00', 'Tura de seara'),
(9, '2023-10-29 10:00:00', '2023-10-29 18:00:00', 'Tura de dimineata'),
(10, '2023-10-29 12:00:00', '2023-10-29 20:00:00', 'Tura de pranz'),
(11, '2023-10-29 14:00:00', '2023-10-29 22:00:00', 'Tura de dupa-amiaza'),
(12, '2023-10-29 16:00:00', '2023-10-30 00:00:00', 'Tura de seara'),
(13, '2023-10-30 10:00:00', '2023-10-30 18:00:00', 'Tura de dimineata'),
(14, '2023-10-30 12:00:00', '2023-10-30 20:00:00', 'Tura de pranz'),
(15, '2023-10-30 14:00:00', '2023-10-30 22:00:00', 'Tura de dupa-amiaza'),
(16, '2023-10-30 16:00:00', '2023-10-31 00:00:00', 'Tura de seara'),
(17, '2023-10-31 10:00:00', '2023-10-31 18:00:00', 'Tura de dimineata'),
(18, '2023-10-31 12:00:00', '2023-10-31 20:00:00', 'Tura de pranz'),
(19, '2023-10-31 14:00:00', '2023-10-31 22:00:00', 'Tura de dupa-amiaza'),
(20, '2023-10-31 16:00:00', '2023-11-01 00:00:00', 'Tura de seara');

INSERT INTO rezervari_restaurante (id_rezervare, id_restaurant, observatii) VALUES
(1, 20, 'Rezervare pentru restaurantul central'),
(2, 21, 'Rezervare pentru terasa cu flori'),
(3, 22, 'Rezervare pentru restaurantul italian'),
(4, 23, 'Rezervare pentru restaurantul chinezesc'),
(5, 24, 'Rezervare pentru restaurantul grecesc'),
(6, 25, 'Rezervare pentru restaurantul mexican'),
(7, 26, 'Rezervare pentru restaurantul francez'),
(8, 27, 'Rezervare pentru restaurantul spaniol'),
(9, 28, 'Rezervare pentru restaurantul japonez'),
(10, 29, 'Rezervare pentru restaurantul indian'),
(11, 30, 'Rezervare pentru restaurantul românesc'),
(12, 31, 'Rezervare pentru restaurantul american'),
(13, 32, 'Rezervare pentru restaurantul turcesc'),
(14, 33, 'Rezervare pentru restaurantul libanez'),
(15, 34, 'Rezervare pentru restaurantul coreean'),
(16, 35, 'Rezervare pentru restaurantul thai'),
(17, 36, 'Rezervare pentru restaurantul vietnamez'),
(18, 37, 'Rezervare pentru restaurantul argentinian'),
(19, 38, 'Rezervare pentru restaurantul brazilian'),
(20, 39, 'Rezervare pentru restaurantul peruan');

INSERT INTO furnizori (id_furnizor, den_furn, tip_furn, adresa_furn, id_localitate_furnizor) VALUES
(1, 'Furnizor Alimente SRL', 'Alimente', 'Strada Depozitului 10', 1),
(2, 'Furnizor Bauturi SA', 'Bauturi', 'Bulevardul Industrial 5', 2),
(3, 'Furnizor Carne Premium', 'Carne', 'Strada Abatorului 2', 3),
(4, 'Furnizor Peste Proaspat', 'Peste', 'Strada Portului 15', 5),
(5, 'Furnizor Legume Bio', 'Legume', 'Strada Ferma 20', 10),
(6, 'Furnizor Lactate Delicioase', 'Lactate', 'Strada Laptelui 8', 11),
(7, 'Furnizor Fructe Exotice', 'Fructe', 'Strada Plantatiei 3', 15),
(8, 'Furnizor Condimente Speciale', 'Condimente', 'Strada Mirodeniilor 12', 17),
(9, 'Furnizor Paine Artizanala', 'Paine', 'Strada Brutariilor 7', 19),
(10, 'Furnizor Vinuri de Colectie', 'Vinuri', 'Strada Podgoriilor 9', 20),
(11, 'Furnizor Cafea Boabe', 'Cafea', 'Strada Cafenelelor 1', 1),
(12, 'Furnizor Ceaiuri Aromate', 'Ceaiuri', 'Strada Ceainariilor 6', 2),
(13, 'Furnizor Uleiuri Esentiale', 'Uleiuri', 'Strada Esentelor 11', 3),
(14, 'Furnizor Nuci si Seminte', 'Nuci', 'Strada Nucilor 14', 5),
(15, 'Furnizor Miere Naturala', 'Miere', 'Strada Apicultorilor 18', 10),
(16, 'Furnizor Dulciuri Artizanale', 'Dulciuri', 'Strada Cofetariilor 4', 11),
(17, 'Furnizor Conserve Fructe', 'Conserve', 'Strada Borcanelor 13', 15),
(18, 'Furnizor Oteturi Fine', 'Oteturi', 'Strada Acriturilor 16', 17),
(19, 'Furnizor Paste Proaspete', 'Paste', 'Strada Macaroanelor 21', 19),
(20, 'Furnizor Inghetata Artizanala', 'Inghetata', 'Strada Frigiderelor 22', 20);

INSERT INTO produse (id_produs, den_produs, categorie_produs) VALUES
(1, 'Rosii', 'Legume'),
(2, 'Bere', 'Bauturi'),
(3, 'Cotlet de porc', 'Carne'),
(4, 'Somon', 'Peste'),
(5, 'Cartofi', 'Legume'),
(6, 'Branza', 'Lactate'),
(7, 'Mango', 'Fructe'),
(8, 'Piper negru', 'Condimente'),
(9, 'Paine integrala', 'Paine'),
(10, 'Vin rosu', 'Bauturi'),
(11, 'Cafea Arabica', 'Bauturi'),
(12, 'Ceai verde', 'Bauturi'),
(13, 'Ulei de masline', 'Uleiuri'),
(14, 'Migdale', 'Nuci'),
(15, 'Miere de salcam', 'Miere'),
(16, 'Ciocolata artizanala', 'Dulciuri'),
(17, 'Otet balsamic', 'Oteturi'),
(18, 'Tagliatelle', 'Paste'),
(19, 'Inghetata de vanilie', 'Inghetata'),
(20, 'Prajitura cu ciocolata', 'Desert');

INSERT INTO comenzi (id_comanda, data_ora_comanda, id_chelner, id_masa, observatii) VALUES
(1, '2023-10-27 18:00:00', 1, 1, 'Comanda pentru masa 1'),
(2, '2023-10-27 19:00:00', 2, 2, 'Comanda pentru masa 2'),
(3, '2023-10-27 20:00:00', 3, 3, 'Comanda pentru masa 3'),
(4, '2023-10-27 21:00:00', 4, 4, 'Comanda pentru masa 4'),
(5, '2023-10-27 22:00:00', 5, 5, 'Comanda pentru masa 5'),
(6, '2023-10-28 12:00:00', 6, 6, 'Comanda pentru masa 6'),
(7, '2023-10-28 13:00:00', 7, 7, 'Comanda pentru masa 7'),
(8, '2023-10-28 14:00:00', 8, 8, 'Comanda pentru masa 8'),
(9, '2023-10-28 15:00:00', 9, 9, 'Comanda pentru masa 9'),
(10, '2023-10-28 16:00:00', 10, 10, 'Comanda pentru masa 10'),
(11, '2023-10-28 17:00:00', 11, 11, 'Comanda pentru masa 11'),
(12, '2023-10-28 18:00:00', 12, 12, 'Comanda pentru masa 12'),
(13, '2023-10-28 19:00:00', 13, 13, 'Comanda pentru masa 13'),
(14, '2023-10-28 20:00:00', 14, 14, 'Comanda pentru masa 14'),
(15, '2023-10-28 21:00:00', 15, 15, 'Comanda pentru masa 15'),
(16, '2023-10-28 22:00:00', 16, 16, 'Comanda pentru masa 16'),
(17, '2023-10-29 12:00:00', 17, 17, 'Comanda pentru masa 17'),
(18, '2023-10-29 13:00:00', 18, 18, 'Comanda pentru masa 18'),
(19, '2023-10-29 14:00:00', 19, 19, 'Comanda pentru masa 19'),
(20, '2023-10-29 15:00:00', 20, 20, 'Comanda pentru masa 20'),
(21, '2023-10-29 15:00:00', 20, 20, 'Comanda pentru masa 21'),
(22, '2023-10-29 15:00:00', 20, 20, 'Comanda pentru masa 21');

INSERT INTO bauturi (id_bautura, denumire_in_meniu, data_adaugarii_in_meniu, tip_bautura, alcoolemie, id_produs, cantitate_portie, pret_unitar) VALUES
(1, 'Bere Ursus', '2023-10-26', 'Bere', 5.0, 1, 500, 7.50),
(2, 'Vin Alb Recas', '2023-10-26', 'Vin', 12.5, 2, 150, 15.00),
(3, 'Cafea Espresso', '2023-10-26', 'Cafea', 0.0, 3, 30, 5.00),
(4, 'Ceai Verde', '2023-10-26', 'Ceai', 0.0, 4, 250, 6.00),
(5, 'Apa Plata', '2023-10-26', 'Apa', 0.0, 5, 500, 3.50),
(6, 'Coca-Cola', '2023-10-26', 'Suc', 0.0, 6, 330, 4.00),
(7, 'Limonada', '2023-10-26', 'Suc', 0.0, 7, 400, 8.00),
(8, 'Cocktail Mojito', '2023-10-26', 'Cocktail', 10.0, 8, 200, 12.00),
(9, 'Whisky Jack Daniels', '2023-10-26', 'Whisky', 40.0, 9, 50, 25.00),
(10, 'Vodka Absolut', '2023-10-26', 'Vodka', 40.0, 10, 50, 20.00),
(11, 'Gin Tonic', '2023-10-26', 'Gin', 37.5, 11, 200, 18.00),
(12, 'Rom Havana Club', '2023-10-26', 'Rom', 40.0, 12, 50, 22.00),
(13, 'Tequila Jose Cuervo', '2023-10-26', 'Tequila', 38.0, 13, 50, 23.00),
(14, 'Sambuca', '2023-10-26', 'Lichior', 38.0, 14, 30, 16.00),
(15, 'Martini Bianco', '2023-10-26', 'Vermut', 15.0, 15, 100, 14.00),
(16, 'Campari Orange', '2023-10-26', 'Cocktail', 8.0, 16, 150, 17.00),
(17, 'Aperol Spritz', '2023-10-26', 'Cocktail', 11.0, 17, 200, 19.00),
(18, 'Vin Spumant Prosecco', '2023-10-26', 'Vin', 11.0, 18, 120, 21.00),
(19, 'Bere Artizanala IPA', '2023-10-26', 'Bere', 6.5, 19, 400, 9.00),
(20, 'Suc Natural de Portocale', '2023-10-26', 'Suc', 0.0, 20, 300, 7.00);

INSERT INTO com_bauturi (id_comanda, id_bautura, cantitate_comandata, pret_unitar) VALUES
(1, 1, 2, 7.50),
(2, 2, 1, 5.00),
(3, 3, 1, 15.00),
(4, 4, 2, 6.00),
(5, 5, 3, 3.50),
(6, 6, 1, 4.00),
(7, 7, 2, 8.00),
(8, 8, 1, 12.00),
(9, 9, 1, 25.00),
(10, 10, 2, 20.00),
(11, 11, 1, 18.00),
(12, 12, 1, 22.00),
(13, 13, 2, 23.00),
(14, 14, 1, 16.00),
(15, 15, 2, 14.00),
(16, 16, 1, 17.00),
(17, 17, 2, 19.00),
(18, 18, 1, 21.00),
(19, 19, 2, 9.00),
(20, 20, 1, 7.00),
(21, 20, 1,8.00);

INSERT INTO mancaruri (id_sortiment_mancare, denumire_in_meniu, data_adaugarii_in_meniu, tip_mancare, id_produs, gramaj_portie, pret_unitar) VALUES
(1, 'Ciorba de burta', '2023-10-26', 'Ciorba', 1, 400, 18.00),
(2, 'Sarmale cu mamaliguta', '2023-10-26', 'Fel principal', 2, 500, 22.00),
(3, 'Mici cu cartofi prajiti', '2023-10-26', 'Fel principal', 3, 350, 20.00),
(4, 'Snitel de pui cu piure', '2023-10-26', 'Fel principal', 4, 400, 25.00),
(5, 'Paste carbonara', '2023-10-26', 'Paste', 5, 450, 28.00),
(6, 'Pizza Margherita', '2023-10-26', 'Pizza', 6, 500, 26.00),
(7, 'Salata Caesar', '2023-10-26', 'Salata', 7, 300, 19.00),
(8, 'Somon la gratar cu legume', '2023-10-26', 'Peste', 8, 350, 35.00),
(9, 'Cotlet de porc cu sos de piper', '2023-10-26', 'Carne', 9, 400, 30.00),
(10, 'Musaca de legume', '2023-10-26', 'Vegetarian', 10, 450, 24.00),
(11, 'Supă crema de ciuperci', '2023-10-26', 'Ciorba', 11, 300, 16.00),
(12, 'Papanasi cu dulceata si smantana', '2023-10-26', 'Desert', 12, 250, 15.00),
(13, 'Clatite cu ciocolata si banane', '2023-10-26', 'Desert', 13, 300, 17.00),
(14, 'Tiramisu', '2023-10-26', 'Desert', 14, 280, 20.00),
(15, 'Ciorba de fasole cu afumatura', '2023-10-26', 'Ciorba', 15, 380, 19.00),
(16, 'Tochitura cu mamaliguta si ou', '2023-10-26', 'Fel principal', 16, 480, 23.00),
(17, 'Frigarui de pui cu legume', '2023-10-26', 'Fel principal', 17, 380, 26.00),
(18, 'Spaghete cu fructe de mare', '2023-10-26', 'Paste', 18, 430, 32.00),
(19, 'Pizza Quattro Formaggi', '2023-10-26', 'Pizza', 19, 480, 29.00),
(20, 'Salata Greceasca', '2023-10-26', 'Salata', 20, 330, 21.00),
(21, 'Salata Italiana', '2023-10-26', 'Salata', 20, 330, 21.00);

INSERT INTO com_mancare (id_comanda, id_sortiment_mancare, nr_portii_comandate, pret_unitar) VALUES
(1, 1, 1, 18.00),
(2, 2, 2, 20.00),
(3, 3, 1, 22.00),
(4, 4, 1, 25.00),
(5, 5, 2, 28.00),
(6, 6, 1, 26.00),
(7, 7, 1, 19.00),
(8, 8, 1, 35.00),
(9, 9, 2, 30.00),
(10, 10, 1, 24.00),
(11, 11, 1, 16.00),
(12, 12, 1, 15.00),
(13, 13, 2, 17.00),
(14, 14, 1, 20.00),
(15, 15, 1, 19.00),
(16, 16, 2, 23.00),
(17, 17, 1, 26.00),
(18, 18, 1, 32.00),
(19, 19, 2, 29.00),
(20, 20, 1, 21.00),
(21, 21, 1, 21.00),
(22,21,1,12.00);

INSERT INTO rezervari_mese (id_rezervare, id_masa, observatii) VALUES
(1, 1, 'Masa langa fereastra'),
(2, 2, 'Masa pentru cupluri'),
(3, 3, 'Masa pentru grupuri'),
(4, 4, 'Masa in aer liber'),
(5, 5, 'Masa cu umbrela'),
(6, 6, 'Masa cu vedere spre bucatarie'),
(7, 7, 'Masa langa bar'),
(8, 8, 'Masa cu decor specific chinezesc'),
(9, 9, 'Masa cu lampa rosie'),
(10, 10, 'Masa cu vedere spre mare'),
(11, 11, 'Masa cu scoici si stele de mare'),
(12, 12, 'Masa cu decor specific mexican'),
(13, 13, 'Masa cu sombrero si maracas'),
(14, 14, 'Masa cu decor specific francez'),
(15, 15, 'Masa cu lumanari si flori'),
(16, 16, 'Masa cu decor specific spaniol'),
(17, 17, 'Masa cu evantai si castaniete'),
(18, 18, 'Masa cu decor specific japonez'),
(19, 19, 'Masa cu bonsai si origami'),
(20, 20, 'Masa cu decor specific indian');

INSERT INTO bonuri_fiscale (id_bon_f, nr_bon_f, data_ora_bon_f, id_comanda, suma_bon_f, mod_incasare, id_client) VALUES
(1, 'BF01', '2023-10-26 10:00:00', 1, 150.00, 'Card', 1),
(2, 'BF02', '2023-10-26 11:30:00', 2, 80.00, 'Cash', 2),
(3, 'BF03', '2023-10-26 12:45:00', 3, 120.00, 'Card', 3),
(4, 'BF04', '2023-10-26 14:00:00', 4, 100.00, 'Cash', 4),
(5, 'BF05', '2023-10-26 15:30:00', 5, 90.00, 'Card', 5),
(6, 'BF06', '2023-10-26 16:45:00', 6, 110.00, 'Cash', 6),
(7, 'BF07', '2023-10-26 18:00:00', 7, 130.00, 'Card', 7),
(8, 'BF08', '2023-10-26 19:30:00', 8, 140.00, 'Cash', 8),
(9, 'BF09', '2023-10-26 21:00:00', 9, 160.00, 'Card', 9),
(10, 'BF10', '2023-10-26 22:30:00', 10, 170.00, 'Cash', 10),
(11, 'BF11', '2023-10-27 10:00:00', 11, 180.00, 'Card', 11),
(12, 'BF12', '2023-10-27 11:30:00', 12, 190.00, 'Cash', 12),
(13, 'BF13', '2023-10-27 12:45:00', 13, 200.00, 'Card', 13),
(14, 'BF14', '2023-10-27 14:00:00', 14, 210.00, 'Cash', 14),
(15, 'BF15', '2023-10-27 15:30:00', 15, 220.00, 'Card', 15),
(16, 'BF16', '2023-10-27 16:45:00', 16, 230.00, 'Cash', 16),
(17, 'BF17', '2023-10-27 18:00:00', 17, 240.00, 'Card', 17),
(18, 'BF18', '2023-10-27 19:30:00', 18, 250.00, 'Cash', 18),
(19, 'BF19', '2023-10-27 21:00:00', 19, 260.00, 'Card', 19),
(20, 'BF20', '2023-10-27 22:30:00', 20, 270.00, 'Cash', 20);

INSERT INTO comenzi_produse_furnizori (id_comanda_furnizor, data_ora_comanda, id_restaurant, id_furnizor, id_produs, cantitate, pret_total) VALUES
(1, '2023-10-26 10:00:00', 20, 1, 1, 100, 500.00),
(2, '2023-10-26 11:30:00', 21, 2, 2, 50, 250.00),
(3, '2023-10-26 12:45:00', 22, 3, 3, 20, 300.00),
(4, '2023-10-26 14:00:00', 23, 4, 4, 30, 450.00),
(5, '2023-10-26 15:30:00', 24, 5, 5, 40, 600.00),
(6, '2023-10-26 16:45:00', 25, 6, 6, 60, 900.00),
(7, '2023-10-26 18:00:00', 26, 7, 7, 25, 375.00),
(8, '2023-10-26 19:30:00', 27, 8, 8, 35, 525.00),
(9, '2023-10-26 21:00:00', 28, 9, 9, 15, 225.00),
(10, '2023-10-26 22:30:00', 29, 10, 10, 5, 100.00),
(11, '2023-10-27 10:00:00', 30, 11, 11, 75, 375.00),
(12, '2023-10-27 11:30:00', 31, 12, 12, 45, 225.00),
(13, '2023-10-27 12:45:00', 32, 13, 13, 18, 270.00),
(14, '2023-10-27 14:00:00', 33, 14, 14, 28, 420.00),
(15, '2023-10-27 15:30:00', 34, 15, 15, 38, 570.00),
(16, '2023-10-27 16:45:00', 35, 16, 16, 58, 870.00),
(17, '2023-10-27 18:00:00', 36, 17, 17, 23, 345.00),
(18, '2023-10-27 19:30:00', 37, 18, 18, 33, 495.00),
(19, '2023-10-27 21:00:00', 38, 19, 19, 13, 195.00),
(20, '2023-10-27 22:30:00', 39, 20, 20, 3, 60.00);

---RESTAURANTE4

---Restaurante4 – tema 1
---Restaurante4.1 Afișați persoanele care s-au angajat la 18 ani.
SELECT an.id_angajat
FROM angajati an
WHERE EXTRACT(YEAR FROM AGE(data_angajarii, data_nasterii)) = 18
ORDER BY an.id_angajat;
---Restaurante4.2 Care sunt furnizorii de băuturi?
SELECT b.id_bautura, f.den_furn
FROM bauturi b
INNER JOIN produse p  ON b.id_produs=p.id_produs
INNER JOIN comenzi_produse_furnizori cpf ON cpf.id_produs=p.id_produs
INNER JOIN furnizori f ON cpf.id_furnizor = f.id_furnizor
WHERE p.categorie_produs='Bauturi'
GROUP BY b.id_bautura,f.den_furn;
---Restaurante4.3 Care sunt comenzile pentru care nu există (încă) bon fiscal?
SELECT c.id_comanda
FROM comenzi c
LEFT JOIN bonuri_fiscale bf ON bf.id_comanda = c.id_comanda
WHERE bf.id_bon_f IS NULL;

---Restaurante4.4 Care sunt comenzile care conțin mâncare, dar nu și băutură
SELECT c.id_comanda
FROM comenzi c
LEFT JOIN com_mancare com ON c.id_comanda=com.id_comanda
LEFT JOIN com_bauturi cob ON c.id_comanda=cob.id_comanda
WHERE com.id_comanda >0 AND cob.id_comanda IS NULL
GROUP BY c.id_comanda;



