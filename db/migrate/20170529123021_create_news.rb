class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.date :date
      t.text :text
      t.boolean :publish

      t.timestamps null: false
    end
  end
end
