-- =============================================
-- Student: Mateja Glišović
-- Indeks: IT 70/2024
-- Projekat: Passenger flight management system
-- =============================================

USE AirportSystem;
GO

-- =============================================
-- Input (Unos podataka)
-- =============================================

-- Gate (Kapije)
INSERT INTO tbl_Gate (gateNo, status)
VALUES ('A1', 'Open');
INSERT INTO tbl_Gate (gateNo, status)
VALUES ('B2', 'Closed');
INSERT INTO tbl_Gate (gateNo, status)
VALUES ('C3', 'Maintenance');

-- Staff (Zaposleni)
INSERT INTO tbl_Staff (f_name, l_name, position, salary, username, password, licenseNo, weaponPermit)
VALUES ('Petar', 'Petrović', 'Airline Staff', 1500.00, 'petar_admin', 'admin123', NULL, NULL);
INSERT INTO tbl_Staff (f_name, l_name, position, salary, username, password, licenseNo, weaponPermit)
VALUES ('Miloš', 'Milošević', 'Security Officer', 1200.00, 'milos_sec', 'sec123', NULL, 1);
INSERT INTO tbl_Staff (f_name, l_name, position, salary, username, password, licenseNo, weaponPermit)
VALUES ('Jovana', 'Jovanić', 'Stewardess', 1100.00, 'jovana_st', 'stew123', NULL, NULL);

-- Passenger (Putnici)
INSERT INTO tbl_Passenger (f_name, l_name, passportNo, UMCN, email, address, contact, username, password)
VALUES ('Mateja', 'Glišović', 'A12345678', '0309005782814', 'mateja.gl12@gmail.com', 'Marka Marković 10', '0638551101', 'mateja', 'sifra123');
INSERT INTO tbl_Passenger (f_name, l_name, passportNo, UMCN, email, address, contact, username, password)
VALUES ('Ana', 'Anić', 'B98765432', '2207999712345', 'ana.anic@gmail.com', 'Bulevar Mira 5', '0641234567', 'ana123', 'pass456');
INSERT INTO tbl_Passenger (f_name, l_name, passportNo, UMCN, email, address, contact, username, password)
VALUES ('Nenad', 'Nenadović', 'A32837263', '0205993492814', 'nenad.n@gmail.com', 'Vojvode Stepe 37', '0652536676', 'Nenad', 'sif4329');

-- Flight (Letovi)
-- Povezujemo let sa Gate-om (1) i Staff-om (1)
INSERT INTO tbl_Flight (flightNo, destination, departureTime, arrivalTime, status, gate_ID, airlineStaff_ID)
VALUES ('JU500', 'New York (JFK)', '2025-07-25T06:00:00', '2025-07-25T18:00:00', 'On Time', 1, 1);
INSERT INTO tbl_Flight (flightNo, destination, departureTime, arrivalTime, status, gate_ID, airlineStaff_ID)
VALUES ('W6400', 'London (LTN)', '2025-08-01T10:00:00', '2025-08-01T13:00:00', 'Scheduled', 2, 1);

-- Booking (Rezervacije)
INSERT INTO tbl_Booking (bookingDate, status, totalPrice, passenger_ID)
VALUES ('2025-07-23T14:30:00', 'Confirmed', 150.0, 1);
INSERT INTO tbl_Booking (bookingDate, status, totalPrice, passenger_ID)
VALUES ('2025-02-09T09:00:00', 'Confirmed', 80.0, 2);
INSERT INTO tbl_Booking (bookingDate, status, totalPrice, passenger_ID)
VALUES ('2025-05-17T17:04:59', 'Pending', 150, 3);

-- Payment (Placanje)
INSERT INTO tbl_Payment (amount, paymentDate, paymentMethod, status, booking_ID)
VALUES (150.00, '2025-12-13T12:05:00', 'Credit Card', 'Completed', 1);
INSERT INTO tbl_Payment (amount, paymentDate, paymentMethod, status, booking_ID)
VALUES (80.0, '2025-02-14T14:27:03', 'Cash', 'Completed', 2);

-- Ticket (Karte)
INSERT INTO tbl_Ticket (seatNo, class, price, flight_ID, booking_ID)
VALUES ('14F', 'Economy', 150.00, 1, 1);
INSERT INTO tbl_Ticket (seatNo, class, price, flight_ID, booking_ID)
VALUES ('9A', 'Economy', 80.0, 2, 2);

-- CheckIn & Baggage (Provera i Prtljag)
INSERT INTO tbl_CheckIn (checkinTime, type, desk_ID, ticket_ID, boardingPassCode)
VALUES ('2025-07-25T04:00:00', 'Online', NULL, 1, 'JU500-14F-MATEJA');
INSERT INTO tbl_CheckIn (checkinTime, type, desk_ID, ticket_ID, boardingPassCode)
VALUES ('2025-08-01T09:00:00', 'Live', 'Counter 12', 2, 'W6400-9A-ANA');

