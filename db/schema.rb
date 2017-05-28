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

ActiveRecord::Schema.define(version: 20170528181633) do

  create_table "calc_results", force: :cascade do |t|
    t.float    "float_time"
    t.float    "score"
    t.float    "course_cgv"
    t.integer  "result_id"
    t.integer  "meet_id"
    t.integer  "calc_run_id"
    t.integer  "runner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "course"
  end

  add_index "calc_results", ["calc_run_id"], name: "index_calc_results_on_calc_run_id"
  add_index "calc_results", ["meet_id"], name: "index_calc_results_on_meet_id"
  add_index "calc_results", ["result_id"], name: "index_calc_results_on_result_id"
  add_index "calc_results", ["runner_id"], name: "index_calc_results_on_runner_id"

  create_table "calc_runs", force: :cascade do |t|
    t.date     "date"
    t.integer  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
    t.integer  "calc_time"
  end

  create_table "meets", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.string   "input_file"
    t.string   "original_filename"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "results", force: :cascade do |t|
    t.time     "time"
    t.float    "float_time"
    t.string   "course"
    t.string   "source_file_type"
    t.integer  "length"
    t.integer  "climb"
    t.integer  "controls"
    t.integer  "place"
    t.integer  "classifier"
    t.boolean  "include"
    t.integer  "meet_id"
    t.integer  "runner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "gender"
  end

  add_index "results", ["meet_id"], name: "index_results_on_meet_id"
  add_index "results", ["runner_id"], name: "index_results_on_runner_id"

  create_table "runner_gvs", force: :cascade do |t|
    t.string   "course"
    t.float    "cgv"
    t.string   "score"
    t.integer  "races"
    t.integer  "calc_run_id"
    t.integer  "runner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "runner_gvs", ["calc_run_id"], name: "index_runner_gvs_on_calc_run_id"
  add_index "runner_gvs", ["runner_id"], name: "index_runner_gvs_on_runner_id"

  create_table "runners", force: :cascade do |t|
    t.string   "surname"
    t.string   "firstname"
    t.string   "sex"
    t.integer  "club_id"
    t.string   "club"
    t.string   "club_description"
    t.integer  "card_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
