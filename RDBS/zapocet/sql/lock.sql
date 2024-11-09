-- Uzamknutí celé tabulky
DROP TABLE IF EXISTS stoly_locked;
CREATE TEMP TABLE stoly_locked AS (SELECT * FROM Pivonka.Stoly);

BEGIN;
LOCK TABLE Pivonka.Stoly IN ACCESS EXCLUSIVE MODE;
UPDATE stoly_locked SET PocetMist = PocetMist + 1;
COMMIT;

SELECT * FROM stoly_locked;

-- Uzamknutí konkrétních řádků tabulky
DROP TABLE IF EXISTS stoly_locked;
CREATE TEMP TABLE stoly_locked AS (SELECT * FROM Pivonka.Stoly);

BEGIN;
SELECT * FROM Pivonka.Stoly WHERE PocetMist > 0 FOR UPDATE;
UPDATE stoly_locked SET PocetMist = PocetMist + 1;
COMMIT;

SELECT * FROM stoly_locked;