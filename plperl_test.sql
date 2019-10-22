
-- CREATE EXTENSION plperlu;
-- 
CREATE FUNCTION perl_max(integer, integer) RETURNS integer AS $$
    if ($_[0] > $_[1]) { return $_[0]; }
    return $_[1];
$$ LANGUAGE plperlu;

SELECT perl_max(10, 5);

DROP FUNCTION perl_max;

