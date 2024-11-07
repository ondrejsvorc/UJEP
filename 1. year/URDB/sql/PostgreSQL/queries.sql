-- Nejoblíbenější (nejobjednávanější) jídla.
SELECT 
    PolozkyMenu.Nazev AS NazevJidla,
    COUNT(*) AS PocetObjednavek
FROM
    Pivonka.PolozkyObjednavek AS PolozkyObjednavek
INNER JOIN 
    Pivonka.PolozkyMenu AS PolozkyMenu ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
GROUP BY 
    PolozkyMenu.Nazev
ORDER BY 
    PocetObjednavek DESC;

-- Nejoblíbenější (nejobjednávanější) jídla dle data objednávky.
SELECT 
    PolozkyMenu.Nazev AS NazevJidla,
    DATE(Objednavky.Datum) AS DatumObjednavky,
    COUNT(*) AS PocetObjednavek
FROM
    Pivonka.Objednavky AS Objednavky
INNER JOIN 
    Pivonka.PolozkyObjednavek AS PolozkyObjednavek ON Objednavky.Id_Objednavka = PolozkyObjednavek.Id_Objednavka
INNER JOIN 
    Pivonka.PolozkyMenu AS PolozkyMenu ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
GROUP BY 
    PolozkyMenu.Nazev,
    DATE(Objednavky.Datum)
ORDER BY 
    DatumObjednavky DESC,
    PocetObjednavek DESC;

-- Zákazníci, kteří utratily nejvíce peněz.
SELECT
    Zakaznici.Jmeno,
    Zakaznici.Prijmeni,
    SUM(PolozkyMenu.Cena * PolozkyObjednavek.Mnozstvi) AS CelkovaUtrata
FROM 
    Pivonka.Zakaznici AS Zakaznici
LEFT JOIN 
    Pivonka.Rezervace AS Rezervace ON Zakaznici.Id_Zakaznik = Rezervace.Id_Zakaznik
LEFT JOIN 
    Pivonka.Objednavky AS Objednavky ON Rezervace.Id_Rezervace = Objednavky.Id_Rezervace
LEFT JOIN 
    Pivonka.PolozkyObjednavek AS PolozkyObjednavek ON Objednavky.Id_Objednavka = PolozkyObjednavek.Id_Objednavka
LEFT JOIN 
    Pivonka.PolozkyMenu AS PolozkyMenu ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
GROUP BY 
    Zakaznici.Jmeno,
    Zakaznici.Prijmeni
ORDER BY
    CelkovaUtrata DESC;

-- Nejproduktivnější zaměstnanci.
SELECT
    Zamestnanci.Jmeno,
    Zamestnanci.Prijmeni,
    Pozice.Nazev,
    COUNT(*) AS PocetVyrizenychObjednavek
FROM 
    Pivonka.Zamestnanci AS Zamestnanci
INNER JOIN 
    Pivonka.Objednavky AS Objednavky ON (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecCisnik) OR (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecKuchar)
INNER JOIN
    Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
GROUP BY 
    Zamestnanci.Jmeno,
    Zamestnanci.Prijmeni,
    Pozice.Nazev
ORDER BY
    PocetVyrizenychObjednavek DESC;

-- Nejproduktivnější zaměstnanci dle data.
SELECT
    Zamestnanci.Jmeno,
    Zamestnanci.Prijmeni,
    Pozice.Nazev AS Pozice,
    Objednavky.Datum::DATE AS DatumObjednavky,
    COUNT(*) AS PocetVyrizenychObjednavek
FROM 
    Pivonka.Zamestnanci AS Zamestnanci
INNER JOIN 
    Pivonka.Objednavky AS Objednavky ON (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecCisnik) OR (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecKuchar)
INNER JOIN
    Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
GROUP BY 
    Zamestnanci.Jmeno,
    Zamestnanci.Prijmeni,
    Pozice.Nazev,
    Objednavky.Datum::DATE
ORDER BY
    PocetVyrizenychObjednavek DESC,
    DatumObjednavky DESC;

-- Zákazníci s více než 2 rezervacemi.
SELECT 
    Zakaznici.Jmeno,
	Zakaznici.Prijmeni,
    COUNT(*) AS PocetRezervaci
FROM 
    Pivonka.Rezervace AS Rezervace
INNER JOIN
    Pivonka.Zakaznici AS Zakaznici ON Rezervace.Id_Zakaznik = Zakaznici.Id_Zakaznik
GROUP BY 
    Zakaznici.Jmeno,
    Zakaznici.Prijmeni
HAVING 
    COUNT(*) > 2;

-- Rekurzivní SELECT.
-- Zobrazí pozice a jejich nadřízené pozice.
WITH RECURSIVE PoziceCTE AS (
    SELECT Id_Pozice, Nazev, NULL::VARCHAR AS Nazev_Nadrizene_Pozice
    FROM Pivonka.Pozice
    WHERE Id_PoziceNadrizeny IS NULL
    UNION ALL
    SELECT p.Id_Pozice, p.Nazev, cte.Nazev
    FROM Pivonka.Pozice p
    JOIN PoziceCTE cte ON p.Id_PoziceNadrizeny = cte.Id_Pozice
)
SELECT Id_Pozice, Nazev, Nazev_Nadrizene_Pozice
FROM PoziceCTE
ORDER BY Id_Pozice;

-- Další rekurzivní SELECT.
-- Zobrazí zaměstnance na pozicích a jejích nadřízené.
WITH RECURSIVE position_hierarchy AS (
    SELECT
        z.Id_Zamestnanec,
        z.Jmeno || ' ' || z.Prijmeni AS jmeno_zamestnance,
        p.Id_Pozice,
        p.Nazev AS nazev_pozice,
        p.Id_PoziceNadrizeny,
        CASE
            WHEN p.Id_PoziceNadrizeny IS NULL THEN NULL
            ELSE n.Jmeno || ' ' || n.Prijmeni
        END AS jmeno_nadrizeneho
    FROM Pivonka.Zamestnanci z
    JOIN Pivonka.Pozice p ON z.Id_Pozice = p.Id_Pozice
    LEFT JOIN Pivonka.Zamestnanci n ON p.Id_PoziceNadrizeny = n.Id_Pozice
),
recursive_hierarchy AS (
    SELECT
        id_zamestnanec,
        jmeno_zamestnance,
        id_pozice,
        nazev_pozice,
        id_pozicenadrizeny,
        jmeno_nadrizeneho
    FROM position_hierarchy
    WHERE id_pozicenadrizeny IS NULL
    UNION ALL
    SELECT
        ph.id_zamestnanec,
        ph.jmeno_zamestnance,
        ph.id_pozice,
        ph.nazev_pozice,
        ph.id_pozicenadrizeny,
        ph.jmeno_nadrizeneho
    FROM position_hierarchy ph
    INNER JOIN recursive_hierarchy rh ON ph.id_pozicenadrizeny = rh.id_pozice
)
SELECT DISTINCT * 
FROM recursive_hierarchy
ORDER BY Id_Pozice;