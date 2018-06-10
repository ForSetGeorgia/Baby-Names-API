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

ActiveRecord::Schema.define(version: 2018_06_10_142800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "names", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.string "gender", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["gender"], name: "index_names_on_gender"
    t.index ["name_en"], name: "index_names_on_name_en"
    t.index ["name_ka"], name: "index_names_on_name_ka"
    t.index ["slug"], name: "index_names_on_slug", unique: true
  end

  create_table "years", force: :cascade do |t|
    t.integer "year", limit: 2
    t.bigint "name_id"
    t.integer "amount", default: 0
    t.integer "amount_year_change"
    t.decimal "amount_year_change_percent", precision: 7, scale: 2
    t.integer "amount_overall_change"
    t.decimal "amount_overall_change_percent", precision: 7, scale: 2
    t.integer "gender_rank"
    t.integer "gender_rank_change"
    t.integer "overall_rank"
    t.integer "overall_rank_change"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["name_id"], name: "index_years_on_name_id"
    t.index ["slug"], name: "index_years_on_slug", unique: true
    t.index ["year", "amount"], name: "index_years_on_year_and_amount"
    t.index ["year", "gender_rank"], name: "index_years_on_year_and_gender_rank"
    t.index ["year", "overall_rank"], name: "index_years_on_year_and_overall_rank"
  end

  add_foreign_key "years", "names"
end
