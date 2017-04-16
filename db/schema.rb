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

ActiveRecord::Schema.define(version: 20170409204831) do

  create_table "calc_results", force: :cascade do |t|
    t.float    "float_time",  limit: 24
    t.float    "score",       limit: 24
    t.float    "course_cgv",  limit: 24
    t.integer  "result_id",   limit: 4
    t.integer  "meet_id",     limit: 4
    t.integer  "calc_run_id", limit: 4
    t.integer  "runner_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "calc_results", ["calc_run_id"], name: "index_calc_results_on_calc_run_id", using: :btree
  add_index "calc_results", ["meet_id"], name: "index_calc_results_on_meet_id", using: :btree
  add_index "calc_results", ["result_id"], name: "index_calc_results_on_result_id", using: :btree
  add_index "calc_results", ["runner_id"], name: "index_calc_results_on_runner_id", using: :btree

  create_table "calc_runs", force: :cascade do |t|
    t.date     "date"
    t.integer  "publish",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "meets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.date     "date"
    t.string   "input_file", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "results", force: :cascade do |t|
    t.float    "fload_time", limit: 24
    t.string   "class",      limit: 255
    t.integer  "length",     limit: 4
    t.integer  "climb",      limit: 4
    t.integer  "controls",   limit: 4
    t.string   "club",       limit: 255
    t.integer  "club_id",    limit: 4
    t.integer  "place",      limit: 4
    t.string   "error",      limit: 255
    t.boolean  "include"
    t.integer  "meet_id",    limit: 4
    t.integer  "runner_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "results", ["meet_id"], name: "index_results_on_meet_id", using: :btree
  add_index "results", ["runner_id"], name: "index_results_on_runner_id", using: :btree

  create_table "runner_gvs", force: :cascade do |t|
    t.string   "course",      limit: 255
    t.float    "cgv",         limit: 24
    t.string   "score",       limit: 255
    t.integer  "races",       limit: 4
    t.integer  "calc_run_id", limit: 4
    t.integer  "runner_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "runner_gvs", ["calc_run_id"], name: "index_runner_gvs_on_calc_run_id", using: :btree
  add_index "runner_gvs", ["runner_id"], name: "index_runner_gvs_on_runner_id", using: :btree

  create_table "runners", force: :cascade do |t|
    t.string   "surname",    limit: 255
    t.string   "firstname",  limit: 255
    t.string   "sex",        limit: 255
    t.integer  "club_id",    limit: 4
    t.string   "club",       limit: 255
    t.integer  "card_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "calc_results", "calc_runs"
  add_foreign_key "calc_results", "meets"
  add_foreign_key "calc_results", "results"
  add_foreign_key "calc_results", "runners"
  add_foreign_key "results", "meets"
  add_foreign_key "results", "runners"
  add_foreign_key "runner_gvs", "calc_runs"
  add_foreign_key "runner_gvs", "runners"
end
