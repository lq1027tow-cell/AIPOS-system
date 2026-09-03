# AI Camera POS System

A beginner-friendly PHP 8+, MySQL, vanilla JavaScript POS for a small shop. Gemini identifies product names and quantities only; all product details come from MySQL.

## Setup
1. Create the database, users, categories, settings, and demo products by importing `database.sql`.
2. Copy `.env.example` to `.env` and update database or shop settings there. A working local `.env` is already included for this XAMPP setup.
3. Start locally from this folder: `php -S localhost:8000`.
4. Open `http://localhost:8000`, then log in with `admin` / `123456`.

The seeded cashier account is `cashier` / `123456`. Admins land on Dashboard; cashiers land directly on POS.

`.env` supports `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`, `SHOP_NAME`, and `GEMINI_CA_BUNDLE`. Keep API keys in the admin Settings page; do not put them in source control.

## Gemini configuration
Log in as admin, open Settings, enter a Gemini API key and select one of the supported models. The Test AI Connection button calls Gemini with a tiny text prompt. Camera detection sends a base64 image to Gemini and requests strict JSON containing only `name` and `quantity`. Matching, pricing, stock, and product creation remain server-side.

For camera access, use localhost or HTTPS. Add products and stock before testing. Cashiers can manually search products if Gemini returns an unknown item. Checkout runs in a transaction, validates stock again, saves the order and line items, and deducts inventory.
