# == Schema Information
#
# Table name: studyships
#
#  id         :integer          not null, primary key
#  student_id :integer
#  course_id  :integer
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_studyships_on_token  (token) UNIQUE
#

require 'test_helper'

class StudyshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
