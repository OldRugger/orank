class AddCoursToCalcResults < ActiveRecord::Migration[4.2]
  def change
    add_column :calc_results, :course, :string
  end
end
