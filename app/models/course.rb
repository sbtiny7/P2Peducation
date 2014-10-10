class Course < ActiveRecord::Base
    belongs_to :user
    has_many :lessons
    has_many :studyships
    has_many :students, :through => :studyships
end
