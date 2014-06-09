-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'generate_id' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION generate_id()
RETURNS varchar(32)
AS
$BODY$
DECLARE
    chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
    result varchar(32) := '';
    string1 varchar(8) := '';
    string2 varchar(8) := '';
    string3 varchar(8) := '';
    subStringLength integer := 8;
    a integer := 0;
    b integer := 0;
    c integer := 0;
BEGIN

      FOR a IN 1..subStringLength LOOP
        string1 := string1 || chars[1 + random() * (array_length(chars, 1) - 1)];
      END LOOP;

      FOR b IN 1..subStringLength LOOP
        string2 := string2 || chars[1 + random() * (array_length(chars, 1) - 1)];
      END LOOP;

      FOR c IN 1..subStringLength LOOP
        string3 := string3 || chars[1 + random() * (array_length(chars, 1) - 1)];
      END LOOP;

        result := string1 || '-' || string2 || '-' || string3;
    RETURN result;
END;
$BODY$
LANGUAGE plpgsql;
