class CreateLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :links do |t|
      t.string :label
      t.string :url
      t.boolean :publish

      t.timestamps null: false
    end
  end
end
