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

ActiveRecord::Schema.define(version: 2020_09_07_082442) do

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
    t.text "game_1"
    t.text "game_2"
    t.boolean "is_received_email", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "identify"
    t.integer "lives", default: 1
    t.date "sharing_day"
    t.integer "coin", default: 0
    t.string "password"
    t.string "username"
    t.text "game_3"
    t.boolean "game_5", default: false
    t.float "game_1_float", default: 0.0
    t.float "game_2_float", default: 0.0
    t.float "game_3_float", default: 0.0
    t.float "game_4_float", default: 0.0
    t.float "total", default: 0.0
    t.text "game_4"
    t.float "total_time"
    t.integer "rank"
    t.float "prev_game1", default: 0.0
    t.float "prev_game2", default: 0.0
    t.float "prev_game3", default: 0.0
    t.float "prev_game4", default: 0.0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
