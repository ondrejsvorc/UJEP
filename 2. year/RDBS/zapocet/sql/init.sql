-- CREATE DATABASE Restaurace;
CREATE SCHEMA Pivonka;

CREATE TABLE Pivonka.Pozice (
  Id_Pozice SERIAL PRIMARY KEY,
  Id_PoziceNadrizeny int,
  Nazev VARCHAR(40) NOT NULL,
  Plat INT NOT NULL
);

CREATE TABLE Pivonka.Predcisli (
  Id_Predcisli SERIAL PRIMARY KEY,
  Predcisli VARCHAR(4) NOT NULL,
  Poradi INT NOT NULL
);

CREATE TABLE Pivonka.Zamestnanci (
  Id_Zamestnanec SERIAL PRIMARY KEY,
  Id_Pozice INT NULL,
  Jmeno VARCHAR(25) NOT NULL,
  Prijmeni VARCHAR(25) NOT NULL,
  Email VARCHAR(40) NOT NULL,
  Id_Predcisli INT NOT NULL,
  TelefonniCislo INT NOT NULL,
  DatumNastupu DATE NOT NULL
);

CREATE TABLE Pivonka.Zakaznici (
  Id_Zakaznik SERIAL PRIMARY KEY,
  Jmeno VARCHAR(25) NOT NULL,
  Prijmeni VARCHAR(25) NOT NULL,
  Email VARCHAR(40) NOT NULL,
  Id_Predcisli INT NOT NULL,
  TelefonniCislo INT NOT NULL
);

CREATE TABLE Pivonka.Rezervace (
  Id_Rezervace SERIAL PRIMARY KEY,
  Id_Zakaznik INT NOT NULL,
  Id_Stul INT NOT NULL,
  Datum DATE NOT NULL,
  CasOd TIME NOT NULL,
  CasDo TIME NOT NULL
);

CREATE TABLE Pivonka.Stoly (
  Id_Stul SERIAL PRIMARY KEY,
  PocetMist SMALLINT NOT NULL
);

CREATE TABLE Pivonka.Menu (
  Id_Menu SERIAL PRIMARY KEY,
  DatumPlatnosti DATE NOT NULL
);

CREATE TABLE Pivonka.MenuPolozkyMenu (
  Id_Menu INT NOT NULL,
  Id_PolozkaMenu INT NOT NULL,
  PRIMARY KEY (Id_Menu, Id_PolozkaMenu)
);

CREATE TABLE Pivonka.PolozkyMenu (
  Id_PolozkaMenu SERIAL PRIMARY KEY,
  Nazev VARCHAR(40) NOT NULL,
  Cena DECIMAL(7, 2) NOT NULL
);

CREATE TABLE Pivonka.Objednavky (
  Id_Objednavka SERIAL PRIMARY KEY,
  Id_Rezervace INT NOT NULL,
  Id_ZamestnanecCisnik INT NOT NULL,
  Id_ZamestnanecKuchar INT NOT NULL,
  Datum DATE NOT NULL,
  CasPrijeti TIME NOT NULL,
  CasVyrizeni TIME NOT NULL
);

CREATE TABLE Pivonka.PolozkyObjednavek (
  Id_Objednavka INT NOT NULL,
  Id_PolozkaMenu INT NOT NULL,
  Mnozstvi SMALLINT NOT NULL,
  PRIMARY KEY (Id_Objednavka, Id_PolozkaMenu)
);

-- Funkce, která určí, zda je zaměstnanec s daným ID kuchař nebo šéfkuchař.
CREATE OR REPLACE FUNCTION public.JeKucharNeboSefkuchar (Id_Zamestnanecc INT)
RETURNS BOOLEAN
AS $$
DECLARE JeKucharNeboSefkuchar BOOLEAN;
BEGIN
    SELECT CASE
        WHEN EXISTS (
            SELECT 1
            FROM Pivonka.Zamestnanci AS Zamestnanci
            INNER JOIN Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
            WHERE Zamestnanci.Id_Zamestnanec = Id_Zamestnanecc
            AND Pozice.Nazev IN ('Kuchař', 'Šéfkuchař')
        ) THEN TRUE
        ELSE FALSE
    END INTO JeKucharNeboSefkuchar;
    
    RETURN JeKucharNeboSefkuchar;
END;
$$ LANGUAGE plpgsql;

