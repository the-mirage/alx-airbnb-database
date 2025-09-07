# Optimization Report to Optimize Complex Queries

An analysis of the performance of a complex query retrieving all bookings with user, property, and payment details, identifies inefficiencies, and describes the refactoring process to improve execution time. The queries and index are stored in `performance.sql`.

## Initial Query

```sql
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
    User u ON b.user_id = u.user_id
INNER JOIN
    Property p ON b.property_id = p.property_id
LEFT JOIN
    Payment pay ON b.booking_id = pay.booking_id;
```
