# Database Seed Data

This directory (`database-script-0x02`) contains SQL scripts to populate the database with sample data, reflecting real-world usage scenarios. The scripts assume the database schema defined in `schema.sql` has been executed.

## File: `seed.sql`

The `seed.sql` file contains `INSERT` statements to populate the following tables:
- **User**: Users with different roles (guest, host, admin).
- **Property**: Properties hosted by users with role 'host'.
- **Booking**: Bookings made by guests for properties, with varying statuses.
- **Payment**: Payments associated with bookings, using different payment methods.
- **Review**: Reviews submitted by users for properties.
- **Message**: Messages exchanged between users (e.g., guest-host communication).

### Sample Data Overview
- **Users**:
  - 5 users: 2 guests, 2 hosts, 1 admin.
  - Example: John Doe (guest), Jane Smith (host), Admin User (admin).
- **Properties**:
  - 3 properties owned by hosts (Jane Smith and Bob Brown).
  - Example: Cozy Beach Cottage in Miami, Downtown Loft in New York, Mountain Cabin in Denver.
- **Bookings**:
  - 3 bookings with statuses 'confirmed', 'pending', and 'canceled'.
  - Example: John books the Beach Cottage for 4 nights, Alice books the Loft for 2 nights.
- **Payments**:
  - 3 payments for two bookings, using credit card, PayPal, and Stripe.
  - Example: Two payments for John’s booking (partial and full).
- **Reviews**:
  - 2 reviews for properties by guests.
  - Example: John rates the Beach Cottage 5 stars, Alice rates the Loft 4 stars.
- **Messages**:
  - 3 messages between guests and hosts.
  - Example: John asks Jane about the Beach Cottage availability, Jane responds.

### Usage
To populate the database, execute the `seed.sql` script after creating the schema:
```bash
mysql -u <username> -p <database_name> < seed.sql