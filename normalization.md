# Database Normalization to Third Normal Form (3NF)

## Step 1: Check for First Normal Form (1NF)

### Requirements
- All attributes must be atomic (no multi-valued attributes or repeating groups).
- Each table must have a primary key.

### Analysis
- All tables (`User`, `Property`, `Booking`, `Payment`, `Review`, `Message`) have a primary key (e.g., `user_id`, `property_id`, etc.).
- All attributes are atomic:
  - **User**: Attributes like `first_name`, `email`, and `role` (ENUM) are single-valued.
  - **Property**: `location`, `pricepernight`, etc., are atomic.
  - **Booking**: `start_date`, `end_date`, `total_price`, and `status` (ENUM) are atomic.
  - **Payment**: `amount`, `payment_method` (ENUM), etc., are atomic.
  - **Review**: `rating` (constrained to 1-5) and `comment` are atomic.
  - **Message**: `message_body` and `sent_at` are atomic.
- No repeating groups are present.

### Conclusion
The schema is in **1NF** because all attributes are atomic, and each table has a primary key.

## Step 2: Check for Second Normal Form (2NF)

### Requirements
- The schema must be in 1NF.
- All non-key attributes must fully depend on the entire primary key (no partial dependencies).

### Analysis
- All tables have a single-column primary key (`user_id`, `property_id`, `booking_id`, etc.), so partial dependencies are not applicable, as there are no composite keys.
- Each non-key attribute in every table depends fully on its primary key:
  - **User**: `first_name`, `last_name`, `email`, etc., depend on `user_id`.
  - **Property**: `host_id`, `name`, `description`, etc., depend on `property_id`.
  - **Booking**: `property_id`, `user_id`, `start_date`, etc., depend on `booking_id`.
  - **Payment**: `booking_id`, `amount`, `payment_method`, etc., depend on `payment_id`.
  - **Review**: `property_id`, `user_id`, `rating`, etc., depend on `review_id`.
  - **Message**: `sender_id`, `recipient_id`, `message_body`, etc., depend on `message_id`.

### Conclusion
The schema is in **2NF** because there are no composite keys, and all non-key attributes depend on their respective primary keys.

## Step 3: Check for Third Normal Form (3NF)

### Requirements
- The schema must be in 2NF.
- No non-key attribute depends on another non-key attribute (no transitive dependencies).

### Analysis
We check each table for transitive dependencies, where a non-key attribute depends on another non-key attribute through the primary key.

#### User Table
- **Non-key attributes**: `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`.
- **Check**: Do any of these depend on each other rather than directly on `user_id`?
  - `email` is unique and does not depend on other non-key attributes.
  - `first_name`, `last_name`, `phone_number`, `password_hash`, and `role` are independent and tied to the user’s identity (`user_id`).
  - `created_at` is a timestamp set at record creation and depends only on `user_id`.
- **Finding**: No transitive dependencies. All attributes depend directly on `user_id`.

#### Property Table
- **Non-key attributes**: `host_id`, `name`, `description`, `location`, `pricepernight`, `created_at`, `updated_at`.
- **Check**: Do any of these depend on each other?
  - `host_id` is a foreign key referencing `User(user_id)` and does not depend on other non-key attributes.
  - `name`, `description`, `location`, and `pricepernight` describe the property and depend on `property_id`.
  - `created_at` and `updated_at` are timestamps tied to the property record.
  - **Potential issue**: Could `location` (e.g., a city or address) introduce a transitive dependency if it includes structured data like city, state, or country? In this schema, `location` is a single VARCHAR field, assumed to be atomic (e.g., a full address string). If it were split into multiple fields (e.g., `city`, `state`), we’d need to check for dependencies like `city` → `state`.
- **Finding**: Assuming `location` is atomic, there are no transitive dependencies. All attributes depend on `property_id`.

#### Booking Table
- **Non-key attributes**: `property_id`, `user_id`, `start_date`, `end_date`, `total_price`, `status`, `created_at`.
- **Check**: Do any of these depend on each other?
  - `property_id` and `user_id` are foreign keys and depend on `booking_id`.
  - `start_date`, `end_date`, `status`, and `created_at` describe the booking and depend on `booking_id`.
  - **Potential issue**: `total_price` could depend on `start_date`, `end_date`, and the `pricepernight` from the Property table (e.g., `total_price = pricepernight * (end_date - start_date)`). This introduces a transitive dependency, as `total_price` is derived from non-key attributes (`start_date`, `end_date`) and an external attribute (`pricepernight`).
