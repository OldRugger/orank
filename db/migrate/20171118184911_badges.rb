class Badges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :runner, index: true, foreign_key: true
      t.string :season
      t.string :badge_type
      t.string :class_type
      t.string :value
      t.string :text
      t.integer :sort

      t.timestamps null: false
    end
  end
end
