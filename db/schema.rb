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

ActiveRecord::Schema.define(:version => 20120720183256) do

  create_table "clients", :force => true do |t|
    t.string   "account_name",  :null => false
    t.string   "contact_name",  :null => false
    t.string   "contact_email", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "issue_types", :force => true do |t|
    t.string   "label",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "title",         :null => false
    t.string   "description",   :null => false
    t.integer  "issue_type_id", :null => false
    t.integer  "user_id",       :null => false
    t.integer  "client_id",     :null => false
    t.datetime "closed_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "kong_users", :force => true do |t|
    t.string   "username",        :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                           :null => false
    t.string   "email",                              :null => false
    t.string   "password_digest",                    :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "client_id"
    t.boolean  "superadmin",      :default => false, :null => false
  end

end
