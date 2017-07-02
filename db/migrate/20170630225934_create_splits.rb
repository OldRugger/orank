class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.references :split_course, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true
      t.integer :control
      t.float :time
      t.float :time_diff

      t.timestamps null: false
    end
  end
end
