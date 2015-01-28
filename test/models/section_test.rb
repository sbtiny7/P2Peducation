# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  name       :string(255)                            # 课程名字
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
