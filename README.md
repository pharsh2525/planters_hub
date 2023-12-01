# PlantersHub E-commerce Platform

## Introduction
PlantersHub is a boutique online plant shop based in Winnipeg, Manitoba. Established in 2015, our mission is to provide plant enthusiasts and home gardeners with a diverse selection of indoor plants, gardening tools, and decor items. Our e-commerce platform extends our reach beyond the local markets, offering the same quality and expertise online.

## Features
- User authentication and admin dashboard for product management.
- Product listing with detailed descriptions and images.
- Shopping cart and checkout functionality.
- Canadian address management with province-based tax calculations.

## Database Structure
Our platform's database consists of the following key entities:

### Users
- Stores customer and admin information for authentication purposes.
- Fields: `user_id`, `email`, `first_name`, `last_name`, `is_admin`, `password`.

### Addresses
- Tracks user addresses for shipping and billing.
- Fields: `address_id`, `user_id`, `address`, `city`, `postal_code`, `province_id`.

### Provinces
- Manages Canadian provinces and applicable tax rates.
- Fields: `province_id`, `province_name`, `tax_rate`.

### Orders
- Records customer orders, their status, and payment confirmations.
- Fields: `order_id`, `user_id`, `address_id`, `status`, `payment_confirmation`.

### OrderItems
- Details the items within each order, including quantity and price.
- Fields: `order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`.

### Products
- Lists products for sale, including pricing and stock levels.
- Fields: `product_id`, `name`, `description`, `price`, `stock`, `category_id`.

### ProductImages
- Associates multiple images with each product.
- Fields: `image_id`, `product_id`, `image_url`.

### Categories
- Organizes products into categories.
- Fields: `category_id`, `category_name`.

## Associations
- Users have many Addresses and Orders.
- Addresses belong to Users and Provinces, and have many Orders.
- Orders belong to Users and Addresses and have many OrderItems.
- OrderItems belong to Orders and Products.
- Products have many OrderItems and belong to Categories.
- ProductImages belong to Products.
- Categories have many Products.

## Setup
To get started with the project:

1. Clone the repository to your local machine.
2. Run `bundle install` to install dependencies.
3. Run `rails db:create db:migrate db:seed` to set up the database.
4. Run `rails server` to start the application.

## Contributions
As this is a project for educational purposes, contributions, suggestions, and feedback are welcome. Please feel free to submit issues and pull requests.
### The data in this project has been scrapped from https://piante.ca/ *For educational purposes.

## License
This project is open-sourced under the [MIT license](LICENSE.txt).
