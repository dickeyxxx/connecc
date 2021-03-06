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

ActiveRecord::Schema.define(:version => 20110206211934) do

  create_table "cards", :force => true do |t|
    t.string    "code",                          :null => false
    t.integer   "order_id",                      :null => false
    t.text      "message"
    t.boolean   "visited",    :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "cards", ["code"], :name => "index_cards_on_code"
  add_index "cards", ["order_id"], :name => "index_cards_on_order_id"
  add_index "cards", ["updated_at"], :name => "index_cards_on_updated_at"
  add_index "cards", ["visited"], :name => "index_cards_on_visited"

  create_table "contact_requests", :force => true do |t|
    t.integer   "card_id",                           :null => false
    t.string    "email",                             :null => false
    t.text      "message",                           :null => false
    t.string    "ip_address",                        :null => false
    t.boolean   "send_me_a_copy", :default => false, :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "contact_requests", ["card_id"], :name => "index_contact_requests_on_card_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at"
    t.timestamp "locked_at"
    t.timestamp "failed_at"
    t.text      "locked_by"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "notification_requests", :force => true do |t|
    t.integer   "card_id",    :null => false
    t.string    "email",      :null => false
    t.string    "ip_address", :null => false
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "notification_requests", ["card_id"], :name => "index_notification_requests_on_card_id"
  add_index "notification_requests", ["email"], :name => "index_notification_requests_on_email"

  create_table "orders", :force => true do |t|
    t.string    "type",                                    :null => false
    t.integer   "user_id",                                 :null => false
    t.string    "state",                                   :null => false
    t.string    "first_name",                              :null => false
    t.string    "last_name",                               :null => false
    t.string    "company_name"
    t.string    "address1",                                :null => false
    t.string    "address2"
    t.string    "city",                                    :null => false
    t.string    "postal_code",                             :null => false
    t.string    "region",                                  :null => false
    t.boolean   "charged",              :default => false, :null => false
    t.boolean   "shipped",              :default => false, :null => false
    t.string    "canceled"
    t.decimal   "authorization_amount", :default => 0.0,   :null => false
    t.string    "google_order_number"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "orders", ["google_order_number"], :name => "index_orders_on_google_order_number"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",                           :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",                           :null => false
    t.string   "password_salt",                       :default => "",                           :null => false
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
    t.boolean  "admin",                               :default => false,                        :null => false
    t.string   "first_name",                                                                    :null => false
    t.string   "last_name",                                                                     :null => false
    t.string   "company_name"
    t.string   "time_zone",                           :default => "Pacific Time (US & Canada)", :null => false
    t.string   "gender",               :limit => 1,   :default => "m",                          :null => false
    t.string   "phone_number"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "facebook"
    t.string   "web_site"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
