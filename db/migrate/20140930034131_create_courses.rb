class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :user_id
      t.string  :title
      t.string  :token

      t.timestamps
    end
  end
end
