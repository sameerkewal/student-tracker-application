prompt start sta_course_data.sql

MERGE INTO STA_COURSE a
    USING
        (SELECT
             61 AS ID,
             q'[Biologie]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             64 AS ID,
             q'[Gym]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             32 AS ID,
             q'[Geschiedenis]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             82 AS ID,
             q'[Rekenen]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             83 AS ID,
             q'[Tekenen]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             29 AS ID,
             q'[Engels]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             41 AS ID,
             q'[Nederlands]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             42 AS ID,
             q'[Aardrijskunde]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             43 AS ID,
             q'[Natuurkunde]' AS NAME,
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

MERGE INTO STA_COURSE a
    USING
        (SELECT
             81 AS ID,
             q'[Spaans]' AS NAME,
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

prompt end sta_course_data.sql
