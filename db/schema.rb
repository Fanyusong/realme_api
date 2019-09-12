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

ActiveRecord::Schema.define(version: 2019_09_12_103119) do

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "name"
    t.text "address"
    t.boolean "game_1", default: false
    t.boolean "game_2", default: false
    t.boolean "game_3", default: false
    t.boolean "is_received_email", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "identify"
    t.integer "lives", default: 3
    t.date "sharing_day"
    t.boolean "game_4", default: false
    t.boolean "game_5", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

end
