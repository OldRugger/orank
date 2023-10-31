class CreatePowerRankings < ActiveRecord::Migration[4.2]
  def change
    create_table :power_rankings do |t|
      t.string :school
      t.string :class
      t.float :total_score
      t.references :calc_run, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
