/*
||  Name:          apply_plsql_lab1.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab1.txt

-- Validate the create_video_store.sql script ran
COL full_name FORMAT A20
COL title     FORMAT A28
COL product   FORMAT A8
SELECT DISTINCT
       CASE
         WHEN c.middle_name IS NOT NULL THEN
           c.last_name || ' ' || SUBSTR(c.middle_name,1,3) || ' ' || c.first_name
         ELSE
           c.last_name || ' ' || c.first_name
         END AS full_name
,        i.item_title AS title
,        SUBSTR(cl.common_lookup_meaning,1,3) AS product
FROM     contact c JOIN rental r
ON       c.contact_id = r.customer_id JOIN rental_item ri
ON       r.rental_id = ri.rental_id JOIN item i
ON       ri.item_id = i.item_id JOIN common_lookup cl
ON       i.item_type = cl.common_lookup_id
WHERE    i.item_title IN ('Camelot'
                         ,'Cars'
                         ,'Hook'
                         ,'RoboCop'
                         ,'Star Wars I'
                         ,'Star Wars II'
                         ,'Star Wars III'
                         ,'The Hunt for Red October')
AND      c.last_name IN ('Sweeney','Vizquel','Winn')
ORDER BY 1;

-- Tables created by the create_oracle_store.sql script
SELECT   table_name
FROM     user_tables
WHERE    table_name NOT IN ('EMP','DEPT','ACCOUNT_LIST','CALENDAR','AIRPORT','TRANSACTION','PRICE')
AND NOT  table_name LIKE 'DEMO%'
AND NOT  table_name LIKE 'APEX%'
ORDER BY table_name;

-- Close log file.
SPOOL OFF
