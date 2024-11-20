### Relevantní zdroje
- https://neon.tech/postgresql/postgresql-plpgsql/plpgsql-if-else-statements
- https://www.w3schools.com/sql/sql_case.asp
- https://www.postgresql.org/docs/7.2/plpgsql-control-structures.html

### IF

```
if condition_1 then
  statement_1;
elsif condition_2 then
  statement_2
...
elsif condition_n then
  statement_n;
else
  else-statement;
end if;
```

## Cykly
- **LOOP**
- **WHILE**
- **FOR**
- **FOREACH**

### LOOP
- základní konstrukce pro cykly
- nekonečný cyklus
- nemusí mít jméno, může být anonymní

#### EXIT
- vystoupení z cyklu
- 2 zápisy:
  - `IF podminka THEN EXIT;`
  - `EXIT WHEN podmínka;`

```postgresql
LOOP
    -- ...commands
    IF count > 0 THEN
        EXIT;
    END IF;
    -- ...commands
END LOOP;
```

```postgresql
LOOP
    -- ...commands
    EXIT WHEN count > 0;
END LOOP;
```

### WHILE

```postgresql
WHILE boolean-expression LOOP
    statements
END LOOP [ label ];
```

```postgresql
WHILE amount_owed > 0 AND gift_certificate_balance > 0 LOOP
    -- some computations here
END LOOP;
```

```postgresql
WHILE NOT done LOOP
    -- some computations here
END LOOP;
```

### FOR
- name = název iterační proměnné
- reverse = true/false
- expression .. expression = od .. do = min .. max
- BY = krok (defaultně 1)

```postgresql
FOR name IN [ REVERSE ] expression .. expression [ BY expression ] LOOP
    statements
END LOOP [ label ];
```

```postgresql
FOR i IN 1..10 LOOP
    -- i will take on the values 1,2,3,4,5,6,7,8,9,10 within the loop
END LOOP;
```

```postgresql
FOR i IN REVERSE 10..1 LOOP
    -- i will take on the values 10,9,8,7,6,5,4,3,2,1 within the loop
END LOOP;
```

```postgresql
FOR i IN REVERSE 10..1 BY 2 LOOP
    -- i will take on the values 10,8,6,4,2 within the loop
END LOOP;
```

### FOREACH

```postgresql
FOREACH target [ SLICE number ] IN ARRAY expression LOOP
    statements
END LOOP [ label ];
```

```postgresql
CREATE FUNCTION sum(int[]) RETURNS int8 AS $$
DECLARE
  s int8 := 0;
  x int;
BEGIN
  FOREACH x IN ARRAY $1
  LOOP
    s := s + x;
  END LOOP;
  RETURN s;
END;
$$ LANGUAGE plpgsql;
```

## CURSOR
- databázový objekt, který umožňuje postupně procházet řádky výsledku dotazu
- ukazatel do víceřádkového výsledku, aby byl vždy schopen zobrazit jeden záznam
- INSERT, UPDATE, DELETE, TRUNCATE, SELECT 
- INSERT/UPDATE/DELETE využívá interně kurzor (proto, když vkládáme více řádků pomocí jednoho INSERTU, tak pokud je v jednom z nich chyba, nevloží se ani jeden)
- v SELECTu můžeme použít CURSOR pro naše účely, přistupovat ke každému řádku, který SELECT vrací zvlášť (trošku ta celá konstrukce připomíná iterátor)
- CURSOR je výsledek SELECTu, který chceme procházet řádek po řádku a nějak s nimi postupně pracovat
- používá se nejčastěji v kombinaci s LOOP cyklem

### Record
- datový typ pro reprezentaci řádku
- lze si udělat proměnnou a použít ve for cyklu v rámci SELECTu (tím můžeme obejít použití CURSORu)

### Princip
1. Deklarace kurzoru (`DECLARE nazev_kurzoru Cursor FOR SELECT`)
2. Otevření kurzoru (`OPEN nazev_kurzoru;`) - provede se daný SELECT
3. Zacyklení a postupné získávání záznamů + business logic `FETCH nazev_kurzoru INTO promenna;`
4. Zavření kurzoru

```postgresql
CREATE OR REPLACE FUNCTION fetch_film_titles_and_years(
   OUT p_title VARCHAR(255),
   OUT p_release_year INTEGER
)
RETURNS SETOF RECORD AS
$$
DECLARE
    film_cursor CURSOR FOR
        SELECT title, release_year
        FROM film;
    film_record RECORD;
BEGIN
    -- Open cursor
    OPEN film_cursor;

    -- Fetch rows and return
    LOOP
        FETCH NEXT FROM film_cursor INTO film_record;
        EXIT WHEN NOT FOUND;

        p_title = film_record.title;
        p_release_year = film_record.release_year;
        RETURN NEXT;
    END LOOP;

    -- Close cursor
    CLOSE film_cursor;
END;
$$
LANGUAGE PLPGSQL;
```

```postgresql
SELECT * FROM fetch_film_titles_and_years();
```