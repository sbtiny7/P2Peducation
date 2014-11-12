# == Schema Information
#
# Table name: courses
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  teacher_id     :integer
#  title          :string(255)
#  token          :string(255)
#  image          :string(255)
#  tmp_image      :string(255)
#  category       :string(255)
#  address        :string(255)
#  course_type    :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  students_count :integer
#  students_max   :integer
#  price          :decimal(15, 3)
#  mark_count     :integer
#  detail         :text
#  status         :integer
#  created_at     :datetime
#  updated_at     :datetime
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
