--Test PL/pgSQL function

CREATE FUNCTION pgtestfunction(numtimes integer, msg text)
    RETURNS text AS
$$
DECLARE
    strresult text;
BEGIN
    strresult := '';
    IF numtimes > 0 THEN
        FOR i IN 1 .. numtimes LOOP
            strresult := strresult || msg || E'\r\n';
        END LOOP;
    END IF;
    RETURN strresult;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE
SECURITY DEFINER
  COST 10;

--To call the function we do this and it returns ten hello there's with carriage returns as a single text field.
SELECT pgtestfunction(10, 'Hello World');

DROP FUNCTION pgtestfunction;