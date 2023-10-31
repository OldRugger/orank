class AddStatusToCalcRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :calc_runs, :status, :string
  end
end
