SELECT TOP (1000) [LocationID]
      ,[StreetAddress]
      ,[City]
      ,[State]
  FROM [CanyonRanch].[milestone].[Location]

  INSERT INTO [CanyonRanch].[milestone].[Location] (LocationID, StreetAddress, City, State)
VALUES
  (1, '100 Canyon Ranch Road', 'Tucson', 'Arizona'),
  (2, '200 Canyon Ranch Blvd', 'Lenox', 'Massachusetts'),
  (3, '500 Wilderness Way', 'Tucson', 'Arizona'),
  (4, '300 Canyon Ranch Dr', 'Sedona', 'Arizona'),
  (5, '150 Mountain View St', 'Tucson', 'Arizona'),
  (6, '350 Sunset Blvd', 'Lenox', 'Massachusetts'),
  (7, '400 Canyon Ranch Road', 'Tucson', 'Arizona'),
  (8, '250 Canyon Ranch Way', 'Sedona', 'Arizona'),
  (9, '1100 Canyon Road', 'Lenox', 'Massachusetts'),
  (10, '900 Mountain View Dr', 'Tucson', 'Arizona'),
  (11, '1200 Wilderness Blvd', 'Sedona', 'Arizona'),
  (12, '1600 Desert Springs Ave', 'Tucson', 'Arizona'),
  (13, '220 Canyon Blvd', 'Lenox', 'Massachusetts'),
  (14, '750 Sunrise Way', 'Sedona', 'Arizona'),
  (15, '1300 Canyon Ranch Dr', 'Tucson', 'Arizona');