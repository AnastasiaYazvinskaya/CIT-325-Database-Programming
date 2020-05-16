/*
||  Name:          apply_plsql_lab3.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 4 lab.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
-- SPOOL apply_plsql_lab3.txt

-- Enter your solution here.

SET SERVEROUTPUT ON
SET VERIFY OFF;

CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  lv_date  DATE;
BEGIN
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') THEN
    CASE
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN 
        lv_date := pv_date_in;
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN 
        lv_date := pv_date_in;
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        IF MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0 AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := pv_date_in;
        ELSE
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := pv_date_in;
          ELSE
            lv_date := null;
          END IF;
        END IF;
      ELSE
        lv_date := null;
    END CASE;
  ELSE
    lv_date := null;
  END IF;
  RETURN lv_date;
END;
/

DECLARE
  TYPE list IS TABLE OF VARCHAR2(12);
  lv_strings  LIST := list();
  counter NUMBER:= 1;
  
  TYPE outlist IS TABLE OF VARCHAR2(12);
  lv_outstrings OUTLIST := outlist();

BEGIN
  lv_strings.EXTEND(3);
  lv_outstrings.EXTEND(3);
  FOR i IN 1..lv_strings.COUNT LOOP
    IF i = 1 THEN
      lv_strings(counter) := NVL('&1','');
    ELSIF i = 2 THEN
      lv_strings(counter) := NVL('&2','');
    ELSIF i = 3 THEN
      lv_strings(counter) := NVL('&3','');
    END IF;
    counter := counter + 1;
  END LOOP;
  
  FOR i IN 1..lv_strings.COUNT LOOP
    IF REGEXP_LIKE(lv_strings(i),'^[[:digit:]]*$') THEN
       lv_outstrings(1) := lv_strings(i);
    ELSIF REGEXP_LIKE(lv_strings(i),'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$')
        AND verify_date(lv_strings(i)) IS NOT NULL THEN
            lv_outstrings(3) := lv_strings(i);
    ELSIF REGEXP_LIKE(lv_strings(i),'^[[:alnum:]]*$')
        AND NOT REGEXP_LIKE(lv_strings(i),'^[[:digit:]]*$') THEN
            lv_outstrings(2) := lv_strings(i);
    END IF;
  END LOOP;
  
  dbms_output.put_line('Record ['||lv_outstrings(1)||'] ['||lv_outstrings(2)||'] ['||lv_outstrings(3)||']');

END;
/

-- Close log file.
-- SPOOL OFF
