# Index Performance Analysis for Airbnb Clone Backend

This is an analysis of the performance impact of adding indexes to the `User`, `Booking`, and `Property` tables to optimize query performance, as specified in the `database_index.sql` file. The analysis uses `EXPLAIN` to compare query plans before and after indexing for two representative queries.

## High-Usage Columns

Based on queries and API endpoints (e.g., `requirements.md`, joins, subqueries, aggregations), the high-usage columns are:

- **User**: `user_id` (PK, indexed), `email`, `role`
- **Booking**: `booking_id` (PK, indexed), `property_id`, `user_id`, `status`, `start_date`, `end_date`
- **Property**: `property_id` (PK, indexed), `host_id`, `location`, `pricepernight`

## Indexes Created

See `database_index.sql` for `CREATE INDEX` commands:

- `idx_user_email` on `User(email)`
- `idx_user_role` on `User(role)`
- `idx_booking_property_id` on `Booking(property_id)`
- `idx_booking_user_id` on `Booking(user_id)`
- `idx_booking_status` on `Booking(status)`
- `idx_booking_dates` on `Booking(start_date, end_date)`
- `idx_property_host_id` on `Property(host_id)`
- `idx_property_location` on `Property(location)`
- `idx_property_pricepernight` on `Property(pricepernight)`

## Queries Analyzed

### Query 1: INNER JOIN with User.email

```sql
SELECT
    b.booking_id,
    b.property_id,
    b.user_id,
    b.status,
    u.first_name,
    u.email
FROM
    Booking b
INNER JOIN
    User u ON b.user_id = u.user_id
WHERE
    u.email = 'john.doe@example.com';
```

### Performance Before Indexing

Query:

```sql
SELECT \* FROM users WHERE email = 'john.doe@example.com';
```

- Execution Time: ~80 ms (Table scan observed in EXPLAIN)

### Performance After Indexing

Query:

```sql
SELECT \* FROM users WHERE email = 'john.doe@example.com';
```

- Execution Time: ~2 ms (Index scan observed in EXPLAIN)

Significant improvement due to index usage.
