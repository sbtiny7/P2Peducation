# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  name       :string(255)                            # 课程名字
#  created_at :datetime
#  updated_at :datetime
#

class Section < ActiveRecord::Base
    has_many :lessons
    belongs_to :course
end