-- Funkce, která určí, zda je zaměstnanec s daným ID číšník nebo vrchní čišník.
CREATE OR REPLACE FUNCTION public.JeCisnikNeboVrchniCisnik (Id_Zamestnaneccc INT)
RETURNS BOOLEAN
AS $$
DECLARE JeCisnikNeboVrchniCisnik BOOLEAN;
BEGIN
    SELECT CASE
        WHEN EXISTS (
            SELECT 1
            FROM Pivonka.Zamestnanci AS Zamestnanci
            INNER JOIN Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
            WHERE Zamestnanci.Id_Zamestnanec = Id_Zamestnaneccc
            AND Pozice.Nazev IN ('Číšník', 'Vrchní číšník')
        ) THEN TRUE
        ELSE FALSE
    END INTO JeCisnikNeboVrchniCisnik;
    
    RETURN JeCisnikNeboVrchniCisnik;
END;
$$ LANGUAGE plpgsql;

-- Každý zaměstnanec má právě jednu pozici.
-- Každou pozici může mít více zaměstnanců.
ALTER TABLE Pivonka.Zamestnanci 
ADD CONSTRAINT FK_Zamestnanci_Pozice 
FOREIGN KEY (Id_Pozice) REFERENCES Pivonka.Pozice (Id_Pozice);

-- Každý zaměstnanec byl měl být unikátní e-mail.
-- (odlišný od e-mailu jiných zaměstnanců).
-- CREATE UNIQUE INDEX idx_zamestnanci_email ON Pivonka.Zamestnanci(Email);
ALTER TABLE Pivonka.Zamestnanci
ADD CONSTRAINT UQ_Zamestnanci_Email 
UNIQUE (Email);

-- Každé předčíslí by mělo být unikátní.
-- (odlišné od jiných předčíslí).
ALTER TABLE Pivonka.Predcisli
ADD CONSTRAINT UQ_Predcisli_Predcisli 
UNIQUE (Predcisli);

-- Každý zaměstnanec má k telefonnímu číslu právě jedno předčíslí.
-- Každé předčíslí může mít k telefonnímu číslu více zaměstanců.
ALTER TABLE Pivonka.Zamestnanci
ADD CONSTRAINT FK_Zamestnanci_Predcisli 
FOREIGN KEY (Id_Predcisli) 
REFERENCES Pivonka.Predcisli (Id_Predcisli);

-- Každý zákazník má k telefonnímu číslu právě jedno předčíslí.
-- Každé předčíslí může mít k telefonnímu číslu více zákazníků.
ALTER TABLE Pivonka.Zakaznici
ADD CONSTRAINT FK_Zakaznici_Predcisli 
FOREIGN KEY (Id_Predcisli) 
REFERENCES Pivonka.Predcisli (Id_Predcisli);

-- Ke každé pozici může existovat právě jedna nadřízená pozice (např. Kuchař, Šéfkuchař).
-- Ke každé nadřízené pozici může existovat více podřízených pozic.
ALTER TABLE Pivonka.Pozice 
ADD CONSTRAINT FK_Pozice_Pozice 
FOREIGN KEY (Id_PoziceNadrizeny) 
REFERENCES Pivonka.Pozice (Id_Pozice);

-- Každá rezervace má právě jeden stůl.
-- Každý stůl může být ve více rezervacích (odlišné časy).
ALTER TABLE Pivonka.Rezervace 
ADD CONSTRAINT FK_Rezervace_Stoly 
FOREIGN KEY (Id_Stul) 
REFERENCES Pivonka.Stoly (Id_Stul);

-- Každý zákazník může mít více rezervací.
-- Každou rezervaci může mít pouze jeden zákazník.
ALTER TABLE Pivonka.Rezervace 
ADD CONSTRAINT FK_Rezervace_Zakaznici 
FOREIGN KEY (Id_Zakaznik) 
REFERENCES Pivonka.Zakaznici (Id_Zakaznik);

-- Každá objednávka se pojí právě k jedné rezervaci.
-- Každá rezervace se může vztahovat k více objednávkám (od stolu si objedná více lidí).
ALTER TABLE Pivonka.Objednavky 
ADD CONSTRAINT FK_Objednavky_Rezervace 
FOREIGN KEY (Id_Rezervace) 
REFERENCES Pivonka.Rezervace (Id_Rezervace);

-- Každá objednávka je obsluhována jedním konkrétním číšníkem.
-- Jeden konkrétní číšník může obsluhovat více objednávek.
ALTER TABLE Pivonka.Objednavky 
ADD CONSTRAINT FK_Objednavky_Zamestnanci_Cisnik 
FOREIGN KEY (Id_ZamestnanecCisnik) 
REFERENCES Pivonka.Zamestnanci (Id_Zamestnanec);

