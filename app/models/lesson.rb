class Lesson < ActiveRecord::Base
    belongs_to :course
    has_many :learnships
    has_many :students, :through => :learnships
end
