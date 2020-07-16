SET PAGESIZE 999

SPOOL elf_t.txt

DROP TYPE elf_t FORCE;

-- Create a elf_t object type and type body as a subtype of the base_t
CREATE OR REPLACE TYPE elf_t UNDER base_t
( name VARCHAR2(30)
, genus VARCHAR2(30)
, CONSTRUCTOR FUNCTION elf_t
  ( name VARCHAR2
  , genus VARCHAR2) RETURN SELF AS RESULT
, OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
, MEMBER PROCEDURE set_name
  ( name VARCHAR2)
, MEMBER FUNCTION get_genus RETURN VARCHAR2
, MEMBER PROCEDURE set_genus
  ( genus VARCHAR2)
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

DESC elf_t

CREATE OR REPLACE TYPE BODY elf_t IS
    CONSTRUCTOR FUNCTION elf_t
    ( name VARCHAR2
    , genus VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.name := name;
        self.genus := genus;
    END elf_t;
    
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.name;
    END get_name;
    
    MEMBER PROCEDURE set_name
    ( name VARCHAR2) IS
    BEGIN
        self.name := name;
    END set_name;
    
    MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
    BEGIN
         RETURN self.genus;
    END get_genus;
    
    MEMBER PROCEDURE set_genus
    ( genus VARCHAR2) IS
    BEGIN
        self.genus := genus;
    END set_genus;
    
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
        RETURN (self AS base_t).to_string()||'['||self.name||']['||self.genus||']';
    END to_string;
END;
/

SPOOL OFF

QUIT;