-- Každá objednávka je obsluhována jedním konkrétním kuchařem.
-- Jeden konkrétní kuchař může obsluhovat více objednávek.
ALTER TABLE Pivonka.Objednavky 
ADD CONSTRAINT FK_Objednavky_Zamestnanci_Kuchar 
FOREIGN KEY (Id_ZamestnanecKuchar) 
REFERENCES Pivonka.Zamestnanci (Id_Zamestnanec);

-- Omezení pro Id_ZamestnanecKuchar.
ALTER TABLE Pivonka.Objednavky
ADD CONSTRAINT FK_Objednavky_ZamestnanciKuchar
FOREIGN KEY (Id_ZamestnanecKuchar)
REFERENCES Pivonka.Zamestnanci (Id_Zamestnanec),
ADD CONSTRAINT CHK_KucharPozice
CHECK (JeKucharNeboSefkuchar(Id_ZamestnanecKuchar) = TRUE);

-- Omezení pro Id_ZamestnanecCisnik.
ALTER TABLE Pivonka.Objednavky
ADD CONSTRAINT FK_Objednavky_ZamestnanciCisnik
FOREIGN KEY (Id_ZamestnanecCisnik)
REFERENCES Pivonka.Zamestnanci (Id_Zamestnanec),
ADD CONSTRAINT CHK_CisnikPozice
CHECK (JeCisnikNeboVrchniCisnik(Id_ZamestnanecCisnik) = TRUE);

-- Každá položka objednávky musí být součástí nějaké objednávky.
ALTER TABLE Pivonka.PolozkyObjednavek 
ADD CONSTRAINT FK_PolozkyObjednavek_Objednavky 
FOREIGN KEY (Id_Objednavka) 
REFERENCES Pivonka.Objednavky (Id_Objednavka);

-- Každá položka objednávky musí být součástí nějaké položky menu.
ALTER TABLE Pivonka.PolozkyObjednavek 
ADD CONSTRAINT FK_PolozkyObjednavek_PolozkyMenu 
FOREIGN KEY (Id_PolozkaMenu) 
REFERENCES Pivonka.PolozkyMenu (Id_PolozkaMenu);

-- M:N
-- Každé menu může mít více položek menu.
-- Každá položka menu může být ve více menu.
ALTER TABLE Pivonka.MenuPolozkyMenu 
ADD CONSTRAINT FK_MenuPolozkyMenu_Menu 
FOREIGN KEY (Id_Menu) 
REFERENCES Pivonka.Menu (Id_Menu);
ALTER TABLE Pivonka.MenuPolozkyMenu 
ADD CONSTRAINT FK_MenuPolozkyMenu_PolozkyMenu 
FOREIGN KEY (Id_PolozkaMenu) 
REFERENCES Pivonka.PolozkyMenu (Id_PolozkaMenu);

-- Každý zaměstnanec nemůže mít datum nástupu menší 
-- než je datum založení firmy.
ALTER TABLE Pivonka.Zamestnanci
ADD CONSTRAINT CHK_DatumNastupu
CHECK (DatumNastupu >= '2022-01-01');

-- Pozice (8 záznamů)
INSERT INTO Pivonka.Pozice (Id_Pozice, Id_PoziceNadrizeny, Nazev, Plat)
VALUES
    (1, NULL, 'Majitel', 60000), -- Majitel nemá nadřízeného.
    (2, 1, 'Šéfkuchař', 50000), -- Šéfkuchař má majitele jako nadřízeného.
    (3, 1, 'Vrchní číšník', 45000), -- Vrchní číšník má majitele jako nadřízeného.
    (4, 2, 'Kuchař', 35000), -- Kuchař má šéfkuchaře jako nadřízeného.
    (5, 3, 'Číšník', 22000); -- Číšník má vrchního číšníka jako nadřízeného.

-- Předčíslí (5 záznamů)
INSERT INTO Pivonka.Predcisli (Predcisli, Poradi)
VALUES
    ('+420', 1), -- Česká republika
    ('+421', 2), -- Slovensko
    ('+49', 4),  -- Německo
    ('+48', 3),  -- Polsko
    ('+43', 5);  -- Rakousko

