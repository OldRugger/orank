class CreateCalcResults < ActiveRecord::Migration
  def change
    create_table :calc_results do |t|
      t.float :float_time
      t.float :score
      t.float :course_cgv
      t.references :result, index: true, foreign_key: true
      t.references :meet, index: true, foreign_key: true
      t.references :calc_run, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
