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

ActiveRecord::Schema.define(version: 20140523172938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_settings", force: true do |t|
    t.string   "key",                     null: false
    t.string   "value",      limit: 1024, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["key"], name: "index_app_settings_on_key", unique: true, using: :btree

  create_table "flags", force: true do |t|
    t.string   "name",       limit: 25,  null: false
    t.string   "desc",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["name"], name: "index_flags_on_name", unique: true, using: :btree

  create_table "flags_words", force: true do |t|
    t.integer "word_id"
    t.integer "flag_id"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",             limit: 15,               null: false
    t.string   "last_name",              limit: 15,               null: false
    t.string   "type"
    t.string   "provider"
    t.string   "uid"
    t.string   "additional_info",        limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "words", force: true do |t|
    t.string   "word",            limit: 25,   null: false
    t.string   "trick",           limit: 100
    t.integer  "user_id"
    t.string   "additional_info", limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "words", ["user_id"], name: "index_words_on_user_id", using: :btree
  add_index "words", ["word"], name: "index_words_on_word", unique: true, using: :btree

end
