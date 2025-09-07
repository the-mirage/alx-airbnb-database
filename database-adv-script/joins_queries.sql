-- Query 1: INNER JOIN to retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM 
    Booking b
INNER JOIN 
    [User] u ON b.user_id = u.user_id;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.host_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at,
    p.updated_at,
    r.review_id,
    r.user_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at AS booking_created_at
FROM 
    [User] u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id;