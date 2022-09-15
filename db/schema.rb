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

ActiveRecord::Schema.define(version: 2022_09_08_104701) do

  create_table "bookings", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "listing_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id", "start_date", "end_date"], name: "index_bookings_on_listing_id_and_start_date_and_end_date", unique: true
    t.index ["listing_id"], name: "index_bookings_on_listing_id"
  end

  create_table "listings", force: :cascade do |t|
    t.integer "num_rooms", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "missions", force: :cascade do |t|
    t.date "date", null: false
    t.integer "mission_type", default: 0, null: false
    t.float "price", null: false
    t.integer "listing_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_missions_on_listing_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "listing_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id", "start_date", "end_date"], name: "index_reservations_on_listing_id_and_start_date_and_end_date", unique: true
    t.index ["listing_id"], name: "index_reservations_on_listing_id"
  end

  add_foreign_key "bookings", "listings"
  add_foreign_key "missions", "listings"
  add_foreign_key "reservations", "listings"
end
