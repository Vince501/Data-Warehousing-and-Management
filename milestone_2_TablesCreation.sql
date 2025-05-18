USE CanyonRanch

CREATE TABLE milestone.Guest
(
  GuestID INT NOT NULL,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Email VARCHAR(150) NOT NULL,
  StreetAddress VARCHAR(100) NOT NULL,
  City VARCHAR(100) NOT NULL,
  State VARCHAR(100) NOT NULL,
  DoB DATE NOT NULL,
  PRIMARY KEY (GuestID)
);

CREATE TABLE milestone.RoomType
(
  RoomTypeID INT NOT NULL,
  RoomType VARCHAR(100) NOT NULL,
  Description VARCHAR(100) NOT NULL,
  PricePerNight INT NOT NULL,
  AvailabilityStatus VARCHAR(50) NOT NULL,
  PRIMARY KEY (RoomTypeID)
);

CREATE TABLE milestone.Staff
(
  StaffID INT NOT NULL,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Role VARCHAR(100) NOT NULL,
  Designation VARCHAR(100) NOT NULL,
  Qualifications VARCHAR(150) NOT NULL,
  PRIMARY KEY (StaffID)
);

CREATE TABLE milestone.Preference
(
  PreferenceID INT NOT NULL,
  PreferenceType VARCHAR(100) NOT NULL,
  PDescription VARCHAR(150) NOT NULL,
  GuestID INT NOT NULL,
  PRIMARY KEY (PreferenceID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID)
);

CREATE TABLE milestone.HealthInfo
(
  HealthInfoID INT NOT NULL,
  QuestionnaireResponses VARCHAR(150) NOT NULL,
  MedicalAlerts VARCHAR(100) NOT NULL,
  GuestID INT NOT NULL,
  PRIMARY KEY (HealthInfoID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID)
);

CREATE TABLE milestone.Location
(
  LocationID INT NOT NULL,
  StreetAddress VARCHAR(150) NOT NULL,
  City VARCHAR(100) NOT NULL,
  State VARCHAR(100) NOT NULL,
  PRIMARY KEY (LocationID)
);

CREATE TABLE milestone.MedicalHistory
(
  HistoryID INT NOT NULL,
  RecordDate DATE NOT NULL,
  HealthStatus VARCHAR(100) NOT NULL,
  HealthDetails VARCHAR(150) NOT NULL,
  GuestID INT NOT NULL,
  PRIMARY KEY (HistoryID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID)
);

CREATE TABLE milestone.Guest_PhoneNo
(
  PhoneNo INT NOT NULL,
  GuestID INT NOT NULL,
  PRIMARY KEY (PhoneNo, GuestID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID)
);

CREATE TABLE milestone.Reservation
(
  ReservationID INT NOT NULL,
  CheckInDate DATE NOT NULL,
  CheckOutDate DATE NOT NULL,
  Status VARCHAR(100) NOT NULL,
  RoomTypeID INT NOT NULL,
  GuestID INT NOT NULL,
  LocationID INT NOT NULL,
  PRIMARY KEY (ReservationID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID),
  FOREIGN KEY (LocationID) REFERENCES milestone.Location(LocationID),
  UNIQUE (RoomTypeID)
);

CREATE TABLE milestone.HotelPackage
(
  PackageID INT NOT NULL,
  PackageName VARCHAR(100) NOT NULL,
  Description VARCHAR(100) NOT NULL,
  Price INT NOT NULL,
  DurationDays INT NOT NULL,
  AllowanceHealthHealing VARCHAR(100) NOT NULL,
  AllowanceSpaSports VARCHAR(100) NOT NULL,
  ReservationID INT,
  RoomTypeID INT,
  PRIMARY KEY (PackageID),
  FOREIGN KEY (ReservationID) REFERENCES milestone.Reservation(ReservationID),
  FOREIGN KEY (RoomTypeID) REFERENCES milestone.RoomType(RoomTypeID)
);

CREATE TABLE milestone.Service
(
  ServiceID INT NOT NULL,
  ServiceName VARCHAR(100) NOT NULL,
  Category_ VARCHAR(100) NOT NULL,
  Price INT NOT NULL,
  Department VARCHAR(100) NOT NULL,
  IsComplimentary VARCHAR(100) NOT NULL,
  PackageID INT,
  PRIMARY KEY (ServiceID),
  FOREIGN KEY (PackageID) REFERENCES milestone.HotelPackage(PackageID)
);

CREATE TABLE milestone.RoomAssignment
(
  AssignmentID INT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  ReservationID INT NOT NULL,
  RoomTypeID INT NOT NULL,
  PRIMARY KEY (AssignmentID, ReservationID, RoomTypeID),
  FOREIGN KEY (ReservationID) REFERENCES milestone.Reservation(ReservationID),
  FOREIGN KEY (RoomTypeID) REFERENCES milestone.RoomType(RoomTypeID)
);

CREATE TABLE milestone.Appointment
(
  AppointmentID INT NOT NULL,
  DateTIme DATE NOT NULL,
  Status VARCHAR(100) NOT NULL,
  GuestID INT NOT NULL,
  ServiceID INT NOT NULL,
  StaffID INT NOT NULL,
  PRIMARY KEY (AppointmentID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID),
  FOREIGN KEY (ServiceID) REFERENCES milestone.Service(ServiceID),
  FOREIGN KEY (StaffID) REFERENCES milestone.Staff(StaffID)
);

CREATE TABLE milestone.Payments
(
  PaymentID INT NOT NULL,
  Amount INT NOT NULL,
  PaymentDate DATE NOT NULL,
  PaymentMethod VARCHAR(100) NOT NULL,
  PaymentFor VARCHAR(100) NOT NULL,
  ReservationID INT NOT NULL,
  AppointmentID INT NOT NULL,
  PRIMARY KEY (PaymentID, ReservationID, AppointmentID),
  FOREIGN KEY (ReservationID) REFERENCES milestone.Reservation(ReservationID),
  FOREIGN KEY (AppointmentID) REFERENCES milestone.Appointment(AppointmentID)
);

CREATE TABLE milestone.Feedback_
(
  FeedbackID INT NOT NULL,
  Rating INT NOT NULL,
  Comments VARCHAR(100) NOT NULL,
  SubmissionDate DATE NOT NULL,
  GuestID INT NOT NULL,
  AppointmentID INT,
  PRIMARY KEY (FeedbackID),
  FOREIGN KEY (GuestID) REFERENCES milestone.Guest(GuestID),
  FOREIGN KEY (AppointmentID) REFERENCES milestone.Appointment(AppointmentID)
);