# encoding: utf-8
# == Schema Information
#
# Table name: courses
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  teacher_id     :integer
#  title          :string(255)
#  token          :string(255)
#  image          :string(255)
#  tmp_image      :string(255)
#  category       :string(255)
#  address        :string(255)
#  course_type    :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  students_count :integer
#  students_max   :integer
#  price          :decimal(15, 3)
#  mark_count     :integer
#  detail         :text
#  status         :integer
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

  attr_accessor :start_time_date, :start_time_hour, :start_time_min, :end_time_date, :end_time_hour, :end_time_min

  belongs_to :user
  belongs_to :teacher
  belongs_to :province              #关联省份、城镇、区县
  belongs_to :city
  belongs_to :district
  has_many :lessons
  has_many :studyships
  has_many :students, :through => :studyships
  has_many :videos, :as => :videoable
  validates_presence_of :title, :price, :detail
  validates :course_type, :inclusion => {
    :in => TYPES,
    :message => "%{value}不能作为课程类型"
  }

  after_create :rename_image
  before_save :parse_values

  # 返回剩下的空座位的数量
  def just_numbers_left
    students_max - students_count
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

  def rename_image
    old_str = self.read_attribute(:image)
    str_arr = old_str.split('.')
    str_arr[-2] += self.id.to_s
    new_str = str_arr.join('.')
    self.update_column(:image, new_str)
  end

  def address_detail
      "#{province.try :name}#{city.try :name}#{district.try :name}#{address}"
  end
  
end
