# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  title      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  section_id :integer
#
# Indexes
#
#  index_lessons_on_token  (token) UNIQUE
#

require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
