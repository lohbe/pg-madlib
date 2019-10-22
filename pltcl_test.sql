
-- CREATE EXTENSION pltclu;

CREATE FUNCTION tcl_max(integer, integer) RETURNS integer AS $$
    if {$1 > $2} {return $1}
    return $2
$$ LANGUAGE pltclu STRICT;

SELECT tcl_max(10, 5);

DROP FUNCTION tcl_max;