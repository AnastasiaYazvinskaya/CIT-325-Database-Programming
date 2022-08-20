/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab5.txt

-- 1
CREATE SEQUENCE rating_agency_s START WITH 1001;

CREATE TABLE rating_agency AS
    SELECT rating_agency_s.NEXTVAL AS rating_agency_id
    ,      il.item_rating AS rating
    ,      il.item_rating_agency AS rating_agency
    FROM  (SELECT DISTINCT
          i.item_rating
        , i.item_rating_agency
        FROM   item i) il;
       
SELECT * FROM rating_agency;

ALTER TABLE rating_agency
    ADD PRIMARY KEY (rating_agency_id);

-- 2
ALTER TABLE item
    ADD (rating_agency_id NUMBER);

UPDATE item i
    SET rating_agency_id = (SELECT ra.rating_agency_id
        FROM rating_agency ra
        WHERE ra.rating = i.item_rating
        AND ra.rating_agency = i.item_rating_agency);
    
ALTER TABLE rating_agency
    MODIFY (rating_agency_id NUMBER CONSTRAINT nn_rating_agency NOT NULL);

SET NULL ''
COLUMN table_name   FORMAT A18
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

-- 3
SET SERVEROUTPUT ON SIZE 1000000

DROP TYPE rating_agency_tab;
DROP TYPE rating_agency_obj;

CREATE OR REPLACE
    TYPE rating_agency_obj IS OBJECT
        ( rating_agency_id NUMBER
        , rating VARCHAR2(8)
        , rating_agency VARCHAR2(4));
/
CREATE OR REPLACE
    TYPE rating_agency_tab IS TABLE OF rating_agency_obj;
/

DECLARE
    lv_rating_agency_tab RATING_AGENCY_TAB := rating_agency_tab();
    CURSOR c IS
        SELECT rating_agency_id AS id
        , rating AS rat
        , rating_agency AS rat_agency
        FROM rating_agency;
    
BEGIN    
    FOR i in c LOOP
        lv_rating_agency_tab.EXTEND;
        lv_rating_agency_tab(lv_rating_agency_tab.COUNT) :=
            rating_agency_obj(i.id
            , i.rat
            , i.rat_agency);
    END LOOP;
    
    FOR i IN 1..lv_rating_agency_tab.COUNT LOOP
        UPDATE item
        SET rating_agency_id = lv_rating_agency_tab(i).rating_agency_id
        WHERE item_rating = lv_rating_agency_tab(i).rating
        AND item_rating_agency = lv_rating_agency_tab(i).rating_agency;
    END LOOP;
END;
/

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

-- Close log file.
SPOOL OFF

