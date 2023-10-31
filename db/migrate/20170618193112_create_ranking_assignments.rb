class CreateRankingAssignments < ActiveRecord::Migration[4.2]
  def change
    create_table :ranking_assignments do |t|
      t.references :power_ranking, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
