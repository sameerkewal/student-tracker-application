prompt start sta_role_data.sql


MERGE INTO STA_ROLE a
    USING
        (SELECT
             1 AS ID,
             q'[Teacher]' AS NAME,
                 null AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

MERGE INTO STA_ROLE a
    USING
        (SELECT
             11 AS ID,
             q'[Student]' AS NAME,
                 null AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

MERGE INTO STA_ROLE a
    USING
        (SELECT
             13 AS ID,
             q'[Caretaker]' AS NAME,
                 null AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

MERGE INTO STA_ROLE a
    USING
        (SELECT
             14 AS ID,
             q'[Admin]' AS NAME,
                 null AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

MERGE INTO STA_ROLE a
    USING
        (SELECT
             30 AS ID,
             q'[Super Admin]' AS NAME,
                 null AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

commit;
prompt end sta_role_data.sql

