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

ActiveRecord::Schema.define(version: 20140625195338) do

  create_table "lti_security_engine_lti_launches", force: true do |t|
    t.integer  "security_contract_id"
    t.string   "nonce"
    t.text     "launch_params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lti_security_engine_security_contracts", force: true do |t|
    t.integer "vendor_id"
    t.string  "key"
    t.string  "shared_secret"
  end

  create_table "lti_security_engine_vendors", force: true do |t|
    t.string "code"
    t.string "vendor_name"
    t.text   "description"
    t.string "website"
    t.string "email"
  end

end
