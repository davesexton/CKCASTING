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

ActiveRecord::Schema.define(:version => 20111120195131) do

  create_table "castbooks", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "credits", :force => true do |t|
    t.integer  "Person_id"
    t.integer  "display_order"
    t.string   "credit_text"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "credits", ["Person_id"], :name => "index_credits_on_Person_id"

  create_table "eye_colours", :force => true do |t|
    t.string   "eye_colour"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hair_colours", :force => true do |t|
    t.string   "hair_colour"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.integer  "height_feet"
    t.integer  "height_inches"
    t.string   "hair_colour"
    t.string   "eye_colour"
    t.string   "gender"
    t.string   "postcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "telephone_number"
    t.string   "email_address"
    t.string   "status",           :default => "Active"
    t.datetime "last_viewed_at"
    t.integer  "view_count"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "skills", :force => true do |t|
    t.integer  "Person_id"
    t.integer  "display_order"
    t.string   "skill_text"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "skills", ["Person_id"], :name => "index_skills_on_Person_id"

end
