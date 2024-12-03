-- Uzamknutí celé tabulky
DROP TABLE IF EXISTS Pivonka.stoly_locked;
CREATE TABLE Pivonka.stoly_locked AS (SELECT * FROM Pivonka.Stoly);

-- Přidání oprávnění roli čišník
GRANT SELECT ON Pivonka.stoly_locked TO cisnik;

BEGIN;
	LOCK TABLE Pivonka.stoly_locked IN ACCESS EXCLUSIVE MODE;
	UPDATE Pivonka.stoly_locked SET PocetMist = PocetMist + 1;
	SELECT pg_sleep(10); -- Simulace operace, která trvá 10 sekund
COMMIT;

-- Uzamknutí konkrétních řádků tabulky
-- Alternativa SELECT FOR UPDATE
DROP TABLE IF EXISTS Pivonka.stoly_locked;
CREATE TABLE Pivonka.stoly_locked AS (SELECT * FROM Pivonka.Stoly);

BEGIN;
	SELECT * FROM Pivonka.stoly_locked WHERE PocetMist > 0 FOR UPDATE;
	UPDATE Pivonka.stoly_locked SET PocetMist = PocetMist + 1;
COMMIT;

SELECT * FROM Pivonka.stoly_locked;

-- Návod
-- 1. Přidělit uživateli petr (nebo skupině čišník, ve které je) oprávnění k tabulce stoly_locked
-- 2. Spustit uzamčení tabulky
-- 3. Spustit SELECT * FROM Pivonka.stoly_locked; (petr_select_lock.sql) s uživatelem petr
-- 4. Petrův příkaz by měl čekat na znovuodemčení tabulky