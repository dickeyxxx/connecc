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

ActiveRecord::Schema.define(:version => 20101225181925) do

  create_table "cards", :force => true do |t|
    t.string   "code",       :null => false
    t.integer  "order_id",   :null => false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["code"], :name => "index_cards_on_code"
  add_index "cards", ["order_id"], :name => "index_cards_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.string   "type",         :default => "Order", :null => false
    t.integer  "cards_amount",                      :null => false
    t.datetime "placed_at",                         :null => false
    t.datetime "generated_at"
    t.datetime "shipped_at"
    t.string   "status",                            :null => false
    t.string   "address",                           :null => false
    t.string   "city",                              :null => false
    t.string   "state",                             :null => false
    t.string   "zip",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "admin",                               :default => false, :null => false
    t.string   "first_name",                                             :null => false
    t.string   "last_name",                                              :null => false
    t.boolean  "show_email",                          :default => true,  :null => false
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "card_id",                   :null => false
    t.string   "ip_address",                :null => false
    t.integer  "count",      :default => 1, :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["card_id"], :name => "index_visits_on_card_id"
  add_index "visits", ["ip_address"], :name => "index_visits_on_ip_address"
  add_index "visits", ["updated_at"], :name => "index_visits_on_updated_at"
  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

end
