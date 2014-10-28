# STATUS: 0 - 未公开；1 - 已公开

class Course < ActiveRecord::Base

    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %w(实用技能 兴趣爱好)
    DEFAULT_IMG_PATH = "/assets/temp.jpg"

    mount_uploader :image, ImageUploader
    mount_uploader :tmp_image, TempUploader
    acts_as_commentable :chat, :qa # commentable.chat_comments, commentable.qa_comments

    attr_accessor :start_time_date, :start_time_hour, :start_time_min, :end_time_date, :end_time_hour, :end_time_min,
        :address1, :address2, :address3, :address4

    belongs_to :user
    belongs_to :teacher
    has_many :lessons
    has_many :studyships
    has_many :students, :through => :studyships
    has_many :videos, :as => :videoable

    validates :title,  presence: true #, message: "标题不能为空"
    validates :price,  presence: true #, message: "标价不能为空"
    validates :detail, presence: true #, message: "详细描述不能为空"
    validates :course_type, :inclusion  => {
        :in      => TYPES,
        :message => "%{value}不能作为课程类型"
    }

    before_create :init
    after_create  :rename_image
    before_save   :parse_values

    def init
        self.status = 0
    end

    def parse_values
        if start_time_date && start_time_hour && start_time_min
            self.start_time = "#{start_time_date} #{start_time_hour}:#{start_time_min}"
        end
        if end_time_date && end_time_hour && end_time_min
            self.end_time = "#{end_time_date} #{end_time_hour}:#{end_time_min}"
        end
        if address1 && address2 && address3 && address4
            self.address = "#{address1} #{address2} #{address3} #{address4}"
        end
    end

    def rename_image
        old_str = self.read_attribute(:image)
        str_arr = old_str.split('.')
        str_arr[-2] += self.id.to_s
        new_str = str_arr.join('.')
        self.update_column(:image, new_str)
    end
end
