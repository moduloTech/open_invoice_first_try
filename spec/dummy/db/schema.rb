# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_27_052155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "open_invoice_admin_tokens", force: :cascade do |t|
    t.string "name", null: false
    t.uuid "token", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "open_invoice_admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_open_invoice_admins_on_email", unique: true
  end

  create_table "open_invoice_invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoice_number"
    t.string "subject"
    t.datetime "due_date"
    t.string "original_file"
    t.decimal "amount_vat_excluded", precision: 10, scale: 2, null: false
    t.decimal "amount_vat_included", precision: 10, scale: 2, null: false
    t.string "secure_key", limit: 20, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "open_invoice_links", force: :cascade do |t|
    t.uuid "invoice_id", null: false
    t.uuid "recipient_id", null: false
    t.datetime "created_at", null: false
    t.index ["invoice_id", "recipient_id"], name: "index_open_invoice_links_on_invoice_id_and_recipient_id", unique: true
    t.index ["recipient_id"], name: "index_open_invoice_links_on_recipient_id"
  end

  create_table "open_invoice_recipients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "api_token", default: -> { "gen_random_uuid()" }, null: false
    t.index ["api_token"], name: "index_open_invoice_recipients_on_api_token", unique: true
    t.index ["email"], name: "index_open_invoice_recipients_on_email", unique: true
    t.index ["public_id"], name: "index_open_invoice_recipients_on_public_id", unique: true
  end

  create_table "open_invoice_visits", force: :cascade do |t|
    t.uuid "invoice_id", null: false
    t.uuid "recipient_id", null: false
    t.datetime "created_at", null: false
    t.index ["invoice_id"], name: "index_open_invoice_visits_on_invoice_id"
    t.index ["recipient_id"], name: "index_open_invoice_visits_on_recipient_id"
  end

end
