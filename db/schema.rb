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

ActiveRecord::Schema.define(version: 20180624091713) do

  create_table "mymaps", force: :cascade do |t|
    t.string   "name",                   null: false
    t.text     "comment"
    t.string   "picture"
    t.integer  "status",     default: 0
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_mymaps_on_user_id"
  end

  create_table "opens", force: :cascade do |t|
    t.integer  "place_id",   null: false
    t.string   "time",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_opens_on_place_id"
  end

  create_table "place_pictures", force: :cascade do |t|
    t.integer  "place_id",   null: false
    t.text     "picture",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_place_pictures_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.integer  "mymap_id",     null: false
    t.string   "name",         null: false
    t.integer  "types_number", null: false
    t.string   "types_name",   null: false
    t.text     "address",      null: false
    t.string   "phone_number"
    t.text     "google_url"
    t.string   "placeId",      null: false
    t.text     "memo"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["mymap_id"], name: "index_places_on_mymap_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "follow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_id"], name: "index_relationships_on_follow_id"
    t.index ["user_id", "follow_id"], name: "index_relationships_on_user_id_and_follow_id", unique: true
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_mymaps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mymap_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mymap_id"], name: "index_user_mymaps_on_mymap_id"
    t.index ["user_id", "mymap_id"], name: "index_user_mymaps_on_user_id_and_mymap_id", unique: true
    t.index ["user_id"], name: "index_user_mymaps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",          null: false
    t.string   "encrypted_password",     default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "uid"
    t.string   "provider"
    t.string   "name",                   default: "anonymous"
    t.string   "image"
    t.string   "picture"
    t.text     "user_access_token"
    t.string   "own_url"
    t.text     "profile_text"
    t.integer  "role",                   default: 0,           null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
