class CreateSplitCourses < ActiveRecord::Migration
  def change
    create_table :split_courses do |t|
      t.references :meet, index: true, foreign_key: true
      t.string :course

      t.timestamps null: false
    end
  end
end
