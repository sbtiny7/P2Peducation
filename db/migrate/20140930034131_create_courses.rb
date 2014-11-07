class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses, :comment => '课程' do |t|
      t.integer :user_id, :comment => '所属用户id'
      t.integer :teacher_id, :comment => '教师id'
      t.string :title, :comment => '标题'
      t.string :token, :comment => ''
      t.string :image, :comment => '图标'
      t.string :tmp_image, :comment => ''
      t.string :category, :comment => '分类'
      t.integer :province_id, :null => false, :default => 0, :comment => '所在省份id'
      t.integer :city_id, :null => false, :default => 0, :comment => '所在城镇id'
      t.integer :district_id, :null => false, :default => 0, :comment => '所在区县id'
      t.string :address, :comment => '所开地址'
      t.string :course_type, :comment => '类型'
      t.datetime :start_time, :comment => '开始时间'
      t.datetime :end_time, :comment => '结束时间'
      t.integer :students_count, :null => false, :default => 0, :comment => '学生数量'
      t.integer :students_max, :null => false, :default => 0, :comment => '最大学生数量'
      t.decimal :price, :precision => 15, :scale => 3, :null => false, :default => 0, :comment => '价格'
      t.integer :mark_count, :comment => ''
      t.text :detail, :comment => '详细'
      t.integer :status, :comment => '课程状态'

      t.timestamps
    end
    add_index :courses, :token, unique: true
  end

end
