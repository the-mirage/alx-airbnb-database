-- Total number of bookings made by each user
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings
FROM
    [User] u
    LEFT JOIN
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
ORDER BY 
    total_bookings DESC;

-- Ranking properties by total bookings using RANK()
SELECT
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM
    Property p
    LEFT JOIN
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
ORDER BY 
    booking_rank, p.property_id;


-- Alternative using COUNT()
SELECT
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num
FROM
    Property p
    LEFT JOIN
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
ORDER BY 
    booking_rank, p.property_id;