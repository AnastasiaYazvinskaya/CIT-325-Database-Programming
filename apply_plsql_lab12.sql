/*
||  Name:          apply_plsql_lab12.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 13 lab.
*/

-- Call seeding libraries.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
SET PAGESIZE 999

DROP FUNCTION item_list;
DROP TYPE item_tab;
DROP TYPE item_obj;

-- Open log file.
SPOOL apply_plsql_lab12.txt

-- 1
-- Create the item_obj object type
CREATE OR REPLACE TYPE item_obj IS OBJECT
( title VARCHAR2(60)
, subtitle VARCHAR2(60)
, rating VARCHAR2(8)
, release_date DATE );
/

DESC item_obj

-- Create the item_tab object type
CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/

DESC item_tab

-- Create a item_list function
CREATE OR REPLACE FUNCTION item_list
( pv_start_date DATE
, pv_end_date DATE DEFAULT TRUNC(SYSDATE + 1) ) RETURN item_tab IS

    TYPE item_rec IS RECORD
    ( title VARCHAR2(60)
    , subtitle VARCHAR2(60)
    , rating VARCHAR2(8)
    , release_date DATE );
    
    item_cur SYS_REFCURSOR;
    item_row ITEM_REC;
    item_set ITEM_TAB := item_tab();
    
BEGIN
        
    OPEN item_cur FOR 
        SELECT item_title, item_subtitle, item_rating, item_release_date
        FROM item
        WHERE item_rating_agency = 'MPAA'
        AND item_release_date BETWEEN pv_start_date AND pv_end_date;
        
    LOOP
        FETCH item_cur INTO item_row;
        EXIT WHEN item_cur%NOTFOUND;
        
        item_set.EXTEND;
        item_set(item_set.COUNT) := item_obj
            ( title => item_row.title
            , subtitle => item_row.subtitle
            , rating => item_row.rating
            , release_date => item_row.release_date);
    END LOOP;
    
    RETURN item_set;
END item_list;
/

DESC item_list;

-- Test Case
COL title   FORMAT A60 HEADING "TITLE"
COL rating  FORMAT A12 HEADING "RATING"
SELECT   il.title
,        il.rating
FROM     TABLE(item_list(pv_start_date => '01-JAN-2000')) il;
/

-- Close log file.
SPOOL OFF
