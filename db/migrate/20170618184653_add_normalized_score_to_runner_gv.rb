class AddNormalizedScoreToRunnerGv < ActiveRecord::Migration
  def change
    add_column :runner_gvs, :normalized_score, :float
  end
end