INSERT INTO tbl_Baggage (weight, type, isFragile, status, checkin_ID)
VALUES (23.5, 'Checked-in', 0, 'Loaded', 1);
INSERT INTO tbl_Baggage (weight, type, isFragile, status, checkin_ID)
VALUES (20.2, 'Checked-in', 1, 'Loaded', 2);


-- =============================================
-- System update demonstraton (azuriranje)
-- =============================================

-- Scenario 1: Let JU500 kasni
-- Menjamo status leta i vreme polaska
UPDATE tbl_Flight
SET status = 'Delayed', departureTime = '2025-07-25T08:00:00'
WHERE flightNo = 'JU500';

-- Scenario 2: Povecanje plate zaposlenom
-- Svim Security Officer-ima povecavamo platu za 10%
UPDATE tbl_Staff
SET salary = salary * 1.10
WHERE position = 'Security Officer';

-- Scenario 3: Promena gejta za let
-- Prebaci let sa Gejta 1 na Gejt 2
UPDATE tbl_Flight
SET gate_ID = 2
WHERE flightNo = 'JU500';

-- Dodatak: potvrdimo da stjuardese nemaju dozvole oruzija (dobro je)
UPDATE tbl_Staff
SET weaponPermit = 0
WHERE position = 'Stewardess';


-- =============================================
-- 3. DELETE (BRISANJE PODATAKA)
-- =============================================

-- Scenario: Putnik Nenad otkazuje rezervaciju koja je "Pending" (jako tuzno)
DELETE FROM tbl_Booking
WHERE status = 'Pending' AND passenger_ID = 3;


-- =============================================
-- 4. SELECT (UPITI I IZVESTAJI)
-- =============================================

-- A) Filtriranje: Prikazi samo letove koji kasne
SELECT flightNo, destination, status 
FROM tbl_Flight
WHERE status = 'Delayed';

-- B) JOIN (Spajanje tabela): Prikazi kartu sa imenom putnika i letom
SELECT 
    P.f_name + ' ' + P.l_name AS Passenger,
    F.flightNo,
    F.destination,
    T.seatNo,
    T.class
FROM tbl_Ticket T
INNER JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
INNER JOIN tbl_Passenger P ON B.passenger_ID = P.passenger_ID
INNER JOIN tbl_Flight F ON T.flight_ID = F.flight_ID;

-- D) Agregatna funkcija: koliko smo ukupno zaradili?
SELECT SUM(amount) AS TotalRevenue
FROM tbl_Payment
WHERE status = 'Completed';

SELECT 
    P.f_name + ' ' + P.l_name AS Passenger,
    T.seatNo AS Seat,
    C.boardingPassCode AS QRCode,
    C.checkinTime AS CheckInTime,
    C.type AS CheckInType
FROM tbl_CheckIn C
INNER JOIN tbl_Ticket T ON C.ticket_ID = T.ticket_ID
INNER JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
INNER JOIN tbl_Passenger P ON B.passenger_ID = P.passenger_ID;

-- Dodatak sa LEFT JOIN
SELECT
    P.f_name + ' ' + P.l_name AS Passenger,
    T.seatNo,
    C.checkinTime -- Ovo ce biti NULL ako putnik nije uradio CheckIn
FROM tbl_Ticket T
LEFT JOIN tbl_CheckIn C ON T.ticket_ID = C.ticket_ID
LEFT JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
LEFT JOIN tbl_Passenger P ON B.passenger_ID = P.passenger_ID;


-- PROVERA
SELECT * FROM tbl_Staff;
SELECT * FROM tbl_Passenger;
SELECT * FROM tbl_Flight;
SELECT * FROM tbl_CheckIn;

-- DELETE
DELETE FROM tbl_Passenger;
DELETE FROM tbl_Booking;
DELETE FROM tbl_Payment;
DELETE FROM tbl_Ticket;
DELETE FROM tbl_CheckIn;
DELETE FROM tbl_Baggage;
DELETE FROM tbl_SecurityCheck;
DELETE FROM tbl_Staff;
DELETE FROM tbl_Flight;
DELETE FROM tbl_Gate;

-- RESET
DBCC CHECKIDENT ('tbl_Passenger', RESEED, 0);
DBCC CHECKIDENT ('tbl_Booking', RESEED, 0);
DBCC CHECKIDENT ('tbl_Payment', RESEED, 0);
DBCC CHECKIDENT ('tbl_Ticket', RESEED, 0);
DBCC CHECKIDENT ('tbl_CheckIn', RESEED, 0);
DBCC CHECKIDENT ('tbl_Baggage', RESEED, 0);
DBCC CHECKIDENT ('tbl_SecurityCheck', RESEED, 0);
DBCC CHECKIDENT ('tbl_Staff', RESEED, 0);
DBCC CHECKIDENT ('tbl_Flight', RESEED, 0);
DBCC CHECKIDENT ('tbl_Gate', RESEED, 0);