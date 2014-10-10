class CreateStudyships < ActiveRecord::Migration
  def change
    create_table :studyships do |t|
      t.integer :student_id
      t.integer :course_id

      t.timestamps
    end
  end
end
