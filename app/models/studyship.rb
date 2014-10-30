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

class Studyship < ActiveRecord::Base
    belongs_to :student, :class_name => "User"
    belongs_to :course

    after_create :generate_token

    def teacher
        self.course.user
    end

    def teacher_id
        self.course.user_id
    end

    def ar_code_str
        "/api/study/study?token=#{self.token}&course_id=#{self.course_id}&student_id=#{self.student_id}&teacher_id=#{self.teacher_id}"
    end

    protected
    def generate_token
        begin
            self.token = Message.faye_rand
            self.save!
        rescue ActiveRecord::RecordNotUnique => e
            retry
        end
    end
end
