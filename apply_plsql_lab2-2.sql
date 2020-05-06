/*
||  Name:          apply_plsql_lab2-2.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab2-2.txt

-- Add an environment command to allow PL/SQL to print to console.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- Put your code here, like this "Hello Whom!" program.
DECLARE
    lv_name VARCHAR2(30);
BEGIN
    lv_name := '&input';
    IF NVL(lv_name IS NULL,FALSE) THEN
        dbms_output.put_line('Hello World!');
    ELSIF NVL((LENGTH(lv_name) <= 10),FALSE) THEN
        dbms_output.put_line('Hello '||lv_name||'!');
    ELSE 
        dbms_output.put_line('Hello '||SUBSTR(lv_name, 1, 10)||'!');
    END IF;
END;
/

-- Close log file.
SPOOL OFF
