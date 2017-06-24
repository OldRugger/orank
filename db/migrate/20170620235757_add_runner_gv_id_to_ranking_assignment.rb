class AddRunnerGvIdToRankingAssignment < ActiveRecord::Migration
  def change
    add_reference :ranking_assignments, :runner_gv, index: true, foreign_key: true
  end
end
