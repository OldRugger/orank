class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.time :time
      t.float :float_time
      t.string :course
      t.integer :length
      t.integer :climb
      t.integer :controls
      t.integer :place
      t.integer :classifier
      t.boolean :include
      t.references :meet, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
