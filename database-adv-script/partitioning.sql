-- Step 1: Drop the existing Booking table (if it exists, assuming data is backed up or empty)
DROP TABLE IF EXISTS Booking
CASCADE;

-- Step 2: Create the parent Booking table (without data storage)
CREATE TABLE Booking
(
    booking_id UUID,
    property_id UUID,
    user_id UUID,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (
        status IN (
            'pending',
            'confirmed',
            'canceled'
        )
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date)
)
PARTITION BY
    RANGE
(start_date);

-- Step 3: Create child partitions for specific year ranges
CREATE TABLE Booking_2023 PARTITION OF Booking FOR
VALUES
FROM
('2023-01-01') TO
('2024-01-01');

CREATE TABLE Booking_2024 PARTITION OF Booking FOR
VALUES
FROM
('2024-01-01') TO
('2025-01-01');

CREATE TABLE Booking_2025 PARTITION OF Booking FOR
VALUES
FROM
('2025-01-01') TO
('2026-01-01');

CREATE TABLE Booking_future PARTITION OF Booking FOR
VALUES
FROM
('2026-01-01') TO
(MAXVALUE);

-- Step 4: Add foreign key constraints to child partitions
ALTER TABLE Booking_2023
ADD CONSTRAINT fk_property_id FOREIGN KEY (property_id) REFERENCES Property (property_id)
,
ADD CONSTRAINT fk_user_id FOREIGN KEY
(user_id) REFERENCES User
(user_id);

ALTER TABLE Booking_2024
ADD CONSTRAINT fk_property_id FOREIGN KEY (property_id) REFERENCES Property (property_id)
,
ADD CONSTRAINT fk_user_id FOREIGN KEY
(user_id) REFERENCES User
(user_id);

ALTER TABLE Booking_2025
ADD CONSTRAINT fk_property_id FOREIGN KEY (property_id) REFERENCES Property (property_id)
,
ADD CONSTRAINT fk_user_id FOREIGN KEY
(user_id) REFERENCES User
(user_id);

ALTER TABLE Booking_future
ADD CONSTRAINT fk_property_id FOREIGN KEY (property_id) REFERENCES Property (property_id)
,
ADD CONSTRAINT fk_user_id FOREIGN KEY
(user_id) REFERENCES User
(user_id);

-- Step 5: Recreate indexes from database_index.sql on the parent table
CREATE INDEX idx_booking_property_id ON Booking (property_id);

CREATE INDEX idx_booking_user_id ON Booking (user_id);

CREATE INDEX idx_booking_status ON Booking (status);

CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);