- **Finding**: `total_price` is a derived attribute, violating 3NF because it depends on `start_date`, `end_date`, and `Property.pricepernight` rather than solely on `booking_id`.

#### Payment Table
- **Non-key attributes**: `booking_id`, `amount`, `payment_date`, `payment_method`.
- **Check**: Do any of these depend on each other?
  - `booking_id` is a foreign key and depends on `payment_id`.
  - `amount`, `payment_date`, and `payment_method` describe the payment and depend on `payment_id`.
  - **Potential issue**: Could `amount` depend on `Booking.total_price`? The schema allows multiple payments per booking, so `amount` represents an individual payment and is independent in this context.
- **Finding**: No transitive dependencies. All attributes depend on `payment_id`.

#### Review Table
- **Non-key attributes**: `property_id`, `user_id`, `rating`, `comment`, `created_at`.
- **Check**: Do any of these depend on each other?
  - `property_id` and `user_id` are foreign keys and depend on `review_id`.
  - `rating`, `comment`, and `created_at` describe the review and depend on `review_id`.
- **Finding**: No transitive dependencies. All attributes depend on `review_id`.

#### Message Table
- **Non-key attributes**: `sender_id`, `recipient_id`, `message_body`, `sent_at`.
- **Check**: Do any of these depend on each other?
  - `sender_id` and `recipient_id` are foreign keys and depend on `message_id`.
  - `message_body` and `sent_at` describe the message and depend on `message_id`.
- **Finding**: No transitive dependencies. All attributes depend on `message_id`.

### Identified Issue
The primary issue is in the **Booking** table, where `total_price` is a derived attribute that depends on:
- `start_date` and `end_date` (non-key attributes in Booking).
- `pricepernight` (from the Property table).

This creates a transitive dependency: `booking_id` → `start_date`, `end_date`, `Property.pricepernight` → `total_price`. To achieve 3NF, we need to remove this dependency.

## Step 4: Normalize to 3NF

To eliminate the transitive dependency in the **Booking** table, we remove `total_price` since it can be calculated dynamically using `start_date`, `end_date`, and `Property.pricepernight`. Storing derived data violates 3NF and risks inconsistencies (e.g., if `pricepernight` changes, `total_price` may not be updated).

### Adjustments
- **Remove `total_price` from Booking**: Compute `total_price` dynamically using a query:
  ```sql
  SELECT 
    b.booking_id,
    (DATEDIFF(b.end_date, b.start_date) * p.pricepernight) AS total_price
  FROM Booking b
  JOIN Property p ON b.property_id = p.property_id;

## Final Normalized Schema (3NF)

The adjusted database schema in **Third Normal Form (3NF)**, with `total_price` removed from the `Booking` table to eliminate transitive dependencies.

## User
- **user_id**: Primary Key, UUID, Indexed
- **first_name**: VARCHAR, NOT NULL
- **last_name**: VARCHAR, NOT NULL
- **email**: VARCHAR, UNIQUE, NOT NULL
- **password_hash**: VARCHAR, NOT NULL
- **phone_number**: VARCHAR, NULL
- **role**: ENUM (guest, host, admin), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Property
- **property_id**: Primary Key, UUID, Indexed
- **host_id**: Foreign Key, references User(user_id)
- **name**: VARCHAR, NOT NULL
- **description**: TEXT, NOT NULL
- **location**: VARCHAR, NOT NULL
- **pricepernight**: DECIMAL, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

## Booking
- **booking_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **start_date**: DATE, NOT NULL
- **end_date**: DATE, NOT NULL
- **status**: ENUM (pending, confirmed, canceled), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Payment
- **payment_id**: Primary Key, UUID, Indexed
- **booking_id**: Foreign Key, references Booking(booking_id)
- **amount**: DECIMAL, NOT NULL
- **payment_date**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **payment_method**: ENUM (credit_card, paypal, stripe), NOT NULL

## Review
- **review_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **rating**: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
- **comment**: TEXT, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Message
- **message_id**: Primary Key, UUID, Indexed
- **sender_id**: Foreign Key, references User(user_id)
- **recipient_id**: Foreign Key, references User(user_id)
- **message_body**: TEXT, NOT NULL
- **sent_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

## Constraints
- **User**: Unique constraint on `email`.
- **Booking**: `status` must be one of `pending`, `confirmed`, or `canceled`.
- **Review**: `rating` must be between 1 and 5.
- **Foreign Keys**: Ensure referential integrity across tables.
- **Indexes**:
  - Primary keys (automatically indexed).
  - Additional indexes: `email` (User), `property_id` (Property, Booking), `booking_id` (Booking, Payment).