-- Menu (20 záznamů)
INSERT INTO Pivonka.Menu (DatumPlatnosti)
VALUES
    ('2024-05-01'), -- Pondělí
    ('2024-05-02'), -- Úterý
    ('2024-05-03'), -- Středa
    ('2024-05-04'), -- Čtvrtek
    ('2024-05-05'), -- Pátek
    ('2024-05-08'), -- Pondělí
    ('2024-05-09'), -- Úterý
    ('2024-05-10'), -- Středa
    ('2024-05-11'), -- Čtvrtek
    ('2024-05-12'), -- Pátek
    ('2024-05-15'), -- Pondělí
    ('2024-05-16'), -- Úterý
    ('2024-05-17'), -- Středa
    ('2024-05-18'), -- Čtvrtek
    ('2024-05-19'), -- Pátek
    ('2024-05-22'), -- Pondělí
    ('2024-05-23'), -- Úterý
    ('2024-05-24'), -- Středa
    ('2024-05-25'), -- Čtvrtek
    ('2024-05-26'); -- Pátek

-- PolozkyMenu (25 záznamů)
INSERT INTO Pivonka.PolozkyMenu (Nazev, Cena)
VALUES
    ('Smažený sýr', 150.00),
    ('Telecí řízek', 220.00),
    ('Grilované kuřecí prsa', 190.00),
    ('Tatarský biftek', 280.00),
    ('Losos na grilu', 270.00),
    ('Hovězí guláš', 180.00),
    ('Kuřecí polévka s nudlemi', 120.00),
    ('Česneková', 100.00),
    ('Tatarský', 210.00),
    ('Pizza Margherita', 200.00),
    ('Lasagne', 230.00),
    ('Ravioli s ricottou a špenátem', 240.00),
    ('Tiramisu', 160.00),
    ('Cheesecake', 180.00),
    ('Jablečný závin', 130.00),
    ('Těstoviny Carbonara', 190.00),
    ('Paella', 250.00),
    ('Sushi mix', 300.00),
    ('Kuřecí salát', 150.00),
    ('Tzatziki', 100.00),
    ('Sýrová pomazánka', 140.00),
    ('Kořeněná zeleninová polévka', 130.00),
    ('Hovězí steak', 280.00),
    ('Krevety na grilu', 320.00),
    ('Grilovaný halibut', 290.00);

-- MenuPolozkyMenu (130 záznamů)
INSERT INTO Pivonka.MenuPolozkyMenu (Id_Menu, Id_PolozkaMenu)
VALUES 
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (2, 6),
    (2, 7),
    (2, 8),
    (2, 9),
    (2, 10),
    (3, 11),
    (3, 12),
    (3, 13),
    (3, 14),
    (3, 15),
    (4, 16),
    (4, 17),
    (4, 18),
    (4, 19),
    (4, 20),
    (5, 21),
    (5, 22),
    (5, 23),
    (5, 24),
    (5, 25),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 5),
    (7, 6),
    (7, 7),
    (7, 8),
    (7, 9),
    (7, 10),
    (8, 11),
    (8, 12),
    (8, 13),
    (8, 14),
    (8, 15),
    (9, 16),
    (9, 17),
    (9, 18),
    (9, 19),
    (9, 20),
    (10, 21),
    (10, 22),
    (10, 23),
    (10, 24),
    (10, 25),
    (11, 1),
    (11, 2),
    (11, 3),
    (11, 4),
    (11, 5),
    (12, 6),
    (12, 7),
    (12, 8),
    (12, 9),
    (12, 10),
    (13, 11),
    (13, 12),
    (13, 13),
    (13, 14),
    (13, 15),
    (14, 16),
    (14, 17),
    (14, 18),
    (14, 19),
    (14, 20),
    (15, 21),
    (15, 22),
    (15, 23),
    (15, 24),
    (15, 25),
    (16, 1),
    (16, 2),
    (16, 3),
    (16, 4),
    (16, 5),
    (17, 6),
    (17, 7),
    (17, 8),
    (17, 9),
    (17, 10),
    (18, 11),
    (18, 12),
    (18, 13),
    (18, 14),
    (18, 15),
    (19, 16),
    (19, 17),
    (19, 18),
    (19, 19),
    (19, 20),
    (20, 21),
    (20, 22),
    (20, 23),
    (20, 24),
    (20, 25);

-- Stoly (30 záznamů)
INSERT INTO Pivonka.Stoly (PocetMist)
VALUES 
    (4),
    (6),
    (3),
    (8),
    (5),
    (10),
    (7),
    (9),
    (2),
    (6),
    (4),
    (3),
    (7),
    (5),
    (8),
    (6),
    (2),
    (9),
    (10),
    (2),
    (4),
    (4),
    (2),
    (2),
    (4),
    (2),
    (4),
    (2),
    (4),
    (2);

