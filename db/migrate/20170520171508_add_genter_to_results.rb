class AddGenterToResults < ActiveRecord::Migration
  def change
    add_column :results, :gender, :string
  end
end
