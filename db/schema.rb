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

ActiveRecord::Schema.define(version: 20181114134749) do

  create_table "attendances", force: :cascade do |t|
    t.datetime "attendance_time"
    t.datetime "leaving_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "day"
    t.datetime "attendance_time_edit"
    t.datetime "leaving_time_edit"
    t.text "remarks"
    t.integer "user_id"
    t.datetime "expected_end_time"
    t.text "business_content"
  end

  create_table "basic_infos", force: :cascade do |t|
    t.time "basic_work_time"
    t.time "specified_work_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "affiliation"
    t.datetime "attendance_time"
    t.datetime "leaving_time"
    t.date "day"
    t.datetime "attendance_time_edit"
    t.datetime "leaving_time_edit"
    t.text "remarks"
    t.time "basic_work_time"
    t.time "specified_work_time"
    t.string "card_id"
    t.time "specified_work_start_time"
    t.time "specified_work_end_time"
    t.integer "employee_number"
    t.datetime "expected_end_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
