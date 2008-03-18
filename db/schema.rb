# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "nickname"
    t.string   "password_salt",    :limit => 40
    t.string   "password_hash",    :limit => 40
    t.string   "email"
    t.text     "biography"
    t.datetime "last_login_at"
    t.datetime "last_seen_at"
    t.string   "token"
    t.datetime "token_expires_at"
    t.boolean  "admin",                          :default => false
    t.boolean  "activated",                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