-- Zamestnanci (20 záznamů)
INSERT INTO Pivonka.Zamestnanci (Id_Pozice, Jmeno, Prijmeni, Email, Id_Predcisli, TelefonniCislo, DatumNastupu)
VALUES
    (1, 'Jan', 'Novák', 'jan.novak@seznam.cz', 1, 123456789, CURRENT_DATE - INTERVAL '365 days'),
    (2, 'Pavel', 'Svoboda', 'pavel.svoboda@gmail.com', 1, 987654321, CURRENT_DATE - INTERVAL '300 days'),
    (2, 'Martin', 'Novotný', 'martin.novotny@email.cz', 1, 567891234, CURRENT_DATE - INTERVAL '250 days'),
    (3, 'Michal', 'Dvořák', 'michal.dvorak@centrum.cz', 1, 345678912, CURRENT_DATE - INTERVAL '200 days'),
    (3, 'Tomáš', 'Černý', 'tomas.cerny@seznam.cz', 1, 789123456, CURRENT_DATE - INTERVAL '150 days'),
    (4, 'Petr', 'Procházka', 'petr.prochazka@gmail.com', 1, 456789123, CURRENT_DATE - INTERVAL '100 days'),
    (4, 'Jakub', 'Kučera', 'jakub.kucera@email.cz', 1, 654321789, CURRENT_DATE - INTERVAL '50 days'),
    (4, 'Jiří', 'Veselý', 'jiri.vesely@centrum.cz', 1, 234567891, CURRENT_DATE),
    (4, 'Lukáš', 'Horák', 'lukas.horak@seznam.cz', 1, 321789234, CURRENT_DATE + INTERVAL '50 days'),
    (4, 'David', 'Němec', 'david.nemec@gmail.com', 1, 987654321, CURRENT_DATE + INTERVAL '100 days'),
    (4, 'Jaroslav', 'Pokorný', 'jaroslav.pokorny@email.cz', 1, 567891234, CURRENT_DATE + INTERVAL '150 days'),
    (4, 'Josef', 'Král', 'josef.kral@centrum.cz', 1, 345678912, CURRENT_DATE + INTERVAL '200 days'),
    (5, 'Marek', 'Růžička', 'marek.ruzicka@seznam.cz', 1, 789123456, CURRENT_DATE + INTERVAL '250 days'),
    (5, 'Zdeněk', 'Bartoš', 'zdenek.bartos@gmail.com', 1, 456789123, CURRENT_DATE + INTERVAL '300 days'),
    (5, 'Karel', 'Hájek', 'karel.hajek@centrum.cz', 1, 654321789, CURRENT_DATE + INTERVAL '365 days'),
    (5, 'Filip', 'Pospíšil', 'filip.pospisil@email.cz', 1, 234567891, CURRENT_DATE - INTERVAL '400 days'),
    (5, 'Václav', 'Marek', 'vaclav.marek@gmail.com', 1, 321789234, CURRENT_DATE - INTERVAL '450 days'),
    (5, 'Adam', 'Urban', 'adam.urban@seznam.cz', 1, 123456789, CURRENT_DATE - INTERVAL '500 days'),
    (5, 'Miroslav', 'Duda', 'miroslav.duda@centrum.cz', 1, 987654321, CURRENT_DATE - INTERVAL '550 days'),
    (5, 'Richard', 'Moravec', 'richard.moravec@gmail.com', 1, 567891234, CURRENT_DATE - INTERVAL '600 days');

-- Zakaznici (20 záznamů)
INSERT INTO Pivonka.Zakaznici (Jmeno, Prijmeni, Id_Predcisli, TelefonniCislo, Email)
VALUES
    ('Martin', 'Novák', 1, 123456789, 'martin.novak@seznam.cz'),
    ('Petra', 'Svobodová', 1, 987654321, 'petra.svobodova@gmail.com'),
    ('Jana', 'Novotná', 1, 567891234, 'jana.novotna@email.cz'),
    ('Petr', 'Dvořák', 1, 345678912, 'petr.dvorak@centrum.cz'),
    ('Tomáš', 'Procházka', 1, 456789123, 'tomas.prochazka@seznam.cz'),
    ('Lucie', 'Kučerová', 1, 654321789, 'lucie.kucerova@gmail.com'),
    ('Jakub', 'Veselý', 1, 234567891, 'jakub.vesely@email.cz'),
    ('Eva', 'Horáková', 1, 321789234, 'eva.horakova@centrum.cz'),
    ('David', 'Němec', 1, 987654321, 'david.nemec@outlook.cz'),
    ('Lenka', 'Pokorná', 1, 567891234, 'lenka.pokorna@seznam.cz'),
    ('Jiří', 'Král', 1, 345678912, 'jiri.kral@gmail.com'),
    ('Jan', 'Bartoš', 1, 456789123, 'jan.bartos@gmail.com'),
    ('Kateřina', 'Hájková', 1, 654321789, 'katerina.hajkova@seznam.cz'),
    ('Adam', 'Pospíšil', 1, 234567891, 'adam.pospisil@outlook.cz'),
    ('Petra', 'Marešová', 1, 321789234, 'petra.maresova@gmail.com'),
    ('Lucas', 'Duda', 1, 987654321, 'lucas.duda@outlook.cz'),
    ('Johana', 'Moravcová', 1, 567891234, 'johana.moravcova@gmail.com'),
    ('Mohammed', 'Ali', 2, 123456789, 'mohammed.ali@gmail.com'), -- Cizinec (Slovensko)
    ('Maria', 'Garcia', 4, 12345678, 'maria.garcia@outlook.com'), -- Cizinec (Polsko)
    ('Jens', 'Schmidt', 3, 23456789, 'jens.schmidt@gmail.com'); -- Cizinec (Německo)

