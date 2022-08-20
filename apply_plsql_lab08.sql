/*
||  Name:          apply_plsql_lab8.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 9 lab.
*/

-- @/home/student/Data/cit325/lab7/apply_plsql_lab7.sql
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL apply_plsql_lab8.txt

-- 0
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

-- 1
--DROP PACKAGE contact_package;

CREATE OR REPLACE PACKAGE contact_package IS
    PROCEDURE contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2);
    PROCEDURE contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_id NUMBER);
END contact_package;
/

DESC contact_package

-- 2
CREATE OR REPLACE PACKAGE BODY contact_package IS
    PROCEDURE contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2) IS
        
        lv_user_id NUMBER;
        
        lv_address_type VARCHAR2(50);
        lv_contact_type VARCHAR2(50);
        lv_credit_card_type VARCHAR2(50);
        lv_member_type VARCHAR2(50);
        lv_telephone_type VARCHAR2(50);
        
        CURSOR get_user_id (cv_user_name VARCHAR2) IS
        SELECT system_user_id
        FROM system_user
        WHERE system_user_name = NVL(cv_user_name, 'ANONYMOUS');
        
        lv_member_id NUMBER;
        
        CURSOR get_member IS
        SELECT member_id
        FROM member
        WHERE account_number = pv_account_number;
        
        lv_contact_id NUMBER;
        
        CURSOR get_contact IS
        SELECT contact_id
        FROM contact
        WHERE first_name = pv_first_name
        AND middle_name IS NULL
        AND last_name = pv_last_name;
        
    BEGIN
        
        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;
    
        FOR i IN get_user_id (pv_user_name) LOOP
            lv_user_id := i.system_user_id;
        END LOOP;
        
        SAVEPOINT starting_point;
        
        OPEN get_member;
        FETCH get_member INTO lv_member_id;
            
        IF get_member%NOTFOUND THEN
            
            INSERT INTO member
            ( member_id
            , member_type
            , account_number
            , credit_card_number
            , credit_card_type
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( member_s1.NEXTVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'MEMBER_TYPE'
                AND common_lookup_type = lv_member_type)
            , pv_account_number
            , pv_credit_card_number
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'CREDIT_CARD_TYPE'
                AND common_lookup_type = lv_credit_card_type)
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
        END IF;
            
        OPEN get_contact;
        FETCH get_contact INTO lv_contact_id;
            
        IF get_contact%NOTFOUND THEN
                
            INSERT INTO contact
            ( contact_id
            , member_id
            , contact_type
            , last_name
            , first_name
            , middle_name
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( contact_s1.NEXTVAL
            , member_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
            , pv_last_name
            , pv_first_name
            , pv_middle_name
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO address
            VALUES
            ( address_s1.NEXTVAL
            , contact_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
            , pv_city
            , pv_state_province
            , pv_postal_code
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO telephone
            VALUES
            ( telephone_s1.NEXTVAL
            , contact_s1.CURRVAL
            , address_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'TELEPHONE'
                AND common_lookup_column = 'TELEPHONE_TYPE'
                AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
        
        END IF;
        
        CLOSE get_member;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;
    END;
    
    PROCEDURE contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_id NUMBER) IS
    
        lv_user_id NUMBER;
        
        lv_address_type VARCHAR2(50);
        lv_contact_type VARCHAR2(50);
        lv_credit_card_type VARCHAR2(50);
        lv_member_type VARCHAR2(50);
        lv_telephone_type VARCHAR2(50);
        
        lv_member_id NUMBER;
        
        CURSOR get_member IS
        SELECT member_id
        FROM member
        WHERE account_number = pv_account_number;
        
        lv_contact_id NUMBER;
        
        CURSOR get_contact IS
        SELECT contact_id
        FROM contact
        WHERE first_name = pv_first_name
        AND middle_name IS NULL
        AND last_name = pv_last_name;
        
    BEGIN
        
        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;
    
        lv_user_id := pv_user_id;
        
        SAVEPOINT starting_point;
        
        OPEN get_member;
        FETCH get_member INTO lv_member_id;
            
        IF get_member%NOTFOUND THEN
            
            INSERT INTO member
            ( member_id
            , member_type
            , account_number
            , credit_card_number
            , credit_card_type
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( member_s1.NEXTVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'MEMBER_TYPE'
                AND common_lookup_type = lv_member_type)
            , pv_account_number
            , pv_credit_card_number
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'CREDIT_CARD_TYPE'
                AND common_lookup_type = lv_credit_card_type)
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
        END IF;
            
        OPEN get_contact;
        FETCH get_contact INTO lv_contact_id;
            
        IF get_contact%NOTFOUND THEN
                
            INSERT INTO contact
            ( contact_id
            , member_id
            , contact_type
            , last_name
            , first_name
            , middle_name
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( contact_s1.NEXTVAL
            , member_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
            , pv_last_name
            , pv_first_name
            , pv_middle_name
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO address
            VALUES
            ( address_s1.NEXTVAL
            , contact_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
            , pv_city
            , pv_state_province
            , pv_postal_code
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO telephone
            VALUES
            ( telephone_s1.NEXTVAL
            , contact_s1.CURRVAL
            , address_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'TELEPHONE'
                AND common_lookup_column = 'TELEPHONE_TYPE'
                AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
        
        END IF;
        
        CLOSE get_member;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;
    
    END;
END contact_package;
/

LIST
SHOW ERRORS

SET SERVEROUTPUT ON SIZE UNLIMITED

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 6
, 'BONDSB'
, 1
, 1
, 'Barry'
, 'L'
, 'Bonds'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 7
, 'CURRYW'
, 1
, 1
, 'Wardell'
, 'S'
, 'Curry'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( -1
, 'ANONYMOUS'
, 1
, 1
, ''
, ''
, ''
, 1
, SYSDATE
, 1
, SYSDATE);


COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

BEGIN
    contact_package.contact_insert
    ( pv_first_name => 'Charlie'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3'
--   , pv_user_id => ''
    );
END;
/

BEGIN
    contact_package.contact_insert
    ( pv_first_name => 'Peppermint'
    , pv_middle_name => NULL
    , pv_last_name => 'Patty'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => ''
--    , pv_user_id => ''
    );
END;
/

BEGIN
    contact_package.contact_insert
    ( pv_first_name => 'Sally'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
--    , pv_user_name => ''
    , pv_user_id => 6
    );
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name IN ('Brown','Patty');

-- 3
DROP PROCEDURE contact_insert;

CREATE OR REPLACE PACKAGE contact_package IS
    FUNCTION contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2) RETURN NUMBER;
    FUNCTION contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_id NUMBER) RETURN NUMBER;
END contact_package;
/

CREATE OR REPLACE PACKAGE BODY contact_package IS
    FUNCTION contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2) RETURN NUMBER IS
        
        lv_user_id NUMBER;
        
        lv_address_type VARCHAR2(50);
        lv_contact_type VARCHAR2(50);
        lv_credit_card_type VARCHAR2(50);
        lv_member_type VARCHAR2(50);
        lv_telephone_type VARCHAR2(50);
        
        CURSOR get_user_id IS
        SELECT system_user_id
        FROM system_user
        WHERE system_user_name = pv_user_name;
        
        lv_member_id NUMBER;
        
        CURSOR get_member IS
        SELECT member_id
        FROM member
        WHERE account_number = pv_account_number;
        
    BEGIN
        
        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;
    
        FOR i IN get_user_id LOOP
            lv_user_id := NVL(i.system_user_id, -1);
        END LOOP;
        
        SAVEPOINT starting_point;
        
        OPEN get_member;
--        LOOP
            FETCH get_member INTO lv_member_id;
            
--            IF get_member%NOTFOUND THEN
            
            INSERT INTO member
            ( member_id
            , member_type
            , account_number
            , credit_card_number
            , credit_card_type
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( member_s1.NEXTVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'MEMBER_TYPE'
                AND common_lookup_type = lv_member_type)
            , pv_account_number
            , pv_credit_card_number
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'CREDIT_CARD_TYPE'
                AND common_lookup_type = lv_credit_card_type)
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
                
            INSERT INTO contact
            ( contact_id
            , member_id
            , contact_type
            , last_name
            , first_name
            , middle_name
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( contact_s1.NEXTVAL
            , member_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
            , pv_last_name
            , pv_first_name
            , pv_middle_name
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO address
            VALUES
            ( address_s1.NEXTVAL
            , contact_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
            , pv_city
            , pv_state_province
            , pv_postal_code
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO telephone
            VALUES
            ( telephone_s1.NEXTVAL
            , contact_s1.CURRVAL
            , address_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'TELEPHONE'
                AND common_lookup_column = 'TELEPHONE_TYPE'
                AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
--            END IF;
--            EXIT;
--        END LOOP;
        
        CLOSE get_member;
        
        COMMIT;
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;
    
    END;
    
    FUNCTION contact_insert
    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_state_province VARCHAR2
    , pv_city VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_id NUMBER) RETURN NUMBER IS
    
        lv_user_id NUMBER;
        
        lv_address_type VARCHAR2(50);
        lv_contact_type VARCHAR2(50);
        lv_credit_card_type VARCHAR2(50);
        lv_member_type VARCHAR2(50);
        lv_telephone_type VARCHAR2(50);
        
        lv_member_id NUMBER;
        
        CURSOR get_member IS
        SELECT member_id
        FROM member
        WHERE account_number = pv_account_number;
    
    BEGIN
    
        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;
    
        lv_user_id := NVL(pv_user_id, -1);
        
        SAVEPOINT starting_point;
        
        OPEN get_member;
--        LOOP
        
            FETCH get_member INTO lv_member_id;
            
--            IF get_member%NOTFOUND THEN
            
            INSERT INTO member
            ( member_id
            , member_type
            , account_number
            , credit_card_number
            , credit_card_type
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( member_s1.NEXTVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'MEMBER_TYPE'
                AND common_lookup_type = lv_member_type)
            , pv_account_number
            , pv_credit_card_number
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'MEMBER'
                AND common_lookup_column = 'CREDIT_CARD_TYPE'
                AND common_lookup_type = lv_credit_card_type)
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
                
            INSERT INTO contact
            ( contact_id
            , member_id
            , contact_type
            , last_name
            , first_name
            , middle_name
            , created_by
            , creation_date
            , last_updated_by
            , last_update_date)
            VALUES
            ( contact_s1.NEXTVAL
            , member_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
            , pv_last_name
            , pv_first_name
            , pv_middle_name
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO address
            VALUES
            ( address_s1.NEXTVAL
            , contact_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
            , pv_city
            , pv_state_province
            , pv_postal_code
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
            
            INSERT INTO telephone
            VALUES
            ( telephone_s1.NEXTVAL
            , contact_s1.CURRVAL
            , address_s1.CURRVAL
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'TELEPHONE'
                AND common_lookup_column = 'TELEPHONE_TYPE'
                AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_user_id
            , SYSDATE
            , lv_user_id
            , SYSDATE);
--            END IF;
--            EXIT;
--        END LOOP;
        
        CLOSE get_member;
        
        COMMIT;
        
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;
    
    END;
END contact_package;
/

DECLARE
    lv_call_function NUMBER;
BEGIN
    lv_call_function := contact_package.contact_insert
    ( pv_first_name => 'Shirley'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3'
--    , pv_user_id => ''
    );
    
    lv_call_function := contact_package.contact_insert
    ( pv_first_name => 'Keith'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
--    , pv_user_name => ''
    , pv_user_id => '6'
    );
    
    lv_call_function := contact_package.contact_insert
    ( pv_first_name => 'Laurie'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
--    , pv_user_name => ''
    , pv_user_id => '-1'
    );
END;
/

COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';


-- Close log file.
SPOOL OFF
