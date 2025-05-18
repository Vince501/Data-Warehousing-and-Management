SELECT TOP (1000) [PackageID]
      ,[PackageName]
      ,[Description]
      ,[Price]
      ,[DurationDays]
      ,[AllowanceHealthHealing]
      ,[AllowanceSpaSports]
      ,[ReservationID]
      ,[RoomTypeID]
  FROM [CanyonRanch].[milestone].[HotelPackage]

INSERT INTO milestone.Service (ServiceID, ServiceName, Category_, Price, Department, IsComplimentary, PackageID)
VALUES
-- Spa and Sports Services
(1, 'Skin Care and Salon', 'Spa and Sports', 150, 'Spa Department', 0, 1),
(2, 'Therapeutic Bodywork and Massage', 'Spa and Sports', 180, 'Massage Therapy', 0, 2),
(3, 'Fitness', 'Spa and Sports', 100, 'Fitness Center', 1, 3),
(4, 'Outdoor', 'Spa and Sports', 120, 'Outdoor Activities', 1, 4),
(5, 'Metaphysical Services', 'Spa and Sports', 140, 'Mind-Body Services', 0, 5),

-- Health and Healing Services
(6, 'Medical and Nursing', 'Health and Healing', 200, 'Medical Office', 0, 6),
(7, 'Exercise Physiology', 'Health and Healing', 160, 'Performance Lab', 0, 6),
(8, 'Movement Therapy', 'Health and Healing', 130, 'Therapy Center', 1, 7),
(9, 'Food and Nutrition', 'Health and Healing', 90, 'Nutrition Services', 1, 8),
(10, 'Behavioral and Health', 'Health and Healing', 170, 'Behavioral Health', 0, 9),
(11, 'Spiritual Awareness', 'Health and Healing', 110, 'Spiritual Services', 1, 10),

-- Wellness & Lifestyle
(12, 'Life Coaching', 'Wellness & Lifestyle', 160, 'Lifestyle Programs', 0, 11),
(13, 'Personal Retreat Planning', 'Wellness & Lifestyle', 80, 'Guest Services', 1, 11),
(14, 'Healthy Sleep Consultation', 'Wellness & Lifestyle', 90, 'Medical Office', 0, 12),
(15, 'Stress Management Workshop', 'Wellness & Lifestyle', 95, 'Behavioral Health', 1, 13),

-- Beauty & Aesthetics
(16, 'HydraFacial Treatment', 'Beauty & Aesthetics', 200, 'Spa Department', 0, 14),
(17, 'Hair Styling & Cut', 'Beauty & Aesthetics', 75, 'Salon', 0, 14),
(18, 'Manicure & Pedicure', 'Beauty & Aesthetics', 65, 'Salon', 1, 15),

-- Nutrition & Culinary
(19, 'Healthy Cooking Class', 'Nutrition & Culinary', 55, 'Culinary Center', 1, 16),
(20, 'One-on-One Nutrition Session', 'Nutrition & Culinary', 100, 'Nutrition Services', 0, 17),

-- Specialized Programs
(21, 'Sleep Enhancement Program', 'Specialized Programs', 250, 'Sleep Lab', 0, 18),
(22, 'Weight Loss Bootcamp', 'Specialized Programs', 300, 'Fitness Center', 0, 19),
(23, 'Chronic Pain Management', 'Specialized Programs', 280, 'Therapy Center', 0, 20);
