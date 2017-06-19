class CreateRankingAssignments < ActiveRecord::Migration
  def change
    create_table :ranking_assignments do |t|
      t.references :power_ranking, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
