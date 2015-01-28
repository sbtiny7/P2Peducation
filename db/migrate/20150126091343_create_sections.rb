class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :course_id
      t.string :name, comment: "课程名字"
      t.timestamps
    end
  end
end