-- Rezervace (40 záznamů)
INSERT INTO Pivonka.Rezervace (Id_Zakaznik, Id_Stul, Datum, CasOd, CasDo)
VALUES 
    (1, 7, '2024-04-01', '13:00:00', '14:00:00'),
    (2, 12, '2024-04-01', '14:30:00', '16:30:00'),
    (3, 2, '2024-04-01', '16:30:00', '18:00:00'),
    (4, 19, '2024-04-01', '17:15:00', '18:00:00'),
    (5, 25, '2024-04-01', '19:00:00', '20:00:00'),
    (6, 16, '2024-04-01', '20:30:00', '22:00:00'),
    (7, 23, '2024-04-02', '18:00:00', '19:00:00'),
    (8, 6, '2024-04-02', '19:45:00', '21:15:00'),
    (9, 29, '2024-04-02', '21:30:00', '23:30:00'),
    (10, 13, '2024-04-02', '13:30:00', '16:30:00'),
    (11, 17, '2024-04-02', '14:45:00', '16:15:00'),
    (12, 5, '2024-04-02', '15:30:00', '18:30:00'),
    (13, 4, '2024-04-03', '16:00:00', '18:00:00'),
    (14, 30, '2024-04-03', '17:30:00', '18:15:00'),
    (15, 8, '2024-04-03', '17:15:00', '18:00:00'),
    (16, 22, '2024-04-03', '12:45:00', '14:45:00'),
    (17, 18, '2024-04-03', '15:30:00', '18:30:00'),
    (18, 11, '2024-04-03', '12:30:00', '13:45:00'),
    (19, 14, '2024-04-04', '14:00:00', '15:45:00'),
    (20, 21, '2024-04-04', '15:15:00', '16:15:00'),
    (1, 27, '2024-04-04', '16:45:00', '18:45:00'),
    (2, 24, '2024-04-04', '18:15:00', '19:45:00'),
    (3, 9, '2024-04-04', '20:00:00', '21:30:00'),
    (4, 3, '2024-04-04', '21:30:00', '23:30:00'),
    (5, 15, '2024-04-05', '13:15:00', '14:15:00'),
    (6, 28, '2024-04-05', '14:45:00', '16:45:00'),
    (7, 10, '2024-04-05', '16:30:00', '18:30:00'),
    (8, 20, '2024-04-05', '18:00:00', '19:30:00'),
    (9, 4, '2024-04-05', '20:00:00', '21:30:00'),
    (10, 26, '2024-04-05', '21:30:00', '23:30:00'),
    (11, 1, '2024-04-06', '13:00:00', '14:00:00'),
    (12, 5, '2024-04-06', '14:30:00', '16:30:00'),
    (13, 30, '2024-04-06', '16:30:00', '18:00:00'),
    (14, 14, '2024-04-06', '17:15:00', '18:00:00'),
    (15, 19, '2024-04-06', '19:00:00', '20:00:00'),
    (16, 8, '2024-04-06', '20:30:00', '22:00:00'),
    (17, 23, '2024-04-07', '18:00:00', '19:00:00'),
    (18, 13, '2024-04-07', '19:45:00', '21:15:00'),
    (19, 7, '2024-04-07', '21:30:00', '23:30:00'),
    (18, 18, '2024-04-10', '13:30:00', '16:30:00');

