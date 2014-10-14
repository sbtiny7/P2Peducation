class Course < ActiveRecord::Base
    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %(实用技能 兴趣爱好)
    belongs_to :user
    has_many :lessons
    has_many :studyships
    has_many :students, :through => :studyships

    validates :course_type, :inclusion  => {
        :in      => TYPES,
        :message => "%{value}不能作为课程类型"
    }
end
