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

ActiveRecord::Schema.define(version: 20170801224115) do

  create_table "calc_results", force: :cascade do |t|
    t.float    "float_time"
    t.float    "score"
    t.float    "course_cgv"
    t.float    "normalized_score"
    t.integer  "result_id"
    t.integer  "meet_id"
    t.integer  "calc_run_id"
    t.integer  "runner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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

  create_table "news", force: :cascade do |t|
    t.date     "date"
    t.text     "text"
    t.boolean  "publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "power_rankings" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

# Could not dump table "ranking_assignments" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "results", force: :cascade do |t|
    t.time     "time"
    t.float    "float_time"
    t.string   "course"
    t.string   "source_file_type"
    t.float    "length"
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
    t.string   "chip_no"
  end

  add_index "results", ["meet_id"], name: "index_results_on_meet_id"
  add_index "results", ["runner_id"], name: "index_results_on_runner_id"

  create_table "runner_gvs", force: :cascade do |t|
    t.string   "course"
    t.float    "cgv"
    t.float    "score"
    t.integer  "races"
    t.integer  "calc_run_id"
    t.integer  "runner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "normalized_score"
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

  create_table "split_courses", force: :cascade do |t|
    t.integer  "meet_id"
    t.string   "course"
    t.integer  "controls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "split_courses", ["meet_id"], name: "index_split_courses_on_meet_id"

  create_table "split_runners", force: :cascade do |t|
    t.integer  "split_course_id"
    t.integer  "runner_id"
    t.time     "start_punch"
    t.time     "finish_punch"
    t.float    "place"
    t.float    "total_time"
    t.float    "lost_time"
    t.float    "speed"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "split_runners", ["runner_id"], name: "index_split_runners_on_runner_id"
  add_index "split_runners", ["split_course_id"], name: "index_split_runners_on_split_course_id"

  create_table "splits", force: :cascade do |t|
    t.integer  "split_runner_id"
    t.integer  "control"
    t.float    "current_time"
    t.integer  "current_place"
    t.float    "time"
    t.integer  "split_place"
    t.float    "time_diff"
    t.boolean  "lost_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "splits", ["split_runner_id"], name: "index_splits_on_split_runner_id"

end