-- Objednavky (30 záznamů)
INSERT INTO Pivonka.Objednavky (Id_Rezervace, Id_ZamestnanecCisnik, Id_ZamestnanecKuchar, Datum, CasPrijeti, CasVyrizeni)
VALUES
    (1, 20, 6, '2024-04-01', '13:05:00', '13:20:00'),
    (2, 19, 7, '2024-04-01', '14:35:00', '14:47:00'),
    (3, 18, 8, '2024-04-01', '17:00:00', '17:18:00'),
    (4, 17, 9, '2024-04-01', '17:35:00', '17:50:00'),
    (5, 16, 10, '2024-04-01', '19:10:00', '19:28:00'),
    (6, 15, 11, '2024-04-01', '20:05:00', '20:22:00'),
    (7, 14, 12, '2024-04-02', '18:10:00', '18:25:00'),
    (8, 13, 2, '2024-04-02', '19:50:00', '20:07:00'),
    (9, 20, 2, '2024-04-02', '21:30:00', '21:45:00'),
    (10, 19, 3, '2024-04-02', '13:40:00', '13:55:00'),
    (11, 19, 3, '2024-04-02', '14:45:00', '15:02:00'),
    (12, 20, 10, '2024-04-03', '12:10:00', '12:27:00'),
    (13, 20, 10, '2024-04-03', '12:25:00', '12:40:00'),
    (14, 18, 9, '2024-04-03', '15:30:00', '15:45:00'),
    (15, 13, 8, '2024-04-03', '15:50:00', '16:05:00'),
    (16, 13, 7, '2024-04-03', '16:35:00', '16:53:00'),
    (17, 14, 6, '2024-04-03', '17:05:00', '17:20:00'),
    (18, 16, 6, '2024-04-03', '17:40:00', '17:57:00'),
    (19, 16, 7, '2024-04-03', '18:10:00', '18:25:00'),
    (20, 17, 8, '2024-04-03', '18:45:00', '19:03:00'),
    (21, 16, 10, '2024-04-03', '19:20:00', '19:35:00'),
    (22, 20, 10, '2024-04-03', '20:00:00', '20:17:00'),
    (23, 4, 8, '2024-04-04', '12:50:00', '13:07:00'),
    (24, 4, 8, '2024-04-04', '13:30:00', '13:47:00'),
    (25, 5, 7, '2024-04-04', '14:10:00', '14:25:00'),
    (26, 5, 6, '2024-04-04', '14:50:00', '15:08:00'),
    (27, 4, 6, '2024-04-04', '15:35:00', '15:50:00'),
    (28, 19, 3, '2024-04-04', '16:05:00', '16:20:00'),
    (29, 13, 3, '2024-04-04', '16:50:00', '17:05:00'),
    (30, 13, 3, '2024-04-04', '17:25:00', '17:40:00'),
    (40, 13, 3, '2024-04-10', '13:35:00', '13:50:00');

INSERT INTO Pivonka.PolozkyObjednavek (Id_Objednavka, Id_PolozkaMenu, Mnozstvi)
VALUES
    -- Objednávka 1
    (1, 1, 2), -- Smažený sýr
    (1, 6, 1), -- Hovězí guláš
    (1, 7, 2), -- Kuřecí polévka s nudlemi
    -- Objednávka 2
    (2, 9, 1), -- Tatarský
    (2, 10, 3), -- Pizza Margherita
    -- Objednávka 3
    (3, 15, 2), -- Jablkový závin
    (3, 16, 1), -- Těstoviny Carbonara
    -- Objednávka 4
    (4, 18, 1), -- Kuřecí salát
    (4, 19, 1), -- Tzatziki
    -- Objednávka 5
    (5, 22, 2), -- Kořeněná zeleninová polévka
    (5, 23, 2), -- Hovězí steak
    -- Objednávka 6
    (6, 25, 1), -- Grilovaný halibut
    (6, 24, 2), -- Krevety na grilu
    -- Objednávka 7
    (7, 1, 1), -- Smažený sýr
    (7, 2, 2), -- Telecí řízek
    -- Objednávka 8
    (8, 3, 2), -- Grilované kuřecí prsa
    (8, 4, 1), -- Tatarský biftek
    -- Objednávka 9
    (9, 5, 1), -- Losos na grilu
    (9, 6, 1), -- Hovězí guláš
    -- Objednávka 10
    (10, 7, 2), -- Kuřecí polévka s nudlemi
    (10, 8, 2), -- Česneková
    -- Objednávka 11
    (11, 9, 1), -- Tatarský
    (11, 10, 2), -- Pizza Margherita
    -- Objednávka 12
    (12, 11, 2), -- Lasagne
    (12, 12, 1), -- Ravioli s ricottou a špenátem
    -- Objednávka 13
    (13, 13, 1), -- Tiramisu
    (13, 14, 1), -- Cheesecake
    -- Objednávka 14
    (14, 15, 1), -- Jablkový závin
    (14, 16, 1), -- Těstoviny Carbonara
    -- Objednávka 15
    (15, 17, 2), -- Paella
    (15, 18, 1), -- Sushi mix
    -- Objednávka 16
    (16, 19, 1), -- Kuřecí salát
    (16, 20, 1), -- Tzatziki
    -- Objednávka 17
    (17, 21, 1), -- Sýrová pomazánka
    (17, 22, 1), -- Kořeněná zeleninová polévka
    -- Objednávka 18
    (18, 23, 2), -- Hovězí steak
    (18, 24, 2), -- Krevety na grilu
    -- Objednávka 19
    (19, 25, 1), -- Grilovaný halibut
    (19, 1, 1), -- Smažený sýr
    -- Objednávka 20
    (20, 2, 2), -- Telecí řízek
    (20, 3, 1); -- Grilované kuřecí prsa

