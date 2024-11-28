DROP DATABASE dbwildpark;
-- Create database
CREATE DATABASE dbwildpark;
USE dbwildpark;
-- Create account table
CREATE TABLE tblaccount (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(255),
    lastname VARCHAR(255)
);
-- Create parking area table
CREATE TABLE tblparkingarea (
    id INT PRIMARY KEY AUTO_INCREMENT,
    slots INT
);
-- Create vehicle table
CREATE TABLE tblvehicle (
    id INT PRIMARY KEY AUTO_INCREMENT,
    color VARCHAR(255),
    make VARCHAR(255),
    model VARCHAR(255),
    plate_number VARCHAR(255),
    owner_id INT,
    parking_area_id INT,
    FOREIGN KEY (owner_id) REFERENCES tblaccount(id),
    FOREIGN KEY (parking_area_id) REFERENCES tblparkingarea(id)
);
-- Create booking table
CREATE TABLE tblbooking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATETIME,
    parking_area_id  INT,
    vehicle_id INT,
    booker_id INT,
    status VARCHAR(255),
    FOREIGN KEY (parking_area_id) REFERENCES tblparkingarea(id),
    FOREIGN KEY (vehicle_id) REFERENCES tblvehicle(id),
    FOREIGN KEY (booker_id) REFERENCES tblaccount(id)
);
-- Stored procedure for inserting an account
DELIMITER //
CREATE PROCEDURE sp_InsertAccount(
    IN p_firstname VARCHAR(255),
    IN p_lastname VARCHAR(255),
    OUT p_inserted_id INT
)
BEGIN
    INSERT INTO tblaccount (firstname, lastname) VALUES (p_firstname, p_lastname);
    
    -- Retrieve the last inserted ID and store it in the OUT parameter
    SET p_inserted_id = LAST_INSERT_ID();
END //
-- Stored procedure for updating an account.
CREATE PROCEDURE sp_UpdateAccount(
    IN p_account_id INT,
    IN p_firstname VARCHAR(255),
    IN p_lastname VARCHAR(255),
    OUT p_new_firstname VARCHAR(255),
    OUT p_new_lastname VARCHAR(255)
)
BEGIN
    UPDATE tblaccount SET firstname = p_firstname, lastname = p_lastname WHERE id = p_account_id;
    
    SELECT firstname INTO p_new_firstname FROM tblaccount WHERE id = p_account_id;
    SELECT lastname INTO p_new_lastname FROM tblaccount WHERE id = p_account_id;
END //
-- Stored procedure for deleting an account.
CREATE PROCEDURE sp_DeleteAccount(
    IN p_account_id INT
)
BEGIN
    DELETE FROM tblaccount WHERE id = p_account_id;
END //
-- Stored procedure for inserting a vehicle
DELIMITER //
CREATE PROCEDURE sp_InsertVehicle(
    IN p_color VARCHAR(255),
    IN p_make VARCHAR(255),
    IN p_model VARCHAR(255),
    IN p_plate_number VARCHAR(255),
    IN p_owner_id INT,
    IN p_parking_area_id INT
)
BEGIN
    INSERT INTO tblvehicle (color, make, model, plate_number, owner_id, parking_area_id)
    VALUES (p_color, p_make, p_model, p_plate_number, p_owner_id, p_parking_area_id);
END //
-- Stored Procedure for updating a vehicle
DELIMITER //
CREATE PROCEDURE sp_UpdateVehicle(
    IN p_vehicle_id INT,
    IN p_color VARCHAR(255),  
    IN p_plate_number VARCHAR(255)
)
BEGIN
    UPDATE tblvehicle
    SET
        color = COALESCE(p_color, color),
        plate_number = COALESCE(p_plate_number, plate_number)
    WHERE
        id = p_vehicle_id;
END //
-- Stored procedure for deleting a vehicle
DELIMITER //
CREATE PROCEDURE sp_DeleteVehicle(
    IN p_owner_id INT
)
BEGIN
    DELETE FROM tblvehicle WHERE id = p_owner_id;
END //
-- Stored procedure for updating a booking status
DELIMITER //
CREATE PROCEDURE sp_UpdateBookingStatus(
    IN p_booking_id INT,
    IN p_status VARCHAR(255)
)
BEGIN
    UPDATE tblbooking SET status = p_status WHERE id = p_booking_id;
END //
-- Trigger on Account Deletion
DELIMITER //
CREATE TRIGGER tr_AfterDeleteAccount
AFTER DELETE ON tblaccount
FOR EACH ROW
BEGIN
    DELETE FROM tblvehicle WHERE owner_id = OLD.id;
END //

DELIMITER ;
-- Account Statistics View
CREATE VIEW vw_AccountStatistics AS
SELECT
    a.id,
    a.firstname,
    a.lastname,
    (SELECT COUNT(*) FROM tblvehicle v WHERE v.owner_id = a.id) AS `No. of Owned Vehicles`,
    (SELECT COUNT(*) FROM tblbooking b WHERE b.booker_id = a.id) AS `No. of Bookings`
FROM tblaccount a;

-- Vehicle and Owner View
CREATE VIEW vw_VehiclesWithOwners AS
SELECT
    v.id AS vehicle_id,
    v.color,
    v.make,
    v.model,
    v.plate_number,
    a.id AS owner_id,
    a.firstname AS owner_firstname,
    a.lastname AS owner_lastname
