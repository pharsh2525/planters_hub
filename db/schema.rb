# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_01_105006) do
  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "address"
    t.string "city"
    t.string "postal_code"
    t.integer "province_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_addresses_on_province_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "plant_id", null: false
    t.integer "quantity"
    t.decimal "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["plant_id"], name: "index_order_items_on_plant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.string "status"
    t.string "payment_confirmation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plant_images", force: :cascade do |t|
    t.integer "plant_id", null: false
    t.string "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_plant_images_on_plant_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_plants_on_category_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.decimal "PST"
    t.decimal "GST"
    t.decimal "HST"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "provinces"
  add_foreign_key "addresses", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "plants"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "plant_images", "plants"
  add_foreign_key "plants", "categories"
end
