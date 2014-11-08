# == Schema Information
#
# Table name: learnships
#
#  id         :integer          not null, primary key
#  student_id :integer
#  lesson_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Learnship < ActiveRecord::Base
    belongs_to :student, :class_name => "User"
    belongs_to :lesson
end
