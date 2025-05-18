USE master;
GO

-- Create the CanyonRanchDW database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CanyonRanchDW')
    CREATE DATABASE CanyonRanchDW;
GO

USE CanyonRanchDW;
GO

-- Create schemas
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Fact')
    EXEC('CREATE SCHEMA Fact');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Dim')
    EXEC('CREATE SCHEMA Dim');
GO

-- Create Dimension Tables
CREATE TABLE Dim.Guest (
    GuestKey INT IDENTITY(1,1) PRIMARY KEY,
    GuestID INT NOT NULL,
    GuestName VARCHAR(200) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    DoB DATE NOT NULL,
    LoyaltyStatus VARCHAR(50) NULL DEFAULT 'Regular'
);

CREATE TABLE Dim.Service (
    ServiceKey INT IDENTITY(1,1) PRIMARY KEY,
    ServiceID INT NOT NULL,
    ServiceName VARCHAR(100) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Price INT NOT NULL,
    Department VARCHAR(100) NOT NULL,
    IsComplimentary VARCHAR(100) NOT NULL
);

CREATE TABLE Dim.Date (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayOfMonth INT NOT NULL,
    Month INT NOT NULL,
    MonthName VARCHAR(10) NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL,
    DayOfWeek VARCHAR(10) NOT NULL
);

CREATE TABLE Dim.Location (
    LocationKey INT IDENTITY(1,1) PRIMARY KEY,
    LocationID INT NOT NULL,
    StreetAddress VARCHAR(150) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL
);

CREATE TABLE Dim.RoomType (
    RoomTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    RoomTypeID INT NOT NULL,
    RoomType VARCHAR(100) NOT NULL,
    PricePerNight INT NOT NULL
);

CREATE TABLE Dim.Feedback (
    FeedbackKey INT IDENTITY(1,1) PRIMARY KEY,
    FeedbackID INT NOT NULL,
    Rating INT NOT NULL,
    SubmissionDate DATE NOT NULL
);

-- Create Fact Tables
CREATE TABLE Fact.Appointments (
    AppointmentFactID BIGINT IDENTITY(1,1) PRIMARY KEY,
    GuestKey INT NOT NULL,
    ServiceKey INT NOT NULL,
    DateKey INT NOT NULL,
    LocationKey INT NOT NULL,
    RoomTypeKey INT NULL,
    FeedbackKey INT NULL,
    AppointmentCount INT NOT NULL DEFAULT 1,
    ServiceRevenue INT NOT NULL,
    FOREIGN KEY (GuestKey) REFERENCES Dim.Guest(GuestKey),
    FOREIGN KEY (ServiceKey) REFERENCES Dim.Service(ServiceKey),
    FOREIGN KEY (DateKey) REFERENCES Dim.Date(DateKey),
    FOREIGN KEY (LocationKey) REFERENCES Dim.Location(LocationKey),
    FOREIGN KEY (RoomTypeKey) REFERENCES Dim.RoomType(RoomTypeKey),
    FOREIGN KEY (FeedbackKey) REFERENCES Dim.Feedback(FeedbackKey)
);

CREATE TABLE Fact.Payments (
    PaymentFactID BIGINT IDENTITY(1,1) PRIMARY KEY,
    GuestKey INT NOT NULL,
    DateKey INT NOT NULL,
    LocationKey INT NOT NULL,
    RoomTypeKey INT NULL,
    PaymentAmount INT NOT NULL,
    PaymentCount INT NOT NULL DEFAULT 1,
    FOREIGN KEY (GuestKey) REFERENCES Dim.Guest(GuestKey),
    FOREIGN KEY (DateKey) REFERENCES Dim.Date(DateKey),
    FOREIGN KEY (LocationKey) REFERENCES Dim.Location(LocationKey),
    FOREIGN KEY (RoomTypeKey) REFERENCES Dim.RoomType(RoomTypeKey)
);

-- Create indexes for performance
CREATE INDEX IX_Fact_Appointments_GuestKey ON Fact.Appointments(GuestKey);
CREATE INDEX IX_Fact_Appointments_ServiceKey ON Fact.Appointments(ServiceKey);
CREATE INDEX IX_Fact_Appointments_DateKey ON Fact.Appointments(DateKey);
CREATE INDEX IX_Fact_Payments_GuestKey ON Fact.Payments(GuestKey);
CREATE INDEX IX_Fact_Payments_DateKey ON Fact.Payments(DateKey);
GO