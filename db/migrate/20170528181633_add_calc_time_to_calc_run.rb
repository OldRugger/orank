class AddCalcTimeToCalcRun < ActiveRecord::Migration
  def change
    add_column :calc_runs, :calc_time, :integer
  end
end
