SELECT TOP (1000) [HistoryID]
      ,[RecordDate]
      ,[HealthStatus]
      ,[HealthDetails]
      ,[GuestID]
  FROM [CanyonRanch].[milestone].[MedicalHistory]


DECLARE @Counter INT = 1;

WHILE @Counter <= 100
BEGIN
    INSERT INTO [CanyonRanch].[milestone].[MedicalHistory] (HistoryID, RecordDate, HealthStatus, HealthDetails, GuestID)
    VALUES (
        @Counter,  -- HistoryID
        DATEADD(DAY, FLOOR(RAND() * 464), '2024-01-01'),  -- Random date from Jan 1, 2024, to Apr 9, 2025 (464 days)
        CASE CAST(RAND() * 4 AS INT)  -- Random HealthStatus
            WHEN 0 THEN 'Excellent'
            WHEN 1 THEN 'Good'
            WHEN 2 THEN 'Fair'
            ELSE 'Poor'
        END,
        CASE CAST(RAND() * 6 AS INT)  -- Realistic HealthDetails for Canyon Ranch
            WHEN 0 THEN 'Reports high energy after detox program.'
            WHEN 1 THEN 'Mild back pain noted, recommended yoga therapy.'
            WHEN 2 THEN 'Stress levels reduced post-meditation sessions.'
            WHEN 3 THEN 'Minor knee discomfort, advised low-impact exercise.'
            WHEN 4 THEN 'Improved sleep quality after wellness coaching.'
            ELSE 'Elevated blood pressure, monitoring advised.'
        END,
        FLOOR(RAND() * 100) + 1  -- GuestID between 1 and 100
    );
    SET @Counter = @Counter + 1;
END;