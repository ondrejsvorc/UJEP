CREATE OR REPLACE PROCEDURE drop_pivonka()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'Mazání schématu...';
	DROP SCHEMA Pivonka CASCADE;
	RAISE NOTICE 'Schéma bylo úspěšně smazáno.';
	
	EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'Došlo k chybě při mazání schématu. Transakce byla vrácena zpět.';
		ROLLBACK;
		RETURN;
END;
$$;

CALL drop_pivonka();