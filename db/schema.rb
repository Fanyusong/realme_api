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

ActiveRecord::Schema.define(version: 2020_09_08_174134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "errors", force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "name"
    t.text "address"
    t.boolean "is_received_email", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "identify"
    t.date "sharing_day"
    t.string "password"
    t.integer "rank"
    t.integer "current_total_time", default: 0
    t.boolean "is_qualified", default: false
    t.integer "total_time", default: 120000
    t.integer "game_1"
    t.integer "game_2"
    t.integer "game_3"
    t.integer "game_4"
    t.integer "prev_game_1", default: 30000
    t.integer "prev_game_2", default: 30000
    t.integer "prev_game_3", default: 30000
    t.integer "prev_game_4", default: 30000
    t.integer "game_1_lives", default: 2
    t.integer "game_2_lives", default: 2
    t.integer "game_3_lives", default: 2
    t.integer "game_4_lives", default: 2
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
