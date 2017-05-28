class AddCoursToCalcResults < ActiveRecord::Migration
  def change
    add_column :calc_results, :course, :string
  end
end
