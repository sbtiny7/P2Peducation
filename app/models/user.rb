class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :courses
  has_many :lessons, :through => :courses
  has_many :studyships, :as => :student
  has_many :applied_courses, :through => :studyships, :source => :course
  has_many :learnships, :as => :student
  has_many :learned_lessons, :through => :learnships, :source => :lesson
  has_many :bookmarks
  has_many :marked_courses, :through => :bookmarks, :source => :bookmarkable, :source_type => "Course"
end