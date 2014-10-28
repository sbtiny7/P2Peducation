class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer  :user_id
      t.integer  :teacher_id
      t.string   :title
      t.string   :token
      t.string   :image
      t.string   :tmp_image
      t.string   :category
      t.string   :address
      t.string   :course_type
      t.datetime :start_time
      t.datetime :end_time
      t.integer  :students_count
      t.integer  :students_max
      t.decimal  :price,         :precision => 15, :scale => 3
      t.integer  :mark_count
      t.text     :detail
      t.integer  :status

      t.timestamps
    end
    add_index :courses, :token, unique: true
  end

end
