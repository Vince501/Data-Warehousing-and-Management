USE CanyonRanchDW;
GO

-- Populate Dim.Date (sample for 2023)
INSERT INTO Dim.Date (DateKey, FullDate, DayOfMonth, Month, MonthName, Quarter, Year, DayOfWeek)
SELECT 
    CONVERT(INT, FORMAT(d, 'yyyyMMdd')),
    d,
    DAY(d),
    MONTH(d),
    DATENAME(MONTH, d),
    DATEPART(QUARTER, d),
    YEAR(d),
    DATENAME(WEEKDAY, d)
FROM (
    SELECT DATEADD(DAY, n, '2023-01-01')
    FROM (SELECT TOP 365 n = ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
          FROM sys.objects a, sys.objects b) numbers
) dates(d);
GO

-- Populate Dim.Guest
INSERT INTO Dim.Guest (GuestID, GuestName, Email, DoB, LoyaltyStatus)
SELECT 
    g.GuestID,
    CONCAT(g.FirstName, ' ', g.LastName),
    g.Email,
    g.DoB,
    CASE 
        WHEN DATEDIFF(YEAR, g.DoB, GETDATE()) > 50 THEN 'Gold'
        WHEN DATEDIFF(YEAR, g.DoB, GETDATE()) > 30 THEN 'Silver'
        ELSE 'Regular'
    END
FROM CanyonRanch.milestone.Guest g;
GO

-- Populate Dim.Service
INSERT INTO Dim.Service (ServiceID, ServiceName, Category, Price, Department, IsComplimentary)
SELECT 
    s.ServiceID,
    s.ServiceName,
    s.Category_,
    s.Price,
    s.Department,
    s.IsComplimentary
FROM CanyonRanch.milestone.Service s;
GO

-- Populate Dim.Location
INSERT INTO Dim.Location (LocationID, StreetAddress, City, State)
SELECT 
    l.LocationID,
    l.StreetAddress,
    l.City,
    l.State
FROM CanyonRanch.milestone.Location l;
GO

-- Populate Dim.RoomType
INSERT INTO Dim.RoomType (RoomTypeID, RoomType, PricePerNight)
SELECT 
    rt.RoomTypeID,
    rt.RoomType,
    rt.PricePerNight
FROM CanyonRanch.milestone.RoomType rt;
GO

-- Populate Dim.Feedback
INSERT INTO Dim.Feedback (FeedbackID, Rating, SubmissionDate)
SELECT 
    f.FeedbackID,
    f.Rating,
    f.SubmissionDate
FROM CanyonRanch.milestone.Feedback_ f;
GO

-- Populate Fact.Appointments
INSERT INTO Fact.Appointments (
    GuestKey, ServiceKey, DateKey, LocationKey, RoomTypeKey, FeedbackKey, 
    AppointmentCount, ServiceRevenue
)
SELECT 
    dg.GuestKey,
    ds.ServiceKey,
    dd.DateKey,
    dl.LocationKey,
    drt.RoomTypeKey,
    df.FeedbackKey,
    1 AS AppointmentCount,
    s.Price AS ServiceRevenue
FROM CanyonRanch.milestone.Appointment a
JOIN CanyonRanch.milestone.Guest g ON a.GuestID = g.GuestID
JOIN CanyonRanch.milestone.Service s ON a.ServiceID = s.ServiceID
JOIN CanyonRanch.milestone.Reservation r ON r.GuestID = g.GuestID
JOIN CanyonRanch.milestone.RoomType rt ON r.RoomTypeID = rt.RoomTypeID
JOIN CanyonRanch.milestone.Location l ON r.LocationID = l.LocationID
LEFT JOIN CanyonRanch.milestone.Feedback_ f ON a.AppointmentID = f.AppointmentID
JOIN Dim.Guest dg ON g.GuestID = dg.GuestID
JOIN Dim.Service ds ON s.ServiceID = ds.ServiceID
JOIN Dim.Date dd ON CAST(a.DateTIme AS DATE) = dd.FullDate
JOIN Dim.Location dl ON l.LocationID = dl.LocationID
JOIN Dim.RoomType drt ON rt.RoomTypeID = drt.RoomTypeID
LEFT JOIN Dim.Feedback df ON f.FeedbackID = df.FeedbackID;
GO

-- Populate Fact.Payments
INSERT INTO Fact.Payments (
    GuestKey, DateKey, LocationKey, RoomTypeKey, PaymentAmount, PaymentCount
)
SELECT 
    dg.GuestKey,
    dd.DateKey,
    dl.LocationKey,
    drt.RoomTypeKey,
    p.Amount,
    1 AS PaymentCount
FROM CanyonRanch.milestone.Payments p
JOIN CanyonRanch.milestone.Reservation r ON p.ReservationID = r.ReservationID
JOIN CanyonRanch.milestone.Guest g ON r.GuestID = g.GuestID
JOIN CanyonRanch.milestone.Location l ON r.LocationID = l.LocationID
JOIN CanyonRanch.milestone.RoomType rt ON r.RoomTypeID = rt.RoomTypeID
JOIN Dim.Guest dg ON g.GuestID = dg.GuestID
JOIN Dim.Date dd ON p.PaymentDate = dd.FullDate
JOIN Dim.Location dl ON l.LocationID = dl.LocationID
JOIN Dim.RoomType drt ON rt.RoomTypeID = drt.RoomTypeID
WHERE p.ReservationID IS NOT NULL
UNION ALL
SELECT 
    dg.GuestKey,
    dd.DateKey,
    dl.LocationKey,
    NULL AS RoomTypeKey,
    p.Amount,
    1 AS PaymentCount
FROM CanyonRanch.milestone.Payments p
JOIN CanyonRanch.milestone.Appointment a ON p.AppointmentID = a.AppointmentID
JOIN CanyonRanch.milestone.Guest g ON a.GuestID = g.GuestID
JOIN CanyonRanch.milestone.Reservation r ON r.GuestID = g.GuestID
JOIN CanyonRanch.milestone.Location l ON r.LocationID = l.LocationID
JOIN Dim.Guest dg ON g.GuestID = dg.GuestID
JOIN Dim.Date dd ON p.PaymentDate = dd.FullDate
JOIN Dim.Location dl ON l.LocationID = dl.LocationID
WHERE p.AppointmentID IS NOT NULL;
GO