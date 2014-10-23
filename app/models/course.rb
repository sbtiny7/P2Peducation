class Course < ActiveRecord::Base
    acts_as_commentable :chat, :qa
    mount_uploader :image, ImageUploader
    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %w(实用技能 兴趣爱好)
    belongs_to :user
    has_many :lessons
    has_many :studyships
    has_many :students, :through => :studyships
    has_many :videos, :as => :videoable

    validates :course_type, :inclusion  => {
        :in      => TYPES,
        :message => "%{value}不能作为课程类型"
    }
end
