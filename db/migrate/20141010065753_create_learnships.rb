class CreateLearnships < ActiveRecord::Migration
  def change
    create_table :learnships do |t|
      t.integer :student_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end
