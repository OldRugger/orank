class CreateCalcRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :calc_runs do |t|
      t.date :date
      t.integer :publish

      t.timestamps null: false
    end
  end
end
