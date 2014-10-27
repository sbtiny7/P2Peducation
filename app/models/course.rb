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

    validates :title,  presence: true#, message: "标题不能为空"
    validates :price,  presence: true#, message: "标价不能为空"
    validates :detail, presence: true#, message: "详细描述不能为空"
    validates :course_type, :inclusion  => {
        :in      => TYPES,
        :message => "%{value}不能作为课程类型"
    }

    before_save :parse_time
    def parse_time
        if start_time_date && start_time_hour && start_time_min
            self.start_time = "#{start_time_date} #{start_time_hour}:#{start_time_min}"
        end
        if end_time_date && end_time_hour && end_time_min
            self.end_time= "#{end_time_date} #{end_time_hour}:#{end_time_min}"
        end
    end
end
