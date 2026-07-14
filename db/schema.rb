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

ActiveRecord::Schema[8.0].define(version: 2026_07_14_095901) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "entries", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "user_id", null: false
    t.integer "playing_handicap"
    t.string "team"
    t.boolean "entered_cttp_front", default: false
    t.boolean "entered_cttp_back", default: false
    t.string "payment_status", default: "unpaid", null: false
    t.string "stripe_session_id"
    t.integer "amount_paid_pence", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_status"], name: "index_entries_on_payment_status"
    t.index ["stripe_session_id"], name: "index_entries_on_stripe_session_id", unique: true, where: "(stripe_session_id IS NOT NULL)"
    t.index ["tournament_id", "user_id"], name: "index_entries_on_tournament_id_and_user_id", unique: true
    t.index ["tournament_id"], name: "index_entries_on_tournament_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "user_id"
    t.string "email", null: false
    t.string "token", null: false
    t.string "status", default: "pending", null: false
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_invitations_on_status"
    t.index ["token"], name: "index_invitations_on_token", unique: true
    t.index ["tournament_id", "email"], name: "index_invitations_on_tournament_id_and_email", unique: true
    t.index ["tournament_id"], name: "index_invitations_on_tournament_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.integer "day_number", null: false
    t.string "course_name"
    t.json "course_par"
    t.json "course_si"
    t.string "format", default: "stableford"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id", "day_number"], name: "index_rounds_on_tournament_id_and_day_number", unique: true
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "user_id", null: false
    t.bigint "approved_by_id"
    t.json "gross_scores"
    t.string "status", default: "draft", null: false
    t.datetime "approved_at"
    t.text "ocr_raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_scores_on_approved_by_id"
    t.index ["round_id", "user_id"], name: "index_scores_on_round_id_and_user_id", unique: true
    t.index ["round_id"], name: "index_scores_on_round_id"
    t.index ["status"], name: "index_scores_on_status"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.bigint "organiser_id", null: false
    t.string "name", null: false
    t.string "location"
    t.date "date"
    t.string "format", default: "stableford", null: false
    t.string "state", default: "draft", null: false
    t.string "team1_name", default: "Team A"
    t.string "team2_name", default: "Team B"
    t.string "team_trophy"
    t.string "individual_trophy"
    t.integer "entry_fee_pence", default: 0
    t.integer "cttp_fee_pence", default: 0
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_tournaments_on_date"
    t.index ["organiser_id"], name: "index_tournaments_on_organiser_id"
    t.index ["state"], name: "index_tournaments_on_state"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "surname"
    t.string "phone"
    t.string "role", default: "player", null: false
    t.string "cdh_number"
    t.decimal "handicap_index", precision: 4, scale: 1
    t.datetime "handicap_confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entries", "tournaments"
  add_foreign_key "entries", "users"
  add_foreign_key "invitations", "tournaments"
  add_foreign_key "invitations", "users"
  add_foreign_key "rounds", "tournaments"
  add_foreign_key "scores", "rounds"
  add_foreign_key "scores", "users"
  add_foreign_key "scores", "users", column: "approved_by_id"
  add_foreign_key "tournaments", "users", column: "organiser_id"
end
