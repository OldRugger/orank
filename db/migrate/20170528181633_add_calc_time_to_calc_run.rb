class AddCalcTimeToCalcRun < ActiveRecord::Migration[4.2]
  def change
    add_column :calc_runs, :calc_time, :integer
  end
end
