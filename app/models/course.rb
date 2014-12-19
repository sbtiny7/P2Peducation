# encoding: utf-8
# == Schema Information
#
# Table name: courses # 课程
#
#  id             :integer          not null, primary key  # 课程
#  user_id        :integer                                 # 所属用户id
#  teacher_id     :integer                                 # 教师id
#  title          :string(255)                             # 标题
#  token          :string(255)
#  image          :string(255)                             # 图标
#  tmp_image      :string(255)
#  category       :string(255)                             # 分类
#  province_id    :integer          default(0), not null   # 所在省份id
#  city_id        :integer          default(0), not null   # 所在城镇id
#  district_id    :integer          default(0), not null   # 所在区县id
#  address        :string(255)                             # 所开地址
#  course_type    :string(255)                             # 类型
#  start_time     :datetime                                # 开始时间
#  end_time       :datetime                                # 结束时间
#  students_count :integer          default(0), not null   # 学生数量
#  students_max   :integer          default(0), not null   # 最大学生数量
#  price          :decimal(15, 3)   default(0.0), not null # 价格
#  mark_count     :integer
#  detail         :text                                    # 详细
#  status         :integer          default(0), not null   # 课程状态
#  created_at     :datetime
#  updated_at     :datetime
#  comment_token  :string(255)
#  living         :boolean
#
# Indexes
#
#  index_courses_on_token  (token) UNIQUE
#

# STATUS: 0 - 未公开；1 - 已公开

class Course < ActiveRecord::Base

    TYPES = %w(ONLINE OFFLINE)
    CATEGORIES = %w(实用技能 兴趣爱好)
    DEFAULT_IMG_PATH = "/temp.jpg"

    mount_uploader :image, ImageUploader
    mount_uploader :tmp_image, TempUploader
    acts_as_commentable :chat, :qa # commentable.chat_comments, commentable.qa_comments

    attr_accessor :start_time_date, :start_time_hour, :start_time_min, :end_time_date, :end_time_hour, :end_time_min

    belongs_to :user
    belongs_to :teacher
    belongs_to :province              #关联省份、城镇、区县
    belongs_to :city
    belongs_to :district
    has_many :orders , foreign_key: :goods_id
    has_many :lessons
    has_many :studyships
    has_many :students, :through => :studyships
    has_many :videos, :as => :videoable
    has_many :reviews
    validates_presence_of :title, :price, :detail
    validates :course_type, :inclusion => {
        :in => TYPES,
        :message => "%{value}不能作为课程类型"
    }

    before_create :init, :generate_comment_token
    before_save :parse_values

    # 返回剩下的空座位的数量
    def just_numbers_left
        self.students_max -  self.paid_orders.count -
            self.orders.where("status = ? AND expired_at > ?", "pending", Time.now).count
    end

    def paid_orders
        self.orders.where(status: "paid")
    end

    def left_courses_count
        self.students_max -  @course.paid_orders.count -
            @course.orders.where("status = ? AND expired_at > ?", "pending", Time.now).count
    end

    # 用户是否已经下过订单
    def is_ordered_by?(user)
        !user.orders.where(:goods_id => id).empty?
    end

    # 判断是否爆满
    def is_jammed?
        Order.where(goods_id: id).sum(:quantity) >= students_max || students_count > students_max
    end

    def parse_values
        if start_time_date && start_time_hour && start_time_min
            self.start_time = "#{start_time_date} #{start_time_hour}:#{start_time_min}"
        end
        if end_time_date && end_time_hour && end_time_min
            self.end_time = "#{end_time_date} #{end_time_hour}:#{end_time_min}"
        end
    end

=begin
    def rename_image
        old_str = self.read_attribute(:image)
        str_arr = old_str.split('.')
        str_arr[-2] += self.id.to_s
        new_str = str_arr.join('.')
        self.update_column(:image, new_str)
    end


=end
    def address_detail
        "#{province.try :name}#{city.try :name}#{district.try :name}#{address}"
    end

    def init
        self.status = 0
    end

    def chat_channel
        "/chat/#{self.id}"
    end
    def video_channel
        "/video/#{self.id}"
    end

    protected
    def generate_comment_token
        self.comment_token = loop do
            random_token = Devise.friendly_token
            break random_token unless Course.exists?(comment_token: random_token)
        end
        self.token = loop do
            random_token = Devise.friendly_token
            break random_token unless Course.exists?(token: random_token)
        end
    end
end
