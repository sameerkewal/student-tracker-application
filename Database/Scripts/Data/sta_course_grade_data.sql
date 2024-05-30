MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             121 AS ID,
             29 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             122 AS ID,
             29 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             123 AS ID,
             29 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             50 AS ID,
             32 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             81 AS ID,
             41 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             82 AS ID,
             41 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             83 AS ID,
             41 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             85 AS ID,
             41 AS CRSE_ID,
             8 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             84 AS ID,
             41 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             86 AS ID,
             41 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             87 AS ID,
             42 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             88 AS ID,
             42 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             89 AS ID,
             42 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             91 AS ID,
             42 AS CRSE_ID,
             8 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             90 AS ID,
             42 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             92 AS ID,
             42 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             93 AS ID,
             43 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             94 AS ID,
             43 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             95 AS ID,
             43 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             96 AS ID,
             43 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             101 AS ID,
             61 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             102 AS ID,
             61 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             103 AS ID,
             61 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             104 AS ID,
             61 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             105 AS ID,
             64 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             106 AS ID,
             64 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             107 AS ID,
             64 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             108 AS ID,
             64 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             141 AS ID,
             81 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             142 AS ID,
             81 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             144 AS ID,
             81 AS CRSE_ID,
             8 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             143 AS ID,
             81 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             145 AS ID,
             81 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             146 AS ID,
             82 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             147 AS ID,
             82 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             148 AS ID,
             82 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             149 AS ID,
             82 AS CRSE_ID,
             8 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             150 AS ID,
             83 AS CRSE_ID,
             1 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             151 AS ID,
             83 AS CRSE_ID,
             2 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             152 AS ID,
             83 AS CRSE_ID,
             6 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             154 AS ID,
             83 AS CRSE_ID,
             8 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             153 AS ID,
             83 AS CRSE_ID,
             23 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

MERGE INTO STA_COURSE_GRADE a
    USING
        (SELECT
             155 AS ID,
             83 AS CRSE_ID,
             25 AS GRDE_ID
         FROM DUAL) b
    ON ( a.ID = b.ID )
    WHEN NOT MATCHED THEN
        INSERT (ID, CRSE_ID, GRDE_ID)
            VALUES (b.ID, b.CRSE_ID, b.GRDE_ID)
    WHEN MATCHED THEN
        UPDATE SET
            a.CRSE_ID = b.CRSE_ID,
            a.GRDE_ID = b.GRDE_ID;

commit;
