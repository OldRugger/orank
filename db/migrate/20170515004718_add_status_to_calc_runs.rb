class AddStatusToCalcRuns < ActiveRecord::Migration
  def change
    add_column :calc_runs, :status, :string
  end
end
