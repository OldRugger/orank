class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string :surname
      t.string :firstname
      t.string :sex
      t.integer :club_id
      t.string :club
      t.integer :card_id

      t.timestamps null: false
    end
  end
end
