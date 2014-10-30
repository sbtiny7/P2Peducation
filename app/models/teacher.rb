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

class Teacher < ActiveRecord::Base
    belongs_to :user
    belongs_to :agreement
    has_many   :courses
    attr_accessor :course_id

    after_save :update_course
    def update_course
        course = Course.find_by_id course_id if self.id && course_id
        if course
            course.teacher = self
            course.save
        end
    end
end
