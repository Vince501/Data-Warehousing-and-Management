SELECT TOP (1000) [FeedbackID]
      ,[Rating]
      ,[Comments]
      ,[SubmissionDate]
      ,[GuestID]
      ,[AppointmentID]
  FROM [CanyonRanch].[milestone].[Feedback_]

DECLARE @Counter INT = 1;

WHILE @Counter <= 500
BEGIN
    INSERT INTO milestone.Feedback_ (FeedbackID, Rating, Comments, SubmissionDate, GuestID, AppointmentID)
    VALUES (
        @Counter,  -- FeedbackID
        FLOOR(RAND() * 5) + 1,  -- Rating between 1 and 5
        CASE CAST(RAND() * 5 AS INT)  -- Random realistic comments
            WHEN 0 THEN 'The spa was heavenly, totally worth it!'
            WHEN 1 THEN 'Food was bland, expected better from Canyon Ranch.'
            WHEN 2 THEN 'Great staff, but the class started late.'
            WHEN 3 THEN 'Beautiful views, but the room was noisy.'
            ELSE 'Loved the wellness program, will come back!'
        END,
        DATEADD(DAY, FLOOR(RAND() * 98), '2025-01-01'),  -- Random date between Jan 1 and April 9, 2025
        FLOOR(RAND() * 100) + 1,  -- GuestID between 1 and 100
        FLOOR(RAND() * 70) + 1001  -- AppointmentID between 1001 and 1070
    );
    SET @Counter = @Counter + 1;
END;