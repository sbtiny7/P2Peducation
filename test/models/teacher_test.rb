# == Schema Information
#
# Table name: teachers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  name         :string(255)
#  sex          :string(255)
#  phone        :string(255)
#  email        :string(255)
#  organ_name   :string(255)
#  organ_detail :text
#  agreement_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
