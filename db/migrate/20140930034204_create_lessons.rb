class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :user_id
      t.integer :course_id
      t.string  :title
      t.string  :token

      t.timestamps
    end
  end
end
