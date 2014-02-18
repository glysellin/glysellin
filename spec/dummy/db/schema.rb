# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140218165003) do

  create_table "glysellin_addresses", force: true do |t|
    t.boolean  "activated",                default: true
    t.boolean  "company"
    t.string   "company_name"
    t.string   "vat_number"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.text     "address_details"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "tel"
    t.string   "fax"
    t.text     "additional_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipped_addressable_type"
    t.integer  "shipped_addressable_id"
    t.string   "billed_addressable_type"
    t.integer  "billed_addressable_id"
  end

  create_table "glysellin_brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "glysellin_customers", force: true do |t|
    t.string   "email",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "glysellin_customers", ["email"], name: "index_glysellin_customers_on_email", unique: true

  create_table "glysellin_discount_codes", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "discount_type_id"
    t.decimal  "value",            precision: 11, scale: 2
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glysellin_discount_codes", ["code"], name: "index_glysellin_discount_codes_on_code"

  create_table "glysellin_discount_types", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glysellin_line_items", force: true do |t|
    t.string   "sku"
    t.string   "name"
    t.decimal  "eot_price",  precision: 11, scale: 2
    t.decimal  "price",      precision: 11, scale: 2
    t.decimal  "vat_rate",   precision: 11, scale: 2
    t.integer  "quantity"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "weight",     precision: 11, scale: 3
    t.integer  "variant_id"
  end

  create_table "glysellin_order_adjustments", force: true do |t|
    t.string   "name"
    t.decimal  "value",           precision: 11, scale: 2
    t.integer  "order_id"
    t.integer  "adjustment_id"
    t.string   "adjustment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glysellin_orders", force: true do |t|
    t.string   "ref"
    t.string   "status"
    t.datetime "paid_on"
    t.integer  "customer_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shipping_method_id"
  end

  create_table "glysellin_payment_methods", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glysellin_payments", force: true do |t|
    t.string   "status"
    t.integer  "type_id"
    t.integer  "order_id"
    t.datetime "last_payment_action_on"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glysellin_product_images", force: true do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "glysellin_product_properties", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_id"
    t.integer  "variant_id"
  end

  create_table "glysellin_product_property_types", force: true do |t|
    t.string "name"
  end

  create_table "glysellin_products", force: true do |t|
    t.decimal  "vat_rate",      precision: 11, scale: 2
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sellable_type"
    t.integer  "sellable_id"
  end

  create_table "glysellin_shipping_methods", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glysellin_shipping_methods", ["identifier"], name: "index_glysellin_shipping_methods_on_identifier"

  create_table "glysellin_variants", force: true do |t|
    t.string   "sku"
    t.string   "name"
    t.string   "slug"
    t.decimal  "eot_price",       precision: 11, scale: 2
    t.decimal  "price",           precision: 11, scale: 2
    t.integer  "in_stock",                                 default: 0
    t.boolean  "unlimited_stock",                          default: false
    t.boolean  "published",                                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "weight"
    t.decimal  "unmarked_price",  precision: 11, scale: 2
    t.integer  "sellable_id"
    t.string   "sellable_type"
  end

end
