class CreateStudyships < ActiveRecord::Migration
  def change
    create_table :studyships do |t|
      t.integer :student_id
      t.integer :course_id
      t.string  :token

      t.timestamps
    end

    add_index :studyships, :token, unique: true
  end
end
