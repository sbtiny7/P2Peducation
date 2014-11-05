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
#  address        :string(255)                             # 所开地址
#  course_type    :string(255)                             # 类型
#  start_time     :datetime                                # 开始时间
#  end_time       :datetime                                # 结束时间
#  students_count :integer          default(0), not null   # 学生数量
#  students_max   :integer          default(0), not null   # 最大学生数量
#  price          :decimal(15, 3)   default(0.0), not null # 价格
#  mark_count     :integer
#  detail         :text                                    # 详细
#  status         :integer                                 # 课程状态
#  created_at     :datetime
#  updated_at     :datetime
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

  attr_accessor :start_time_date, :start_time_hour, :start_time_min, :end_time_date, :end_time_hour, :end_time_min,
                :address1, :address2, :address3, :address4

  belongs_to :user
  belongs_to :teacher
  has_many :lessons
  has_many :studyships
  has_many :students, :through => :studyships
  has_many :videos, :as => :videoable
  validates_presence_of :title, :price, :detail
  validates :course_type, :inclusion => {
    :in => TYPES,
    :message => "%{value}不能作为课程类型"
  }

  before_create :init
  after_create :rename_image
  before_save :parse_values

  def init
    self.status = 0
  end

  def just_numbers_left
    students_max - students_count
  end

  def is_ordered_by?(user)
    !user.orders.where(:goods_id => id).empty?
  end

  def is_jammed?
    students_count >= students_max
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
