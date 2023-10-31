class AddNormalizedScoreToRunnerGv < ActiveRecord::Migration[4.2]
  def change
    add_column :runner_gvs, :normalized_score, :float
  end
end
