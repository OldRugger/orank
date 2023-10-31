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

ActiveRecord::Schema[7.1].define(version: 2017_11_18_184911) do
  create_table "badges", force: :cascade do |t|
    t.integer "runner_id"
    t.string "season"
    t.string "badge_type"
    t.string "class_type"
    t.string "value"
    t.string "text"
    t.integer "sort"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["runner_id"], name: "index_badges_on_runner_id"
  end

  create_table "calc_results", force: :cascade do |t|
    t.float "float_time"
    t.float "score"
    t.float "course_cgv"
    t.float "normalized_score"
    t.integer "result_id"
    t.integer "meet_id"
    t.integer "calc_run_id"
    t.integer "runner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "course"
    t.index ["calc_run_id"], name: "index_calc_results_on_calc_run_id"
    t.index ["meet_id"], name: "index_calc_results_on_meet_id"
    t.index ["result_id"], name: "index_calc_results_on_result_id"
    t.index ["runner_id"], name: "index_calc_results_on_runner_id"
  end

  create_table "calc_runs", force: :cascade do |t|
    t.date "date"
    t.integer "publish"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status"
    t.integer "calc_time"
  end

  create_table "links", force: :cascade do |t|
    t.string "label"
    t.string "url"
    t.boolean "publish"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "meets", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "input_file"
    t.string "original_filename"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "news", force: :cascade do |t|
    t.date "date"
    t.text "text"
    t.boolean "publish"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "power_rankings", force: :cascade do |t|
    t.string "school"
    t.string "ranking_class"
    t.float "total_score"
    t.integer "calc_run_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["calc_run_id"], name: "index_power_rankings_on_calc_run_id"
  end

  create_table "ranking_assignments", force: :cascade do |t|
    t.integer "power_ranking_id"
    t.integer "runner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "runner_gv_id"
    t.index ["power_ranking_id"], name: "index_ranking_assignments_on_power_ranking_id"
    t.index ["runner_gv_id"], name: "index_ranking_assignments_on_runner_gv_id"
    t.index ["runner_id"], name: "index_ranking_assignments_on_runner_id"
  end

  create_table "results", force: :cascade do |t|
    t.time "time"
    t.float "float_time"
    t.string "course"
    t.string "source_file_type"
    t.float "length"
    t.integer "climb"
    t.integer "controls"
    t.integer "place"
    t.integer "classifier"
    t.boolean "include"
    t.integer "meet_id"
    t.integer "runner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "gender"
    t.index ["meet_id"], name: "index_results_on_meet_id"
    t.index ["runner_id"], name: "index_results_on_runner_id"
  end

  create_table "runner_gvs", force: :cascade do |t|
    t.string "course"
    t.float "cgv"
    t.float "score"
    t.integer "races"
    t.integer "calc_run_id"
    t.integer "runner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "normalized_score"
    t.index ["calc_run_id"], name: "index_runner_gvs_on_calc_run_id"
    t.index ["runner_id"], name: "index_runner_gvs_on_runner_id"
  end

  create_table "runners", force: :cascade do |t|
    t.string "surname"
    t.string "firstname"
    t.string "sex"
    t.integer "club_id"
    t.string "club"
    t.string "club_description"
    t.integer "card_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "split_courses", force: :cascade do |t|
    t.integer "meet_id"
    t.string "course"
    t.integer "controls"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["meet_id"], name: "index_split_courses_on_meet_id"
  end

  create_table "split_runners", force: :cascade do |t|
    t.integer "split_course_id"
    t.integer "runner_id"
    t.time "start_punch"
    t.time "finish_punch"
    t.float "place"
    t.float "total_time"
    t.float "lost_time"
    t.float "speed"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["runner_id"], name: "index_split_runners_on_runner_id"
    t.index ["split_course_id"], name: "index_split_runners_on_split_course_id"
  end

  create_table "splits", force: :cascade do |t|
    t.integer "split_runner_id"
    t.integer "control"
    t.float "current_time"
    t.integer "current_place"
    t.float "time"
    t.integer "split_place"
    t.float "time_diff"
    t.boolean "lost_time"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["split_runner_id"], name: "index_splits_on_split_runner_id"
  end

  add_foreign_key "badges", "runners"
  add_foreign_key "calc_results", "calc_runs"
  add_foreign_key "calc_results", "meets"
  add_foreign_key "calc_results", "results"
  add_foreign_key "calc_results", "runners"
  add_foreign_key "power_rankings", "calc_runs"
  add_foreign_key "ranking_assignments", "power_rankings"
  add_foreign_key "ranking_assignments", "runner_gvs"
  add_foreign_key "ranking_assignments", "runners"
  add_foreign_key "results", "meets"
  add_foreign_key "results", "runners"
  add_foreign_key "runner_gvs", "calc_runs"
  add_foreign_key "runner_gvs", "runners"
  add_foreign_key "split_courses", "meets"
  add_foreign_key "split_runners", "runners"
  add_foreign_key "split_runners", "split_courses"
  add_foreign_key "splits", "split_runners"
end
