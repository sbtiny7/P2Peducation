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
