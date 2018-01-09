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

ActiveRecord::Schema.define(version: 20180106235927) do

  create_table "assets", force: :cascade do |t|
    t.integer "sec"
    t.decimal "volume", precision: 13, scale: 4
    t.integer "portfolio_id"
    t.text "ticker"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id", "created_at", "updated_at"], name: "index_assets_on_portfolio_id_and_created_at_and_updated_at"
    t.index ["portfolio_id"], name: "index_assets_on_portfolio_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "executes", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "securityID"
    t.integer "timeblock"
    t.decimal "volume", precision: 13, scale: 4
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id", "securityID"], name: "index_executes_on_portfolio_id_and_securityID"
    t.index ["portfolio_id"], name: "index_executes_on_portfolio_id"
  end

  create_table "interdays", force: :cascade do |t|
    t.integer "security_id"
    t.date "date"
    t.decimal "open", precision: 12, scale: 2
    t.decimal "close", precision: 12, scale: 2
    t.decimal "high", precision: 12, scale: 2
    t.decimal "low", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "security_id"], name: "index_interdays_on_date_and_security_id"
    t.index ["security_id"], name: "index_interdays_on_security_id"
  end

  create_table "intradays", force: :cascade do |t|
    t.integer "security_id"
    t.time "time"
    t.date "date"
    t.boolean "updated", default: false
    t.integer "cardinal360"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 12, scale: 2, default: "0.0", null: false
    t.index ["security_id", "created_at"], name: "index_intradays_on_security_id_and_created_at"
    t.index ["security_id"], name: "index_intradays_on_security_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.decimal "pType", precision: 1, default: "1", null: false
    t.decimal "TOI", precision: 18, scale: 8, default: "1.0", null: false
    t.decimal "cashAUD", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_portfolios_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "securities", force: :cascade do |t|
    t.text "ticker"
    t.text "title"
    t.text "description"
    t.decimal "price", precision: 8, scale: 4
    t.decimal "expreturn", precision: 7, scale: 6
    t.decimal "stddev", precision: 7, scale: 6
    t.decimal "idiosync", precision: 7, scale: 6
    t.decimal "dividend", precision: 8, scale: 4
    t.decimal "divyield", precision: 7, scale: 6
    t.bigint "numshares"
    t.decimal "mktcorr", precision: 7, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.decimal "balanceAUD", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "initial_investment", precision: 12, scale: 2, default: "0.0", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
