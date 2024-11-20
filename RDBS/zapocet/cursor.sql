-- Tabulka polozkymenu, udělat tabulku polozkymenu_sleva za pomocí cursoru
-- Udělat funkci, iterovat polozkymenu pomocí FOR, pro každý řádek vygenerovat random slevu (5%-10%)
-- Přejmenovat sloupec Cena na cena_se_slevou
-- PostgreSQL

-- Udělat to jako proceduru
-- přidat 1x ošetření chyb (HANDLER / TRY…CATCH / RAISE / EXCEPTION

CREATE TABLE IF NOT EXISTS Pivonka.PolozkyMenu_Sleva (
  Id_PolozkaMenu INT PRIMARY KEY,
  Nazev VARCHAR(40) NOT NULL,
  Cena_Puvodni DECIMAL(7, 2) NOT NULL,
  Cena_Se_Slevou DECIMAL(7, 2) NOT NULL,
  Vyse_Slevy DECIMAL(4, 2) NOT NULL
);

CREATE OR REPLACE FUNCTION Pivonka.GenerujSlevyCursor()
RETURNS VOID AS $$
DECLARE
  menu_cursor CURSOR FOR 
    SELECT Id_PolozkaMenu, Nazev, Cena 
    FROM Pivonka.PolozkyMenu;
  
  polo RECORD;
  nahodna_sleva NUMERIC(4, 2);
  zlevnena_cena NUMERIC(7, 2);
BEGIN
  TRUNCATE TABLE Pivonka.PolozkyMenu_Sleva;
  
  OPEN menu_cursor;
  
  LOOP
    FETCH menu_cursor INTO polo;
    
    EXIT WHEN NOT FOUND;
    
    nahodna_sleva := ROUND((RANDOM() * 0.05 + 0.05)::NUMERIC, 2);
    zlevnena_cena := ROUND((polo.Cena * (1 - nahodna_sleva))::NUMERIC, 2);
    
    INSERT INTO Pivonka.PolozkyMenu_Sleva (
      Id_PolozkaMenu, 
      Nazev, 
      Cena_Puvodni, 
      Cena_Se_Slevou, 
      Vyse_Slevy
    ) VALUES (
      polo.Id_PolozkaMenu, 
      polo.Nazev, 
      polo.Cena, 
      zlevnena_cena,
      nahodna_sleva * 100
    );
  END LOOP;
  
  CLOSE menu_cursor;
END;
$$ LANGUAGE plpgsql;

SELECT Pivonka.GenerujSlevyCursor();
SELECT * FROM Pivonka.PolozkyMenu_Sleva;


















CREATE OR REPLACE PROCEDURE Pivonka.GenerujSlevyCursor()
LANGUAGE plpgsql
AS $$
DECLARE
  menu_cursor CURSOR FOR 
    SELECT Id_PolozkaMenu, Nazev, Cena 
    FROM Pivonka.PolozkyMenu;
  
  polo RECORD;
  nahodna_sleva NUMERIC(4, 2);
  zlevnena_cena NUMERIC(7, 2);
  pocet_radku INT := 0;
BEGIN
  -- Kontrola existence zdrojové tabulky
  IF NOT EXISTS (
    SELECT 1 FROM Pivonka.PolozkyMenu
  ) THEN
    RAISE EXCEPTION 'Tabulka PolozkyMenu je prázdná!';
  END IF;

  TRUNCATE TABLE Pivonka.PolozkyMenu_Sleva;
  
  OPEN menu_cursor;
  
  LOOP
    FETCH menu_cursor INTO polo;
    
    EXIT WHEN NOT FOUND;
    
    BEGIN
      nahodna_sleva := ROUND((RANDOM() * 0.05 + 0.05)::NUMERIC, 2);
      zlevnena_cena := ROUND((polo.Cena * (1 - nahodna_sleva))::NUMERIC, 2);
      
      INSERT INTO Pivonka.PolozkyMenu_Sleva (
        Id_PolozkaMenu, 
        Nazev, 
        Cena_Puvodni, 
        Cena_Se_Slevou, 
        Vyse_Slevy
      ) VALUES (
        polo.Id_PolozkaMenu, 
        polo.Nazev, 
        polo.Cena, 
        zlevnena_cena,
        nahodna_sleva * 100
      );
      
      pocet_radku := pocet_radku + 1;
    EXCEPTION 
      WHEN OTHERS THEN
        RAISE WARNING 'Chyba při zpracování položky %: %', polo.Id_PolozkaMenu, SQLERRM;
    END;
  END LOOP;
  
  CLOSE menu_cursor;

  -- Výstup o počtu zpracovaných řádků
  RAISE NOTICE 'Bylo zpracováno % položek', pocet_radku;
END;
$$;

-- Volání procedury
CALL Pivonka.GenerujSlevyCursor();

-- Zobrazení výsledků
SELECT * FROM Pivonka.PolozkyMenu_Sleva;