# == Schema Information
#
# Table name: courses # 课程
#
#  id             :integer          not null, primary key  # 课程
#  user_id        :integer                                 # 所属用户id
#  teacher_id     :integer                                 # 教师id
#  title          :string(255)                             # 标题
#  token          :string(255)
#  image          :string(255)                             # 图标
#  tmp_image      :string(255)
#  category       :string(255)                             # 分类
#  province_id    :integer          default(0), not null   # 所在省份id
#  city_id        :integer          default(0), not null   # 所在城镇id
#  district_id    :integer          default(0), not null   # 所在区县id
#  address        :string(255)                             # 所开地址
#  course_type    :string(255)                             # 类型
#  start_time     :datetime                                # 开始时间
#  end_time       :datetime                                # 结束时间
#  students_count :integer          default(0), not null   # 学生数量
#  students_max   :integer          default(0), not null   # 最大学生数量
#  price          :decimal(15, 3)   default(0.0), not null # 价格
#  mark_count     :integer
#  detail         :text                                    # 详细
#  status         :integer          default(0), not null   # 课程状态
#  created_at     :datetime
#  updated_at     :datetime
#  comment_token  :string(255)
#
# Indexes
#
#  index_courses_on_token  (token) UNIQUE
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
