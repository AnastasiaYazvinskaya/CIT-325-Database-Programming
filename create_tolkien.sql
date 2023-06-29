SET PAGESIZE 999

SPOOL create_tolkien.txt

DROP SEQUENCE tolkien_s;
DROP TABLE tolkien;

CREATE TABLE tolkien
( tolkien_id NUMBER
, tolkien_character base_t);

CREATE SEQUENCE tolkien_s START WITH 1001;

DESC tolkien

SPOOL OFF

QUIT;
