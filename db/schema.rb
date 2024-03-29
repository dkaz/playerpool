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

ActiveRecord::Schema.define(:version => 20120306022306) do

  create_table "games", :force => true do |t|
    t.string   "url"
    t.string   "home"
    t.string   "away"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "team_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "yahoo_id"
  end

  create_table "players_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "player_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "eliminated", :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
