class Course < ActiveRecord::Base
    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %w(实用技能 兴趣爱好)
    DEFAULT_IMG_PATH = "/assets/temp.jpg"

    mount_uploader :image, ImageUploader
    mount_uploader :tmp_image, TempUploader
    acts_as_commentable :chat, :qa # commentable.chat_comments, commentable.qa_comments

    attr_accessor :start_time_date, :start_time_hour, :start_time_min, :end_time_date, :end_time_hour, :end_time_min

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