FROM
    tblvehicle v
    JOIN tblaccount a ON v.owner_id = a.id;
-- Booking Details View
CREATE VIEW vw_BookingDetails AS
SELECT
    b.id AS booking_id,
    b.date,
    b.status,
    a.id AS booker_id,
    a.firstname AS booker_firstname,
    a.lastname AS booker_lastname,
    v.id AS vehicle_id,
    v.plate_number,
    pa.id AS parking_area_id
FROM
    tblbooking b
    JOIN tblaccount a ON b.booker_id = a.id
    JOIN tblvehicle v ON b.vehicle_id = v.id
    JOIN tblparkingarea pa ON b.parking_area_id = pa.id;

-- BOOKINGS PROCEDURES
DELIMITER $$$
CREATE PROCEDURE sp_CreateBooking(
    IN p_date DATETIME,
    IN p_parking_area_id INT,
    IN p_vehicle_id INT,
    IN p_booker_id INT
)
BEGIN
    DECLARE isVehicleOwner INT DEFAULT 0;
    DECLARE isVehicleBooked INT DEFAULT 0;

    -- Check if vehicle belongs to the booker
    SELECT COUNT(*) INTO isVehicleOwner FROM vw_VehiclesWithOwners 
    WHERE vehicle_id = p_vehicle_id AND owner_id = p_booker_id;

    -- Check if vehicle is already booked
    SELECT COUNT(*) INTO isVehicleBooked FROM tblvehicle
    WHERE id = p_vehicle_id AND parking_area_id IS NOT NULL;

    IF isVehicleOwner > 0 AND isVehicleBooked = 0 THEN
        INSERT INTO tblbooking (date, parking_area_id, vehicle_id, booker_id, status) 
        VALUES (p_date, p_parking_area_id, p_vehicle_id, p_booker_id, 'Pending');

    ELSEIF isVehicleBooked > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle is already booked.';
    ELSE 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Booker does not own this vehicle";
    END IF;
END$$$
DELIMITER ;

-- TRIGGER WHEN BOOKING IS MADE
DELIMITER $$$
CREATE TRIGGER tr_AfterInsertBooking 
AFTER INSERT ON tblbooking
FOR EACH ROW
BEGIN
    UPDATE tblparkingarea
    SET slots = slots - 1
    WHERE id = NEW.parking_area_id;

    UPDATE tblvehicle
    SET parking_area_id = NEW.parking_area_id
    WHERE id = NEW.vehicle_id;
END $$$
DELIMITER ;

-- TRIGGER WHEN BOOKING IS PAID
DELIMITER $$$
CREATE TRIGGER tr_AfterUpdateBooking 
AFTER UPDATE ON tblbooking
FOR EACH ROW
BEGIN
    IF OLD.status != 'Paid' AND NEW.status = 'Paid' THEN
        UPDATE tblparkingarea
        SET slots = slots + 1
        WHERE id = OLD.parking_area_id;

        UPDATE tblvehicle
        SET parking_area_id = NULL
        WHERE id = OLD.vehicle_id;
    END IF;
END $$$
DELIMITER ;

-- TRIGGER WHEN BOOKING IS DELETED
DELIMITER $$$
CREATE TRIGGER tr_AfterDeleteBooking
AFTER DELETE ON tblbooking
FOR EACH ROW
BEGIN
    UPDATE tblparkingarea
    SET slots = slots + 1
    WHERE id = OLD.parking_area_id;

    UPDATE tblvehicle
    SET parking_area_id = NULL
    WHERE id = OLD.vehicle_id;
END $$$
DELIMITER;

DELIMITER //
CREATE PROCEDURE sp_UpdateParkingarea(
    IN p_parking_area_id INT,
    IN p_slots INT
)
BEGIN
    UPDATE tblparkingarea
    SET slots = p_slots
    WHERE id = p_parking_area_id;
END //

DELIMITER //
CREATE PROCEDURE sp_GetAllParkingAreas()
BEGIN
    SELECT * FROM tblparkingarea;
END //

DELIMITER //
CREATE PROCEDURE sp_InsertParkingArea(
    IN p_slots INT
)
BEGIN
    INSERT INTO tblparkingarea (slots)
    VALUES (p_slots);
END //

DELIMITER //
CREATE PROCEDURE sp_DeleteParkingArea(
    IN p_parking_area_id INT
)
BEGIN
    DELETE FROM tblparkingarea
    WHERE id = p_parking_area_id;
END //

DELIMITER ;
-- Procedure Calls
SET @last_insert_id = 0;
SET @updated_firstname = "";
SET @updated_lastname = "";

CALL sp_InsertAccount("John", "Doe", @last_insert_id);
CALL sp_InsertVehicle("Matte Light Brown", "Yamaha", "Sniper 155R", "G86NG", NULL, NULL);
SELECT * FROM vw_AccountStatistics WHERE id = 1;
CALL sp_UpdateAccount(1, "Jane", "Doe", @updated_firstname, @updated_lastname);
CALL sp_UpdateVehicle(1, "Light Brown", "123ABC");
CALL sp_DeleteAccount(1);
CALL sp_DeleteVehicle(1);