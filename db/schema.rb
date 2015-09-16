# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150916042029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "captions", force: :cascade do |t|
    t.string   "text"
    t.float    "start_time"
    t.float    "end_time"
    t.integer  "episode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "captions", ["episode_id"], name: "index_captions_on_episode_id", using: :btree

  create_table "channels", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "image"
    t.integer  "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "channels", ["slug"], name: "index_channels_on_slug", unique: true, using: :btree
  add_index "channels", ["source_id"], name: "index_channels_on_source_id", using: :btree

  create_table "episodes", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "image"
    t.datetime "date_created"
    t.text     "description"
    t.integer  "channel_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "episodes", ["channel_id"], name: "index_episodes_on_channel_id", using: :btree
  add_index "episodes", ["slug"], name: "index_episodes_on_slug", unique: true, using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sources", ["slug"], name: "index_sources_on_slug", unique: true, using: :btree

  add_foreign_key "captions", "episodes"
  add_foreign_key "channels", "sources"
  add_foreign_key "episodes", "channels"
end
