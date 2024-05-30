prompt start sta_grade_data.sql


MERGE INTO STA_GRADE a
    USING
        (SELECT
             23 AS ID,
             q'[Leerjaar 3b]' AS NAME,
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

MERGE INTO STA_GRADE a
    USING
        (SELECT
             41 AS ID,
             q'[Leerjaar 5]' AS NAME,
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

MERGE INTO STA_GRADE a
    USING
        (SELECT
             1 AS ID,
             q'[Leerjaar 1]' AS NAME,
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

MERGE INTO STA_GRADE a
    USING
        (SELECT
             2 AS ID,
             q'[Leerjaar 2]' AS NAME,
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

MERGE INTO STA_GRADE a
    USING
        (SELECT
             6 AS ID,
             q'[Leerjaar 3a]' AS NAME,
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

MERGE INTO STA_GRADE a
    USING
        (SELECT
             8 AS ID,
             q'[Leerjaar 4a]' AS NAME,
                 q'[Examen klas]' AS DESCRIPTION
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, DESCRIPTION)
            VALUES (b.ID, b.NAME, b.DESCRIPTION)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.DESCRIPTION = b.DESCRIPTION;

MERGE INTO STA_GRADE a
    USING
        (SELECT
             25 AS ID,
             q'[Leerjaar 4b]' AS NAME,
                 q'[Examen klas]' AS DESCRIPTION
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

prompt end sta_grade_data.sql
