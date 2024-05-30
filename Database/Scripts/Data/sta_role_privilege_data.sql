MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         187 AS ID,
         1 AS RLE_ID,
         101 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         188 AS ID,
         1 AS RLE_ID,
         123 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         189 AS ID,
         1 AS RLE_ID,
         125 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         190 AS ID,
         1 AS RLE_ID,
         142 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         186 AS ID,
         14 AS RLE_ID,
         81 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         179 AS ID,
         14 AS RLE_ID,
         101 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         180 AS ID,
         14 AS RLE_ID,
         103 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         181 AS ID,
         14 AS RLE_ID,
         123 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         182 AS ID,
         14 AS RLE_ID,
         124 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         183 AS ID,
         14 AS RLE_ID,
         125 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         184 AS ID,
         14 AS RLE_ID,
         127 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         185 AS ID,
         14 AS RLE_ID,
         142 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         137 AS ID,
         30 AS RLE_ID,
         81 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         135 AS ID,
         30 AS RLE_ID,
         101 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         136 AS ID,
         30 AS RLE_ID,
         103 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         138 AS ID,
         30 AS RLE_ID,
         123 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

MERGE INTO STA_ROLE_PRIVILEGE a
USING
    (SELECT
         139 AS ID,
         30 AS RLE_ID,
         124 AS PVE_ID
     FROM DUAL) b
ON ( a.ID = b.ID )
WHEN NOT MATCHED THEN
    INSERT (ID, RLE_ID, PVE_ID)
    VALUES (b.ID, b.RLE_ID, b.PVE_ID)
WHEN MATCHED THEN
    UPDATE SET
               a.RLE_ID = b.RLE_ID,
               a.PVE_ID = b.PVE_ID;

