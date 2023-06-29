SET PAGESIZE 999

SPOOL insert_instances.txt

-- Insert men
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, man_t
  ( oid => 1
  , oname => 'Man'
  , name => 'Boromir'
  , genus => 'Men'));

INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, man_t
  ( oid => 2
  , oname => 'Man'
  , name => 'Faramir'
  , genus => 'Men'));

-- Insert hobbits
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, hobbit_t
  ( oid => 3
  , oname => 'Hobbit'
  , name => 'Bilbo'
  , genus => 'Hobbits'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, hobbit_t
  ( oid => 4
  , oname => 'Hobbit'
  , name => 'Frodo'
  , genus => 'Hobbits'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, hobbit_t
  ( oid => 5
  , oname => 'Hobbit'
  , name => 'Merry'
  , genus => 'Hobbits'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, hobbit_t
  ( oid => 6
  , oname => 'Hobbit'
  , name => 'Pippin'
  , genus => 'Hobbits'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, hobbit_t
  ( oid => 7
  , oname => 'Hobbit'
  , name => 'Samwise'
  , genus => 'Hobbits'));

-- Insert dwarves
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, dwarf_t
  ( oid => 8
  , oname => 'Dwarf'
  , name => 'Gimli'
  , genus => 'Dwarves'));
  
-- Insert elves
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, noldor_t
  ( oid => 9
  , oname => 'Elf'
  , name => 'Feanor'
  , genus => 'Elves'
  , elfkind => 'Noldor'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, silvan_t
  ( oid => 10
  , oname => 'Elf'
  , name => 'Tauriel'
  , genus => 'Elves'
  , elfkind => 'Silvan'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, teleri_t
  ( oid => 11
  , oname => 'Elf'
  , name => 'Earwen'
  , genus => 'Elves'
  , elfkind => 'Teleri'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, teleri_t
  ( oid => 12
  , oname => 'Elf'
  , name => 'Celeborn'
  , genus => 'Elves'
  , elfkind => 'Teleri'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, sindar_t
  ( oid => 13
  , oname => 'Elf'
  , name => 'Thraduil'
  , genus => 'Elves'
  , elfkind => 'Sindar'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, sindar_t
  ( oid => 14
  , oname => 'Elf'
  , name => 'Legolas'
  , genus => 'Elves'
  , elfkind => 'Sindar'));

-- Insert orcs
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, orc_t
  ( oid => 15
  , oname => 'Orc'
  , name => 'Azog the Defiler'
  , genus => 'Orcs'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, orc_t
  ( oid => 16
  , oname => 'Orc'
  , name => 'Bolg'
  , genus => 'Orcs'));
  
-- Insert maiar
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, maia_t
  ( oid => 17
  , oname => 'Maia'
  , name => 'Gendalf the Grey'
  , genus => 'Maiar'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, maia_t
  ( oid => 18
  , oname => 'Maia'
  , name => 'Radagast the Brown'
  , genus => 'Maiar'));
  
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, maia_t
  ( oid => 19
  , oname => 'Maia'
  , name => 'Saruman the White'
  , genus => 'Maiar'));
  
-- Insert goblins
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, goblin_t
  ( oid => 20
  , oname => 'Goblin'
  , name => 'The Great Goblin'
  , genus => 'Goblins'));
  
-- Insert men
INSERT INTO tolkien
( tolkien_id
, tolkien_character)
VALUES
( tolkien_s.NEXTVAL
, man_t
  ( oid => 21
  , oname => 'Man'
  , name => 'Aragorn'
  , genus => 'Men'));
  
SPOOL OFF

QUIT;