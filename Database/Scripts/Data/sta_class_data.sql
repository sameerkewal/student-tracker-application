prompt start sta_class_data.sql

MERGE INTO STA_CLASS a
    USING
        (SELECT
             82 AS ID,
             q'[1B]' AS NAME,
                 1 AS GRDE_ID,
             null AS USR_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, GRDE_ID, USR_ID)
            VALUES (b.ID, b.NAME, b.GRDE_ID, b.USR_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.GRDE_ID = b.GRDE_ID,
            a.USR_ID = b.USR_ID;

MERGE INTO STA_CLASS a
    USING
        (SELECT
             83 AS ID,
             q'[1C]' AS NAME,
                 1 AS GRDE_ID,
             null AS USR_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, GRDE_ID, USR_ID)
            VALUES (b.ID, b.NAME, b.GRDE_ID, b.USR_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.GRDE_ID = b.GRDE_ID,
            a.USR_ID = b.USR_ID;

MERGE INTO STA_CLASS a
    USING
        (SELECT
             84 AS ID,
             q'[1D]' AS NAME,
                 1 AS GRDE_ID,
             null AS USR_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, GRDE_ID, USR_ID)
            VALUES (b.ID, b.NAME, b.GRDE_ID, b.USR_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.GRDE_ID = b.GRDE_ID,
            a.USR_ID = b.USR_ID;

MERGE INTO STA_CLASS a
    USING
        (SELECT
             81 AS ID,
             q'[1A]' AS NAME,
                 1 AS GRDE_ID,
             null AS USR_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, NAME, GRDE_ID, USR_ID)
            VALUES (b.ID, b.NAME, b.GRDE_ID, b.USR_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.NAME = b.NAME,
            a.GRDE_ID = b.GRDE_ID,
            a.USR_ID = b.USR_ID;
commit;

prompt end sta_class_data.sql
