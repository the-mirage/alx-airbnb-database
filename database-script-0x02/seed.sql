-- populate.sql

-- Insert sample data into User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('UUID1', 'John', 'Doe', 'john.doe@example.com', 'hashed_password_1', '+12345678901', 'guest', '2025-08-01 10:00:00'),
('UUID2', 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_2', '+12345678902', 'host', '2025-08-01 11:00:00'),
('UUID3', 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_3', NULL, 'guest', '2025-08-02 09:00:00'),
('UUID4', 'Bob', 'Williams', 'bob.williams@example.com', 'hashed_password_4', '+12345678903', 'host', '2025-08-02 12:00:00'),
('UUID5', 'Emma', 'Brown', 'emma.brown@example.com', 'hashed_password_5', '+12345678904', 'admin', '2025-08-03 08:00:00');

-- Insert sample data into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('UUID6', 'UUID2', 'Cozy Beach Cottage', 'A charming cottage by the beach with ocean views.', '123 Ocean Dr, Miami, FL', 150.00, '2025-08-05 14:00:00', '2025-08-05 14:00:00'),
('UUID7', 'UUID2', 'City Loft', 'Modern loft in downtown with great amenities.', '456 Main St, New York, NY', 200.00, '2025-08-06 15:00:00', '2025-08-06 15:00:00'),
('UUID8', 'UUID4', 'Mountain Retreat', 'Secluded cabin in the mountains with hiking trails.', '789 Pine Rd, Denver, CO', 120.00, '2025-08-07 16:00:00', '2025-08-07 16:00:00');

-- Insert sample data into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, status, created_at) VALUES
('UUID9', 'UUID6', 'UUID1', '2025-09-01', '2025-09-05', 'confirmed', '2025-08-10 09:00:00'),
('UUID10', 'UUID7', 'UUID3', '2025-09-10', '2025-09-12', 'pending', '2025-08-11 10:00:00'),
('UUID11', 'UUID8', 'UUID1', '2025-09-15', '2025-09-20', 'confirmed', '2025-08 Chew12 11:00:00'),
('UUID12', 'UUID6', 'UUID3', '2025-09-25', '2025-09-28', 'canceled', '2025-08-13 12:00:00');

-- Insert sample data into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('UUID13', 'UUID9', 600.00, '2025-08-10 09:30:00', 'credit_card'), -- 4 nights * $150
('UUID14', 'UUID9', 300.00, '2025-08-11 10:00:00', 'paypal'),     -- Partial payment for same booking
('UUID15', 'UUID11', 600.00, '2025-08-12 11:30:00', 'stripe');      -- 5 nights * $120

-- Insert sample data into Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('UUID16', 'UUID6', 'UUID1', 4, 'Lovely cottage, great views, but could use more parking.', '2025-09-06 14:00:00'),
('UUID17', 'UUID8', 'UUID1', 5, 'Amazing retreat! Perfect for a quiet getaway.', '2025-09-21 15:00:00'),
('UUID18', 'UUID7', 'UUID3', 3, 'Nice loft, but noisy at night due to city location.', '2025-09-13 16:00:00');

-- Insert sample data into Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('UUID19', 'UUID1', 'UUID2', 'Is the beach cottage available for September 1-5?', '2025-08-08 08:00:00'),
('UUID20', 'UUID2', 'UUID1', 'Yes, it’s available! Please proceed with the booking.', '2025-08-08 09:00:00'),
('UUID21', 'UUID3', 'UUID4', 'Can I bring pets to the mountain retreat?', '2025-08-10 10:00:00'),
('UUID22', 'UUID4', 'UUID3', 'Sorry, no pets allowed at the retreat.', '2025-08-10 11:00:00');

-- Notes on Sample Data
-- UUIDs: Replace placeholders (UUID1, UUID2, etc.) with actual UUIDs using a UUID generator or database function (e.g., UUID() in MySQL, gen_random_uuid() in PostgreSQL).
-- Real-World Usage:
--   Users include guests, hosts, and an admin to reflect different roles.
--   Properties are owned by hosts (Jane Smith, Bob Williams) and vary in location and price.
--   Bookings cover multiple properties and users, with different statuses (confirmed, pending, canceled).
--   Payments include multiple payments for a single booking (e.g., UUID9) to show partial payments.
--   Reviews provide feedback on properties, with varying ratings and comments.
--   Messages simulate communication between guests and hosts regarding bookings.
-- Data Integrity:
--   Foreign keys (host_id, property_id, user_id, booking_id, sender_id, recipient_id) reference valid records.
--   Payment amounts align with booking durations and property prices (e.g., $600 for 4 nights at $150/night).
--   Timestamps are set to realistic dates in August/September 2025 to reflect recent activity.