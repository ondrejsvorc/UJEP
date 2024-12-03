-- 1x CURSOR a také 1x ošetření chyb
CREATE OR REPLACE FUNCTION Pivonka.GenerujSlevyCursor()
RETURNS TABLE (
    Id_PolozkaMenu INT, -- Uvnitř RETURNS TABLE nelze použít PRIMARY KEY
    Nazev VARCHAR(40),
    Cena_Puvodni DECIMAL(7, 2),
    Cena_Se_Slevou DECIMAL(7, 2),
    Vyse_Slevy DECIMAL(4, 2)
) AS $$
DECLARE
    menu_cursor CURSOR FOR 
        SELECT polozkyMenu.Id_PolozkaMenu AS cursor_Id_PolozkaMenu,
               polozkyMenu.Nazev AS cursor_Nazev,
               polozkyMenu.Cena AS cursor_Cena
        FROM Pivonka.PolozkyMenu AS polozkyMenu;
    zaznam RECORD;
    nahodna_sleva NUMERIC(4, 2);
    zlevnena_cena NUMERIC(7, 2);
BEGIN
    OPEN menu_cursor;
    
    LOOP
        FETCH menu_cursor INTO zaznam;
        EXIT WHEN NOT FOUND;

		IF zaznam.cursor_Cena <= 0 THEN
            RAISE EXCEPTION 'Neplatná cena pro položku menu s ID %: %', 
                          zaznam.cursor_Id_PolozkaMenu,
                          zaznam.cursor_Cena::TEXT;
        END IF;
		
        nahodna_sleva := ROUND((RANDOM() * 0.05 + 0.05)::NUMERIC, 2);
        zlevnena_cena := ROUND((zaznam.cursor_Cena * (1 - nahodna_sleva))::NUMERIC, 2);
        
        Id_PolozkaMenu := zaznam.cursor_Id_PolozkaMenu;
        Nazev := zaznam.cursor_Nazev;
        Cena_Puvodni := zaznam.cursor_Cena;
        Cena_Se_Slevou := zlevnena_cena;
        Vyse_Slevy := nahodna_sleva * 100;
        
        RETURN NEXT;
    END LOOP;
    
    CLOSE menu_cursor;
    RETURN;
EXCEPTION
	WHEN OTHERS THEN
        RAISE EXCEPTION 'Chyba při generování slev: % (SQL State: %)', SQLERRM, SQLSTATE;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Pivonka.GenerujSlevyCursor();
-- Situace:
-- Chybí následující constraint:

--ALTER TABLE pivonka.polozkymenu
--ADD CONSTRAINT check_cena_positive CHECK (cena > 0);

-- Je umožněno toto:
-- INSERT INTO pivonka.polozkymenu (id_polozkamenu, nazev, cena)
-- VALUES (26, 'test_exception', -100);

-- Díky výjimkám toto odhalíme, např. při generování ceny.

-- 1× PROCEDURE
CREATE OR REPLACE PROCEDURE Pivonka.VytvorTabulkuSlev()
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS Pivonka.PolozkyMenu_Sleva;
    
    CREATE TABLE Pivonka.PolozkyMenu_Sleva AS
    SELECT * FROM Pivonka.GenerujSlevyCursor();
    
    ALTER TABLE Pivonka.PolozkyMenu_Sleva 
    ADD PRIMARY KEY (Id_PolozkaMenu);
END;
$$;

CALL Pivonka.VytvorTabulkuSlev();
SELECT * FROM Pivonka.PolozkyMenu_Sleva;