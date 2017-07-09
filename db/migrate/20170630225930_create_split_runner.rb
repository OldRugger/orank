class CreateSplitRunner < ActiveRecord::Migration
  def change
    create_table :split_runners do |t|
      t.references :split_course, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true
      t.time :start_punch
      t.time :finish_punch
      t.float :place
      t.float :total_time
      t.float :lost_time
      t.float :speed

      t.timestamps null: false
    end
  end
end
