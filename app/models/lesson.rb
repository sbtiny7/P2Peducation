class Lesson < ActiveRecord::Base
    belongs_to :course
    has_many :learnships
    has_many :students, :through => :learnships
    has_many :videos, :as => :videoable
end
