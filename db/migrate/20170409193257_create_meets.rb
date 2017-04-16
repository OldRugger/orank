class CreateMeets < ActiveRecord::Migration
  def change
    create_table :meets do |t|
      t.string :name
      t.date :date
      t.string :input_file

      t.timestamps null: false
    end
  end
end
