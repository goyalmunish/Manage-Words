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

ActiveRecord::Schema.define(version: 20200612080730) do

  create_table "app_settings", force: :cascade do |t|
    t.string   "key",        limit: 255,  null: false
    t.string   "value",      limit: 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["key"], name: "index_app_settings_on_key", unique: true, using: :btree

  create_table "dictionaries", force: :cascade do |t|
    t.string   "name",            limit: 25,  null: false
    t.string   "url",             limit: 150, null: false
    t.string   "separator",       limit: 5,   null: false
    t.string   "suffix",          limit: 25
    t.string   "additional_info", limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dictionaries", ["name"], name: "index_dictionaries_on_name", unique: true, using: :btree

  create_table "dictionaries_users", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "dictionary_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dictionaries_users", ["user_id", "dictionary_id"], name: "index_dictionaries_users_on_user_id_and_dictionary_id", unique: true, using: :btree

  create_table "flags", force: :cascade do |t|
    t.string   "name",       limit: 5,   null: false
    t.integer  "value",      limit: 4,   null: false
    t.string   "desc",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["name", "value"], name: "index_flags_on_name_and_value", unique: true, using: :btree

  create_table "flags_words", force: :cascade do |t|
    t.integer  "word_id",    limit: 4
    t.integer  "flag_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags_words", ["word_id", "flag_id"], name: "index_flags_words_on_word_id_and_flag_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 15,               null: false
    t.string   "last_name",              limit: 15,               null: false
    t.string   "type",                   limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "additional_info",        limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "authentication_token",   limit: 255
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "word",            limit: 25,   null: false
    t.string   "trick",           limit: 100
    t.integer  "user_id",         limit: 4,    null: false
    t.string   "additional_info", limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",            limit: 255
  end

  add_index "words", ["slug"], name: "index_words_on_slug", unique: true, using: :btree
  add_index "words", ["user_id", "word"], name: "index_words_on_user_id_and_word", unique: true, using: :btree
  add_index "words", ["user_id"], name: "index_words_on_user_id", using: :btree

end
