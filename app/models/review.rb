# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  comment    :string(255)
#  grade      :integer
#  user_id    :integer
#  course_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :course
    validates_presence_of :grade
end
