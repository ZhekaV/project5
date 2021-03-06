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

ActiveRecord::Schema.define(version: 20161003132139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "musics", force: :cascade do |t|
    t.string "style"
    t.datetime "posted"
    t.string "title"
    t.string "url"
    t.integer "rating", default: 0
    t.string "artwork_url"
    t.boolean "viewed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "fe_id"
    t.integer "votes", default: 0
    t.string "label"
    t.date "released"
    t.string "res_type"
    t.float "score", default: 0.0
    t.index ["fe_id"], name: "index_musics_on_fe_id", unique: true
  end

end
