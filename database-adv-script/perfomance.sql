-- Initial Query: Retrieve all bookings with user, property, and payment details
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at AS booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM 
    Booking b
INNER JOIN 
    [User] u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id;

-- Additional Index for Payment.booking_id to optimize LEFT JOIN
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);

-- Refactored Query: Retrieve confirmed/pending bookings with user, property, and payment details
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.payment_id,
    pay.amount
FROM 
    Booking b
INNER JOIN 
    [User] u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status IN ('confirmed', 'pending');