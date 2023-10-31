class AddGenterToResults < ActiveRecord::Migration[4.2]
  def change
    add_column :results, :gender, :string
  end
end
