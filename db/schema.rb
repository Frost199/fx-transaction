# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_09_115203) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fx_transactions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "transaction_id", null: false
    t.decimal "input_amount", precision: 32, scale: 16, null: false
    t.string "input_currency", null: false
    t.decimal "output_amount", precision: 32, scale: 16, null: false
    t.string "output_currency", null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_fx_transactions_on_customer_id"
    t.index ["transaction_id"], name: "index_fx_transactions_on_transaction_id"
  end

end