-- Trigger řeší situaci, kdy je nadřízená pozice smazána.
-- V takovém případě má být Id_PoziceNadrizeny nastavena na NULL,
-- a to právě u těch podřízených pozic, které mají daného nadřízeného.
CREATE OR REPLACE FUNCTION trg_pozice_before_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Nastavení Id_Pozice na NULL pro související zaměstnance.
    UPDATE Pivonka.Zamestnanci
    SET Id_Pozice = NULL
    WHERE Id_Pozice = OLD.Id_Pozice;

    -- Nastavení Id_PoziceNadrizeny na NULL pro podřízené pozice.
    UPDATE Pivonka.Pozice
    SET Id_PoziceNadrizeny = NULL
    WHERE Id_PoziceNadrizeny = OLD.Id_Pozice;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Přiřazení triggeru.
CREATE TRIGGER trg_pozice_before_delete
BEFORE DELETE ON Pivonka.Pozice
FOR EACH ROW
EXECUTE FUNCTION trg_pozice_before_delete();

-- Otestování funkčnosti triggeru
-- SELECT * FROM Pivonka.Pozice;
-- DELETE FROM Pivonka.Pozice WHERE Id_Pozice = 1;
-- SELECT * FROM Pivonka.Pozice;

-- Přidání fulltextového indexu na sloupec Nazev
CREATE INDEX idx_pozice_nazev_fulltext_czech
ON Pivonka.Pozice
USING gin (to_tsvector('simple', Nazev));

-- SELECT * FROM Pivonka.Pozice;

-- SELECT *
-- FROM Pivonka.Pozice
-- WHERE to_tsvector('simple', Nazev) @@ to_tsquery('Maj:*');

-- Vytvoření pohledu Pohled_Cisnici
CREATE OR REPLACE VIEW Pivonka.Pohled_Cisnici AS
SELECT 
    Zamestnanci.Id_Zamestnanec, 
    Pozice.Nazev AS Pozice, 
    Zamestnanci.Jmeno, 
    Zamestnanci.Prijmeni
FROM 
    Pivonka.Zamestnanci AS Zamestnanci
JOIN 
    Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
WHERE 
    Pozice.Nazev IN ('Číšník', 'Vrchní číšník');

-- Vytvoření pohledu Pohled_Kuchari
CREATE OR REPLACE VIEW Pivonka.Pohled_Kuchari AS
SELECT 
    Zamestnanci.Id_Zamestnanec, 
    Pozice.Nazev AS Pozice, 
    Zamestnanci.Jmeno, 
    Zamestnanci.Prijmeni
FROM 
    Pivonka.Zamestnanci AS Zamestnanci
JOIN 
    Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
WHERE 
    Pozice.Nazev IN ('Kuchař', 'Šéfkuchař');

-- Vytvoření pohledu Pohled_Rezervace
CREATE OR REPLACE VIEW Pivonka.Pohled_Rezervace AS
SELECT 
    Stoly.Id_Stul AS Cislo_stolu,
    CONCAT(Zakaznici.Jmeno, ' ', Zakaznici.Prijmeni) AS Zakaznik, 
    Rezervace.Datum,
    TO_CHAR(Rezervace.CasOd, 'HH24:MI') || ' - ' || TO_CHAR(Rezervace.CasDo, 'HH24:MI') AS CasRezervace
FROM 
    Pivonka.Rezervace AS Rezervace
JOIN 
    Pivonka.Stoly AS Stoly ON Rezervace.Id_Stul = Stoly.Id_Stul
JOIN 
    Pivonka.Zakaznici AS Zakaznici ON Rezervace.Id_Zakaznik = Zakaznici.Id_Zakaznik;