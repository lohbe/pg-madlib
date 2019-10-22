-- PL/Python test function (returns max)

-- CREATE OR REPLACE PROCEDURAL LANGUAGE plpythonu;

CREATE FUNCTION pytestfunction(a integer, b integer)
RETURNS integer
AS $$
if a > b:
    return a
return b
$$ LANGUAGE plpythonu;

--Test Python code
SELECT pytestfunction(10, 5);

DROP function pytestfunction;