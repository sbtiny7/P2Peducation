class Course < ActiveRecord::Base
    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %w(实用技能 兴趣爱好)
    mount_uploader :image, ImageUploader
    mount_uploader :tmp_image, TempUploader
    acts_as_commentable :chat, :qa # commentable.chat_comments, commentable.qa_comments
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
