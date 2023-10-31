class AddRunnerGvIdToRankingAssignment < ActiveRecord::Migration[4.2]
  def change
    add_reference :ranking_assignments, :runner_gv, index: true, foreign_key: true
  end
end
