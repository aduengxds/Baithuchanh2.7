
-- =============================================
-- AUTORIDE DATABASE OPTIMIZATION
-- He thong quan ly thue xe tu lai
-- DBMS: MySQL
-- =============================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- =============================================
-- 1. TAO BANG CARS
-- =============================================

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE
);

-- =============================================
-- 2. TAO BANG RENTALS LEGACY
-- =============================================

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(50) DEFAULT 'BOOKED',

    CONSTRAINT fk_rentals_cars
        FOREIGN KEY (car_id)
        REFERENCES Cars(car_id)
);

-- =============================================
-- 3. NANG CAP BANG RENTALS
-- =============================================

ALTER TABLE Rentals
    MODIFY COLUMN status
        ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED')
        NOT NULL DEFAULT 'BOOKED',
    ADD COLUMN security_deposit DECIMAL(10, 2)
        NOT NULL DEFAULT 0.00,
    ADD COLUMN late_fee DECIMAL(10, 2)
        NOT NULL DEFAULT 0.00,
    ADD COLUMN damage_fee DECIMAL(10, 2)
        NOT NULL DEFAULT 0.00;

-- =============================================
-- 4. RANG BUOC CAC KHOAN TIEN
-- =============================================

ALTER TABLE Rentals
    ADD CONSTRAINT chk_security_deposit
        CHECK (security_deposit >= 0),
    ADD CONSTRAINT chk_late_fee
        CHECK (late_fee >= 0),
    ADD CONSTRAINT chk_damage_fee
        CHECK (damage_fee >= 0);

-- =============================================
-- 5. TAO BANG INSPECTIONS
-- =============================================

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,

    CONSTRAINT fk_inspections_rentals
        FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id)
        ON DELETE RESTRICT
);

-- =============================================
-- 6. TRIGGER KIEM TRA TRANG THAI HOP DONG
-- Chi cho phep kiem tra xe khi hop dong ACTIVE
-- =============================================

DELIMITER //

CREATE TRIGGER trg_inspection_requires_active_rental
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Rentals
        WHERE rental_id = NEW.rental_id
          AND status = 'ACTIVE'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Hop dong phai ACTIVE moi duoc kiem tra xe';
    END IF;
END//

DELIMITER ;

-- =============================================
-- 7. THEM DU LIEU XE
-- =============================================

INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Vios', '30A-12345');

-- =============================================
-- 8. KHACH HANG THUE XE VA DONG COC
-- =============================================

INSERT INTO Rentals (
    car_id,
    customer_name,
    rent_date,
    status,
    security_deposit,
    late_fee,
    damage_fee
)
VALUES (
    1,
    'Nguyen Van A',
    NOW(),
    'ACTIVE',
    10000000.00,
    0.00,
    0.00
);

-- =============================================
-- 9. GHI NHAN BIEN BAN KIEM TRA XE
-- =============================================

INSERT INTO Inspections (
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES (
    1,
    NOW(),
    'Vo den pha trai',
    'Tran Van B'
);

-- =============================================
-- 10. CAP NHAT HOP DONG KHI TRA XE
-- =============================================

UPDATE Rentals
SET
    return_date = NOW(),
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1;

-- =============================================
-- 11. TINH TIEN HOAN TRA CHO KHACH
-- =============================================

SELECT
    rental_id,
    customer_name,
    security_deposit,
    late_fee,
    damage_fee,
    security_deposit - late_fee - damage_fee
        AS refund_amount
FROM Rentals
WHERE rental_id = 1;

-- =============================================
-- 12. KIEM TRA THONG TIN BIEN BAN
-- =============================================

SELECT
    i.inspection_id,
    r.customer_name,
    i.inspection_date,
    i.damage_description,
    i.inspector_name
FROM Inspections AS i
INNER JOIN Rentals AS r
    ON i.rental_id = r.rental_id
WHERE r.rental_id = 1;
