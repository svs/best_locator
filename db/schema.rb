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

ActiveRecord::Schema.define(version: 20131129131505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "location_reports", force: true do |t|
    t.integer  "trip_id"
    t.float    "lat"
    t.float    "lon"
    t.float    "heading"
    t.float    "speed"
    t.float    "accuracy"
    t.datetime "reported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_squares", force: true do |t|
    t.float    "lat1"
    t.float    "lon1"
    t.float    "lat2"
    t.float    "lon2"
    t.string   "index"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", force: true do |t|
    t.string   "code"
    t.string   "end_area"
    t.string   "start_stop"
    t.string   "start_area"
    t.string   "display_name"
    t.string   "url"
    t.string   "slug"
    t.string   "end_stop"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes_stops", id: false, force: true do |t|
    t.integer "route_id", null: false
    t.integer "stop_id",  null: false
  end

  add_index "routes_stops", ["route_id"], name: "index_routes_stops_on_route_id", using: :btree
  add_index "routes_stops", ["stop_id"], name: "index_routes_stops_on_stop_id", using: :btree

  create_table "stops", force: true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.string   "code"
    t.string   "official_name"
    t.string   "display_name"
    t.string   "url"
    t.json     "route_names"
    t.string   "slug"
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", force: true do |t|
    t.integer  "user_id"
    t.string   "bus_number"
    t.integer  "start_stop_id"
    t.string   "start_stop_name"
    t.integer  "start_stop_code"
    t.integer  "end_stop_id"
    t.string   "end_stop_name"
    t.integer  "end_stop_code"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "status",          default: "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "username"
    t.string   "auth_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
