# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  title      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  section_id :integer
#
# Indexes
#
#  index_lessons_on_token  (token) UNIQUE
#

class Lesson < ActiveRecord::Base
    belongs_to :course
    has_many :learnships
    has_many :students, :through => :learnships
    has_one :video, :as => :videoable
    belongs_to :section
end
