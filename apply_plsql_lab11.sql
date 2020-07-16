/*
||  Name:          apply_plsql_lab11.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

DROP PROCEDURE item_insert;
DROP PACKAGE manage_item;
DROP SEQUENCE logger_s;
DROP TABLE logger;

DROP TRIGGER item_trig;

-- Open log file.
SPOOL apply_plsql_lab11.txt

-- 0
-- Add a text_file_name column to the item teble
ALTER TABLE item
ADD (text_file_name VARCHAR2(40));

COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

DESC item

-- 1
-- Create the logger table and logger_s sequence
CREATE TABLE logger
(logger_id NUMBER
, old_item_id NUMBER
, old_item_barcode VARCHAR2(20)
, old_item_type NUMBER
, old_item_title VARCHAR2(60)
, old_item_subtitle VARCHAR2(60)
, old_item_rating VARCHAR2(8)
, old_item_rating_agency VARCHAR2(4)
, old_item_release_date DATE
, old_created_by NUMBER
, old_creation_date DATE
, old_last_updated_by NUMBER
, old_last_update_date DATE
, old_text_file_name VARCHAR2(40)
, new_item_id NUMBER
, new_item_barcode VARCHAR2(20)
, new_item_type NUMBER
, new_item_title VARCHAR2(60)
, new_item_subtitle VARCHAR2(60)
, new_item_rating VARCHAR2(8)
, new_item_rating_agency VARCHAR2(4)
, new_item_release_date DATE
, new_created_by NUMBER
, new_creation_date DATE
, new_last_updated_by NUMBER
, new_last_update_date DATE
, new_text_file_name VARCHAR2(40) );

CREATE SEQUENCE logger_s;

DESC logger

-- Insert a row into the logger table
DECLARE
    CURSOR get_row IS
        SELECT *
        FROM item 
        WHERE item_title = 'Brave Heart';
BEGIN
    FOR i IN get_row LOOP
        INSERT INTO logger
        ( logger_id
        , old_item_id
        , old_item_barcode
        , old_item_type
        , old_item_title
        , old_item_subtitle
        , old_item_rating
        , old_item_rating_agency
        , old_item_release_date
        , old_created_by
        , old_creation_date
        , old_last_updated_by
        , old_last_update_date
        , old_text_file_name
        , new_item_id
        , new_item_barcode
        , new_item_type
        , new_item_title
        , new_item_subtitle
        , new_item_rating
        , new_item_rating_agency
        , new_item_release_date
        , new_created_by
        , new_creation_date
        , new_last_updated_by
        , new_last_update_date
        , new_text_file_name )
        VALUES
        ( logger_s.NEXTVAL
        , i.item_id
        , i.item_barcode
        , i.item_type
        , i.item_title
        , i.item_subtitle
        , i.item_rating
        , i.item_rating_agency
        , i.item_release_date
        , i.created_by
        , i.creation_date
        , i.last_updated_by
        , i.last_update_date
        , i.text_file_name
        , i.item_id
        , i.item_barcode
        , i.item_type
        , i.item_title
        , i.item_subtitle
        , i.item_rating
        , i.item_rating_agency
        , i.item_release_date
        , i.created_by
        , i.creation_date
        , i.last_updated_by
        , i.last_update_date
        , i.text_file_name );
    END LOOP;
END;
/

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- 2
-- Create overloaded item_insert autonomous procedures inside a manage_item package
CREATE OR REPLACE PACKAGE manage_item IS
    PROCEDURE item_insert
    ( pv_new_item_id NUMBER
    , pv_new_item_barcode VARCHAR2
    , pv_new_item_type NUMBER
    , pv_new_item_title VARCHAR2
    , pv_new_item_subtitle VARCHAR2
    , pv_new_item_rating VARCHAR2
    , pv_new_item_rating_agency VARCHAR2
    , pv_new_item_release_date DATE
    , pv_new_created_by NUMBER
    , pv_new_creation_date DATE
    , pv_new_last_updated_by NUMBER
    , pv_new_last_update_date DATE
    , pv_new_text_file_name VARCHAR2 );
    
    PROCEDURE item_insert
    ( pv_new_item_id NUMBER
    , pv_new_item_barcode VARCHAR2
    , pv_new_item_type NUMBER
    , pv_new_item_title VARCHAR2
    , pv_new_item_subtitle VARCHAR2
    , pv_new_item_rating VARCHAR2
    , pv_new_item_rating_agency VARCHAR2
    , pv_new_item_release_date DATE
    , pv_new_created_by NUMBER
    , pv_new_creation_date DATE
    , pv_new_last_updated_by NUMBER
    , pv_new_last_update_date DATE
    , pv_new_text_file_name VARCHAR2
    , pv_old_item_id NUMBER
    , pv_old_item_barcode VARCHAR2
    , pv_old_item_type NUMBER
    , pv_old_item_title VARCHAR2
    , pv_old_item_subtitle VARCHAR2
    , pv_old_item_rating VARCHAR2
    , pv_old_item_rating_agency VARCHAR2
    , pv_old_item_release_date DATE
    , pv_old_created_by NUMBER
    , pv_old_creation_date DATE
    , pv_old_last_updated_by NUMBER
    , pv_old_last_update_date DATE
    , pv_old_text_file_name VARCHAR2 );
    
    PROCEDURE item_insert
    ( pv_old_item_id NUMBER
    , pv_old_item_barcode VARCHAR2
    , pv_old_item_type NUMBER
    , pv_old_item_title VARCHAR2
    , pv_old_item_subtitle VARCHAR2
    , pv_old_item_rating VARCHAR2
    , pv_old_item_rating_agency VARCHAR2
    , pv_old_item_release_date DATE
    , pv_old_created_by NUMBER
    , pv_old_creation_date DATE
    , pv_old_last_updated_by NUMBER
    , pv_old_last_update_date DATE
    , pv_old_text_file_name VARCHAR2 );
END manage_item;
/

DESC manage_item

-- Implement a manage_item package body
CREATE OR REPLACE PACKAGE BODY manage_item IS
    PROCEDURE item_insert
    ( pv_new_item_id NUMBER
    , pv_new_item_barcode VARCHAR2
    , pv_new_item_type NUMBER
    , pv_new_item_title VARCHAR2
    , pv_new_item_subtitle VARCHAR2
    , pv_new_item_rating VARCHAR2
    , pv_new_item_rating_agency VARCHAR2
    , pv_new_item_release_date DATE
    , pv_new_created_by NUMBER
    , pv_new_creation_date DATE
    , pv_new_last_updated_by NUMBER
    , pv_new_last_update_date DATE
    , pv_new_text_file_name VARCHAR2 ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        manage_item.item_insert
        ( pv_new_item_id => pv_new_item_id
        , pv_new_item_barcode => pv_new_item_barcode
        , pv_new_item_type => pv_new_item_type
        , pv_new_item_title => pv_new_item_title
        , pv_new_item_subtitle => pv_new_item_subtitle
        , pv_new_item_rating => pv_new_item_rating
        , pv_new_item_rating_agency => pv_new_item_rating_agency
        , pv_new_item_release_date => pv_new_item_release_date
        , pv_new_created_by => pv_new_created_by
        , pv_new_creation_date => pv_new_creation_date
        , pv_new_last_updated_by => pv_new_last_updated_by
        , pv_new_last_update_date => pv_new_last_update_date
        , pv_new_text_file_name => pv_new_text_file_name
        , pv_old_item_id => NULL
        , pv_old_item_barcode => NULL
        , pv_old_item_type => NULL
        , pv_old_item_title => NULL
        , pv_old_item_subtitle => NULL
        , pv_old_item_rating => NULL
        , pv_old_item_rating_agency => NULL
        , pv_old_item_release_date => NULL
        , pv_old_created_by => NULL
        , pv_old_creation_date => NULL
        , pv_old_last_updated_by => NULL
        , pv_old_last_update_date => NULL
        , pv_old_text_file_name => NULL );
    EXCEPTION
        WHEN OTHERS THEN
            RETURN;
    END item_insert;
    
    PROCEDURE item_insert
    ( pv_new_item_id NUMBER
    , pv_new_item_barcode VARCHAR2
    , pv_new_item_type NUMBER
    , pv_new_item_title VARCHAR2
    , pv_new_item_subtitle VARCHAR2
    , pv_new_item_rating VARCHAR2
    , pv_new_item_rating_agency VARCHAR2
    , pv_new_item_release_date DATE
    , pv_new_created_by NUMBER
    , pv_new_creation_date DATE
    , pv_new_last_updated_by NUMBER
    , pv_new_last_update_date DATE
    , pv_new_text_file_name VARCHAR2
    , pv_old_item_id NUMBER
    , pv_old_item_barcode VARCHAR2
    , pv_old_item_type NUMBER
    , pv_old_item_title VARCHAR2
    , pv_old_item_subtitle VARCHAR2
    , pv_old_item_rating VARCHAR2
    , pv_old_item_rating_agency VARCHAR2
    , pv_old_item_release_date DATE
    , pv_old_created_by NUMBER
    , pv_old_creation_date DATE
    , pv_old_last_updated_by NUMBER
    , pv_old_last_update_date DATE
    , pv_old_text_file_name VARCHAR2 ) IS
        lv_logger_id NUMBER;
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        lv_logger_id := logger_s.NEXTVAL;
        SAVEPOINT startpoint;
        
        INSERT INTO logger
        ( logger_id
        , old_item_id
        , old_item_barcode
        , old_item_type
        , old_item_title
        , old_item_subtitle
        , old_item_rating
        , old_item_rating_agency
        , old_item_release_date
        , old_created_by
        , old_creation_date
        , old_last_updated_by
        , old_last_update_date
        , old_text_file_name
        , new_item_id
        , new_item_barcode
        , new_item_type
        , new_item_title
        , new_item_subtitle
        , new_item_rating
        , new_item_rating_agency
        , new_item_release_date
        , new_created_by
        , new_creation_date
        , new_last_updated_by
        , new_last_update_date
        , new_text_file_name )
        VALUES
        ( lv_logger_id
        , pv_old_item_id
        , pv_old_item_barcode
        , pv_old_item_type
        , pv_old_item_title
        , pv_old_item_subtitle
        , pv_old_item_rating
        , pv_old_item_rating_agency
        , pv_old_item_release_date
        , pv_old_created_by
        , pv_old_creation_date
        , pv_old_last_updated_by
        , pv_old_last_update_date
        , pv_old_text_file_name
        , pv_new_item_id
        , pv_new_item_barcode
        , pv_new_item_type
        , pv_new_item_title
        , pv_new_item_subtitle
        , pv_new_item_rating
        , pv_new_item_rating_agency
        , pv_new_item_release_date
        , pv_new_created_by
        , pv_new_creation_date
        , pv_new_last_updated_by
        , pv_new_last_update_date
        , pv_new_text_file_name );
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO startpoint;
            RETURN;
    END item_insert;
    
    PROCEDURE item_insert
    ( pv_old_item_id NUMBER
    , pv_old_item_barcode VARCHAR2
    , pv_old_item_type NUMBER
    , pv_old_item_title VARCHAR2
    , pv_old_item_subtitle VARCHAR2
    , pv_old_item_rating VARCHAR2
    , pv_old_item_rating_agency VARCHAR2
    , pv_old_item_release_date DATE
    , pv_old_created_by NUMBER
    , pv_old_creation_date DATE
    , pv_old_last_updated_by NUMBER
    , pv_old_last_update_date DATE
    , pv_old_text_file_name VARCHAR2 ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN        
        manage_item.item_insert
        ( pv_new_item_id => NULL
        , pv_new_item_barcode => NULL
        , pv_new_item_type => NULL
        , pv_new_item_title => NULL
        , pv_new_item_subtitle => NULL
        , pv_new_item_rating => NULL
        , pv_new_item_rating_agency => NULL
        , pv_new_item_release_date => NULL
        , pv_new_created_by => NULL
        , pv_new_creation_date => NULL
        , pv_new_last_updated_by => NULL
        , pv_new_last_update_date => NULL
        , pv_new_text_file_name => NULL
        , pv_old_item_id => pv_old_item_id
        , pv_old_item_barcode => pv_old_item_barcode
        , pv_old_item_type => pv_old_item_type
        , pv_old_item_title => pv_old_item_title
        , pv_old_item_subtitle => pv_old_item_subtitle
        , pv_old_item_rating => pv_old_item_rating
        , pv_old_item_rating_agency => pv_old_item_rating_agency
        , pv_old_item_release_date => pv_old_item_release_date
        , pv_old_created_by => pv_old_created_by
        , pv_old_creation_date => pv_old_creation_date
        , pv_old_last_updated_by => pv_old_last_updated_by
        , pv_old_last_update_date => pv_old_last_update_date
        , pv_old_text_file_name => pv_old_text_file_name );
    EXCEPTION
        WHEN OTHERS THEN
            RETURN;
    END item_insert;
END manage_item;
/

-- Insert a row into the logger table
DECLARE
    CURSOR get_row IS
        SELECT *
        FROM item 
        WHERE item_title = 'King Arthur';
BEGIN
    FOR i IN get_row LOOP
        -- Insert
        manage_item.item_insert
        ( pv_new_item_id => i.item_id
        , pv_new_item_barcode => i.item_barcode
        , pv_new_item_type => i.item_type
        , pv_new_item_title => i.item_title || '-Inserted'
        , pv_new_item_subtitle => i.item_subtitle
        , pv_new_item_rating => i.item_rating
        , pv_new_item_rating_agency => i.item_rating_agency
        , pv_new_item_release_date => i.item_release_date
        , pv_new_created_by => i.created_by
        , pv_new_creation_date => i.creation_date
        , pv_new_last_updated_by => i.last_updated_by
        , pv_new_last_update_date => i.last_update_date
        , pv_new_text_file_name => i.text_file_name );
        -- Update
        manage_item.item_insert
        ( pv_new_item_id => i.item_id
        , pv_new_item_barcode => i.item_barcode
        , pv_new_item_type => i.item_type
        , pv_new_item_title => i.item_title || '-Changed'
        , pv_new_item_subtitle => i.item_subtitle
        , pv_new_item_rating => i.item_rating
        , pv_new_item_rating_agency => i.item_rating_agency
        , pv_new_item_release_date => i.item_release_date
        , pv_new_created_by => i.created_by
        , pv_new_creation_date => i.creation_date
        , pv_new_last_updated_by => i.last_updated_by
        , pv_new_last_update_date => i.last_update_date
        , pv_new_text_file_name => i.text_file_name
        , pv_old_item_id => i.item_id
        , pv_old_item_barcode => i.item_barcode
        , pv_old_item_type => i.item_type
        , pv_old_item_title => i.item_title
        , pv_old_item_subtitle => i.item_subtitle
        , pv_old_item_rating => i.item_rating
        , pv_old_item_rating_agency => i.item_rating_agency
        , pv_old_item_release_date => i.item_release_date
        , pv_old_created_by => i.created_by
        , pv_old_creation_date => i.creation_date
        , pv_old_last_updated_by => i.last_updated_by
        , pv_old_last_update_date => i.last_update_date
        , pv_old_text_file_name => i.text_file_name );
        -- Delete
        manage_item.item_insert
        ( pv_old_item_id => i.item_id
        , pv_old_item_barcode => i.item_barcode
        , pv_old_item_type => i.item_type
        , pv_old_item_title => i.item_title || '-Deleted'
        , pv_old_item_subtitle => i.item_subtitle
        , pv_old_item_rating => i.item_rating
        , pv_old_item_rating_agency => i.item_rating_agency
        , pv_old_item_release_date => i.item_release_date
        , pv_old_created_by => i.created_by
        , pv_old_creation_date => i.creation_date
        , pv_old_last_updated_by => i.last_updated_by
        , pv_old_last_update_date => i.last_update_date
        , pv_old_text_file_name => i.text_file_name );
    END LOOP;
END;
/

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- 3
-- Create an item_trig trigger for Insert and Update
CREATE OR REPLACE TRIGGER item_trig
    BEFORE INSERT OR UPDATE ON item
    FOR EACH ROW
DECLARE
    lv_title VARCHAR2(60);
    lv_subtitle VARCHAR2(60);

    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e, -20001);
BEGIN
    IF INSERTING THEN
        lv_title := :NEW.item_title;
        lv_subtitle := :NEW.item_subtitle;
        IF REGEXP_INSTR(:NEW.item_title,':') > 0 
        AND REGEXP_INSTR(:NEW.item_title,':') = LENGTH(:NEW.item_title) THEN
            :NEW.item_title   := SUBSTR(:NEW.item_title, 1, REGEXP_INSTR(:NEW.item_title,':') - 1);
        ELSIF REGEXP_INSTR(:NEW.item_title,':') > 0 THEN
            :NEW.item_subtitle := LTRIM(SUBSTR(:NEW.item_title,REGEXP_INSTR(:NEW.item_title,':') + 1, LENGTH(:NEW.item_title)));
            :NEW.item_title    := SUBSTR(:NEW.item_title, 1, REGEXP_INSTR(:NEW.item_title,':') - 1);
        ELSE
            :NEW.item_title := :NEW.item_title;
        END IF;           
        manage_item.item_insert
        ( pv_new_item_id => :NEW.item_id
        , pv_new_item_barcode => :NEW.item_barcode
        , pv_new_item_type => :NEW.item_type
        , pv_new_item_title => lv_title --|| '-Inserted'
        , pv_new_item_subtitle => lv_subtitle
        , pv_new_item_rating => :NEW.item_rating
        , pv_new_item_rating_agency => :NEW.item_rating_agency
        , pv_new_item_release_date => :NEW.item_release_date
        , pv_new_created_by => :NEW.created_by
        , pv_new_creation_date => :NEW.creation_date
        , pv_new_last_updated_by => :NEW.last_updated_by
        , pv_new_last_update_date => :NEW.last_update_date
        , pv_new_text_file_name => :NEW.text_file_name );
        IF :NEW.item_id IS NULL THEN
            SELECT item_s1.NEXTVAL
            INTO :NEW.item_id
            FROM item;
        END IF;
    ELSIF UPDATING THEN
        manage_item.item_insert
        ( pv_new_item_id => :NEW.item_id
        , pv_new_item_barcode => :NEW.item_barcode
        , pv_new_item_type => :NEW.item_type
        , pv_new_item_title => :NEW.item_title --|| '-Changed'
        , pv_new_item_subtitle => :NEW.item_subtitle
        , pv_new_item_rating => :NEW.item_rating
        , pv_new_item_rating_agency => :NEW.item_rating_agency
        , pv_new_item_release_date => :NEW.item_release_date
        , pv_new_created_by => :NEW.created_by
        , pv_new_creation_date => :NEW.creation_date
        , pv_new_last_updated_by => :NEW.last_updated_by
        , pv_new_last_update_date => :NEW.last_update_date
        , pv_new_text_file_name => :NEW.text_file_name
        , pv_old_item_id => :old.item_id
        , pv_old_item_barcode => :old.item_barcode
        , pv_old_item_type => :old.item_type
        , pv_old_item_title => :old.item_title
        , pv_old_item_subtitle => :old.item_subtitle
        , pv_old_item_rating => :old.item_rating
        , pv_old_item_rating_agency => :old.item_rating_agency
        , pv_old_item_release_date => :old.item_release_date
        , pv_old_created_by => :old.created_by
        , pv_old_creation_date => :old.creation_date
        , pv_old_last_updated_by => :old.last_updated_by
        , pv_old_last_update_date => :old.last_update_date
        , pv_old_text_file_name => :old.text_file_name );
        IF REGEXP_INSTR(:NEW.item_title,':') > 0 THEN
            RAISE e;
        END IF;
    END IF;
EXCEPTION
    WHEN e THEN
        RAISE_APPLICATION_ERROR(-20001, 'No colons allowed in item titles.');
        dbms_output.put_line(SQLERRM);
END item_trig;
/

-- Create an item_delete_trig trigger for Delete
CREATE OR REPLACE TRIGGER item_delete_trig
    BEFORE DELETE ON item
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        manage_item.item_insert
        ( pv_old_item_id => :old.item_id
        , pv_old_item_barcode => :old.item_barcode
        , pv_old_item_type => :old.item_type
        , pv_old_item_title => :old.item_title --|| '-Deleted'
        , pv_old_item_subtitle => :old.item_subtitle
        , pv_old_item_rating => :old.item_rating
        , pv_old_item_rating_agency => :old.item_rating_agency
        , pv_old_item_release_date => :old.item_release_date
        , pv_old_created_by => :old.created_by
        , pv_old_creation_date => :old.creation_date
        , pv_old_last_updated_by => :old.last_updated_by
        , pv_old_last_update_date => :old.last_update_date
        , pv_old_text_file_name => :old.text_file_name );
    END IF;
END item_delete_trig;
/

ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item
ADD CONSTRAINT fk_item_1 FOREIGN KEY (item_type)
    REFERENCES common_lookup(common_lookup_id) ON DELETE CASCADE;

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

DELETE FROM common_lookup
WHERE common_lookup_table = 'ITEM'
AND common_lookup_column = 'ITEM_TYPE'
AND common_lookup_type = 'BLU-RAY';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item
ADD CONSTRAINT fk_item_1 FOREIGN KEY (item_type)
    REFERENCES common_lookup(common_lookup_id);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_code
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( common_lookup_s1.NEXTVAL
, 'ITEM'
, 'ITEM_TYPE'
, 'BLU-RAY'
, ''
, 'Blu-ray'
, 3
, SYSDATE
, 3
, SYSDATE );

COL common_lookup_table   FORMAT A14 HEADING "Common Lookup|Table"
COL common_lookup_column  FORMAT A14 HEADING "Common Lookup|Column"
COL common_lookup_type    FORMAT A14 HEADING "Common Lookup|Type"
SELECT common_lookup_table
,      common_lookup_column
,      common_lookup_type
FROM   common_lookup
WHERE  common_lookup_table = 'ITEM'
AND    common_lookup_column = 'ITEM_TYPE'
AND    common_lookup_type = 'BLU-RAY';

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B01IHVPA8'
, ( SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_table = 'ITEM'
    AND common_lookup_column = 'ITEM_TYPE'
    AND common_lookup_type = 'BLU-RAY' )
, 'Bourne'
, ''
, 'x'
, ''
, 'PG-13'
, 'MPAA'
, '06-DEC-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, '' );

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B01AT251XY'
, ( SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_table = 'ITEM'
    AND common_lookup_column = 'ITEM_TYPE'
    AND common_lookup_type = 'BLU-RAY' )
, 'Bourne Legacy:'
, ''
, 'x'
, ''
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, '' );

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B018FK66TU'
, ( SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_table = 'ITEM'
    AND common_lookup_column = 'ITEM_TYPE'
    AND common_lookup_type = 'BLU-RAY' )
, 'Star Wars: The Force Awakens'
, ''
, 'x'
, ''
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, '' );

-- SELECT * FROM item
-- WHERE item_title = 'Star Wars';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

UPDATE item
SET item_title = 'Star Wars: The Force Awakens'
WHERE item_title = 'Star Wars';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

DELETE
FROM item
WHERE item_title = 'Star Wars';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Close log file.
SPOOL OFF
