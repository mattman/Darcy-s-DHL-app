# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100518104803) do

  create_table "administrators", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.string   "address"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivered_notices", :force => true do |t|
    t.integer  "package_id"
    t.integer  "tag_sequence"
    t.string   "status"
    t.datetime "recorded_at"
    t.decimal  "lat",          :precision => 15, :scale => 10
    t.decimal  "lng",          :precision => 15, :scale => 10
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "intransit_notices", :force => true do |t|
    t.integer  "package_id"
    t.integer  "tag_sequence"
    t.string   "status"
    t.datetime "recorded_at"
    t.decimal  "lat",          :precision => 15, :scale => 10
    t.decimal  "lng",          :precision => 15, :scale => 10
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string   "description"
    t.string   "serial_number"
    t.integer  "customer_id"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
