DECLARE
    column_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO column_count
    FROM user_tab_columns
    WHERE table_name = 'USERS'
      AND column_name = 'FULL_NAME_EN';

    IF column_count = 0 THEN
        EXECUTE IMMEDIATE '
            ALTER TABLE users
            ADD full_name_en VARCHAR2(200 CHAR)
        ';
    END IF;
END;
/