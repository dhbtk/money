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

ActiveRecord::Schema.define(version: 20161201180800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "expiration"
    t.string   "type"
    t.integer  "closing"
    t.decimal  "interest",   precision: 8, scale: 4
    t.decimal  "fine",       precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.decimal  "limit",      precision: 8, scale: 2
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "recurring_credits", force: :cascade do |t|
    t.string   "name"
    t.integer  "months"
    t.decimal  "value",      precision: 8, scale: 2
    t.integer  "account_id"
    t.integer  "expiration"
    t.decimal  "interest",   precision: 8, scale: 2
    t.decimal  "fine",       precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "start_date"
    t.index ["account_id"], name: "index_recurring_credits_on_account_id", using: :btree
  end

  create_table "recurring_debits", force: :cascade do |t|
    t.string   "name"
    t.integer  "months"
    t.integer  "day"
    t.decimal  "value",      precision: 8, scale: 2
    t.integer  "account_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["account_id"], name: "index_recurring_debits_on_account_id", using: :btree
  end

  create_table "revisions", force: :cascade do |t|
    t.string   "model_type"
    t.integer  "model_id"
    t.integer  "revision_type"
    t.json     "data"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["model_type", "model_id"], name: "index_revisions_on_model_type_and_model_id", using: :btree
  end

  create_table "statements", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "date"
    t.decimal  "value",               precision: 8, scale: 2
    t.integer  "account_id"
    t.integer  "recurring_credit_id"
    t.integer  "tag_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["account_id"], name: "index_statements_on_account_id", using: :btree
    t.index ["recurring_credit_id"], name: "index_statements_on_recurring_credit_id", using: :btree
    t.index ["tag_id"], name: "index_statements_on_tag_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "icon"
    t.index ["user_id"], name: "index_tags_on_user_id", using: :btree
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "debit_id"
    t.integer  "credit_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["credit_id"], name: "index_transfers_on_credit_id", using: :btree
    t.index ["debit_id"], name: "index_transfers_on_debit_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "recurring_credits", "accounts"
  add_foreign_key "recurring_debits", "accounts"
  add_foreign_key "statements", "accounts"
  add_foreign_key "statements", "recurring_credits"
  add_foreign_key "statements", "tags"
  add_foreign_key "tags", "users"
  add_foreign_key "transfers", "statements", column: "credit_id"
  add_foreign_key "transfers", "statements", column: "debit_id"
end
