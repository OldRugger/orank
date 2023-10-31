class CreateMeets < ActiveRecord::Migration[4.2]
  def change
    create_table :meets do |t|
      t.string :name
      t.date :date
      t.string :input_file
      t.string :original_filename

      t.timestamps null: false
    end
  end
end
