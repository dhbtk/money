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

ActiveRecord::Schema.define(version: 20170322225119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "expiration"
    t.string "type"
    t.integer "closing"
    t.decimal "interest", precision: 8, scale: 4
    t.decimal "fine", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.decimal "limit", precision: 8, scale: 2
    t.string "icon"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "billing_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_billing_accounts_on_user_id"
  end

  create_table "bills", id: :serial, force: :cascade do |t|
    t.integer "billing_account_id"
    t.string "name"
    t.decimal "value"
    t.datetime "expiration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credit_id"
    t.string "barcode"
    t.string "attachment"
    t.index ["billing_account_id"], name: "index_bills_on_billing_account_id"
    t.index ["credit_id"], name: "index_bills_on_credit_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "icon"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "recurring_credits", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "months"
    t.decimal "value", precision: 8, scale: 2
    t.integer "account_id"
    t.integer "expiration"
    t.decimal "interest", precision: 8, scale: 2
    t.decimal "fine", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.integer "category_id"
    t.index ["account_id"], name: "index_recurring_credits_on_account_id"
    t.index ["category_id"], name: "index_recurring_credits_on_category_id"
  end

  create_table "recurring_debits", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "months"
    t.integer "day"
    t.decimal "value", precision: 8, scale: 2
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_recurring_debits_on_account_id"
  end

  create_table "statements", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.datetime "date"
    t.decimal "value", precision: 8, scale: 2
    t.integer "account_id"
    t.integer "recurring_credit_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_statements_on_account_id"
    t.index ["category_id"], name: "index_statements_on_category_id"
    t.index ["recurring_credit_id"], name: "index_statements_on_recurring_credit_id"
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "debit_id"
    t.integer "credit_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_id"], name: "index_transfers_on_credit_id"
    t.index ["debit_id"], name: "index_transfers_on_debit_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "image"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "billing_accounts", "users"
  add_foreign_key "bills", "billing_accounts"
  add_foreign_key "bills", "statements", column: "credit_id"
  add_foreign_key "categories", "users"
  add_foreign_key "recurring_credits", "accounts"
  add_foreign_key "recurring_credits", "categories"
  add_foreign_key "recurring_debits", "accounts"
  add_foreign_key "statements", "accounts"
  add_foreign_key "statements", "categories"
  add_foreign_key "statements", "recurring_credits"
  add_foreign_key "transfers", "statements", column: "credit_id"
  add_foreign_key "transfers", "statements", column: "debit_id"
end
