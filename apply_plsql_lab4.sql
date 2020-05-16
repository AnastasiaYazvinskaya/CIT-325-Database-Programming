/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab4.txt

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

CREATE OR REPLACE
    TYPE gifts IS OBJECT
    ( day_name VARCHAR(8)
    , num_name VARCHAR(6)
    , gift_name VARCHAR(24));
/

DECLARE
    TYPE days IS TABLE OF gifts;
    
    lv_days DAYS := days ( gifts('first', 'and a', 'Partridge in a pear tree')
        , gifts('second', 'Two', 'Turtle doves')
        , gifts('third', 'Three', 'French hens')
        , gifts('fourth', 'Four', 'Calling birds')
        , gifts('fifth', 'Five', 'Golden rings')
        , gifts('sixth', 'Six', 'Geese a laying')
        , gifts('seventh', 'Seven', 'Swans a swimming')
        , gifts('eighth', 'Eight', 'Maids a milking')
        , gifts('ninth', 'Nine', 'Ladies dancing')
        , gifts('tenth', 'Ten', 'Lords a leaping')
        , gifts('eleventh', 'Eleven', 'Pipers piping')
        , gifts('twelfth', 'Twelve', 'Drummers drumming'));
    
BEGIN
    FOR i IN 1..lv_days.COUNT LOOP
        dbms_output.put_line('On the '||lv_days(i).day_name||' day of Christmas');
        dbms_output.put_line('my true love sent to me:');
        CASE i
            WHEN 1 THEN
                dbms_output.put_line('-A '||lv_days(i).gift_name);
            ELSE
                FOR j IN REVERSE 1..i LOOP
                    dbms_output.put_line('-'||lv_days(j).num_name||' '||lv_days(j).gift_name);
                END LOOP;
        END CASE;
        dbms_output.put_line(CHR(13));
    END LOOP;
END;
/

-- Close log file.
SPOOL OFF
