class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.references :split_runner, index: true, foreign_key: true
      t.integer :control
      t.float :current_time
      t.integer :current_place
      t.float :time
      t.integer :split_place
      t.float :time_diff
      t.boolean :lost_time

      t.timestamps null: false
    end
  end
end
