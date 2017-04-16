class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.float :fload_time
      t.string :class
      t.integer :length
      t.integer :climb
      t.integer :controls
      t.string :club
      t.integer :club_id
      t.integer :place
      t.string :error
      t.boolean :include
      t.references :meet, index: true, foreign_key: true
      t.references :runner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
