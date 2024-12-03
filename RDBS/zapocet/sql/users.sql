-- readonly
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'readonly') THEN
        REVOKE ALL ON SCHEMA Pivonka FROM readonly;
        REVOKE SELECT ON ALL TABLES IN SCHEMA Pivonka FROM readonly;
        ALTER DEFAULT PRIVILEGES IN SCHEMA Pivonka REVOKE SELECT ON TABLES FROM readonly;
    END IF;
END $$;

DROP ROLE IF EXISTS readonly;
DROP USER IF EXISTS honza;

CREATE ROLE readonly;
GRANT USAGE ON SCHEMA Pivonka TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA Pivonka TO readonly;

CREATE USER honza WITH PASSWORD 'Aa123456';
GRANT readonly TO honza;

-- cisnik
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cisnik') THEN
        REVOKE ALL ON SCHEMA Pivonka FROM cisnik;
        REVOKE ALL ON ALL TABLES IN SCHEMA Pivonka FROM cisnik;
        REVOKE ALL ON ALL SEQUENCES IN SCHEMA Pivonka FROM cisnik;
        ALTER DEFAULT PRIVILEGES IN SCHEMA Pivonka REVOKE ALL ON TABLES FROM cisnik;
    END IF;
END $$;

DROP ROLE IF EXISTS cisnik;
DROP USER IF EXISTS petr;

CREATE ROLE cisnik;
GRANT USAGE ON SCHEMA Pivonka TO cisnik;
GRANT SELECT ON Pivonka.Stoly TO cisnik;
GRANT SELECT ON Pivonka.Rezervace TO cisnik;
GRANT INSERT ON Pivonka.Objednavky TO cisnik;

CREATE USER petr WITH PASSWORD 'Aa123456';
GRANT cisnik TO petr;