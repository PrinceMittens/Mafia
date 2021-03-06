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

ActiveRecord::Schema.define(version: 20160717231526) do

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.string   "player_email"
    t.string   "player_name"
    t.string   "role"
    t.integer  "affiliation"
    t.boolean  "is_dead"
    t.integer  "vote_target_player_id"
    t.integer  "vote_count"
    t.integer  "next_player_id"
    t.integer  "prev_player_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "post_type"
    t.integer  "hidden"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "player_id"
    t.integer  "last_registered_player_id"
    t.string   "title"
    t.text     "content"
    t.integer  "category"
    t.integer  "roster_count"
    t.integer  "phase"
    t.integer  "time_left"
    t.boolean  "gameover"
    t.integer  "num_players_alive"
    t.integer  "num_mafia"
    t.integer  "num_town"
    t.integer  "day_timelimit"
    t.integer  "night_timelimit"
    t.integer  "who_won"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
