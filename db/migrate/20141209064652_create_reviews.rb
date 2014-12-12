class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :comment
      t.integer :grade
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end
end
