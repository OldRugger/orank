class CreateRunnerGvs < ActiveRecord::Migration
  def change
    create_table :runner_gvs do |t|
      t.string :course
      t.float :cgv
      t.float :score
      t.integer :races
      t.references :calc_run, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
