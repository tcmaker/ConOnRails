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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120429052751) do

  create_table "contacts", :force => true do |t|
    t.string "name"
    t.string "department"
    t.string "cell_phone"
    t.string "hotel"
    t.integer "hotel_room"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "events", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_active", :default => true
    t.boolean "comment", :default => false
    t.boolean "flagged", :default => false
    t.boolean "post_con", :default => false
    t.boolean "quote", :default => false
    t.boolean "sticky", :default => false
    t.boolean "emergency", :default => false
    t.boolean "medical", :default => false
    t.boolean "hidden", :default => false
    t.boolean "secure", :default => false
    t.boolean "consuite"
    t.boolean "hotel"
    t.boolean "parties"
    t.boolean "volunteers"
    t.boolean "dealers"
    t.boolean "dock"
    t.boolean "merchandise"
  end

  create_table "lost_and_found_items", :force => true do |t|
    t.string "category"
    t.string "description"
    t.text "details"
    t.string "where_last_seen"
    t.string "where_found"
    t.string "owner_name"
    t.text "owner_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "found", :default => false
    t.boolean "returned", :default => false
    t.boolean "reported_missing", :default => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.boolean "write_entries"
    t.boolean "read_hidden_entries"
    t.boolean "add_lost_and_found"
    t.boolean "modify_lost_and_found"
    t.boolean "admin_radios"
    t.boolean "assign_radios"
    t.boolean "admin_users"
    t.boolean "admin_schedule"
    t.boolean "assign_shifts"
    t.boolean "assign_duty_board_slots"
    t.boolean "admin_duty_board"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "realname"
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
