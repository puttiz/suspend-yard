# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 1) do

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "nickname"
    t.string   "password_salt",    :limit => 40
    t.string   "password_hash",    :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.datetime "last_seen_at"
    t.string   "token"
    t.datetime "token_expires_at"
    t.boolean  "admin",                          :default => false
    t.boolean  "activated",                      :default => false
    t.string   "email"
    t.text     "biography"
  end

end
