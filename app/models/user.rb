# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  username               :string(255)      default(""), not null
#  phone                  :string(255)      default(""), not null
#  avatar                 :string(255)
#  tmp_avatar             :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ActiveRecord::Base
  DEFAULT_AVATAR_PATH = "/temp.jpg"
  rolify
  mount_uploader :avatar, AvatarUploader
  mount_uploader :tmp_avatar, TempUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teachers
  has_many :courses
  has_many :lessons, :through => :courses
  has_many :studyships, :as => :student
  has_many :applied_courses, :through => :studyships, :source => :course
  has_many :learnships, :as => :student
  has_many :learned_lessons, :through => :learnships, :source => :lesson
  has_many :bookmarks
  has_many :marked_courses, :through => :bookmarks, :source => :bookmarkable, :source_type => "Course"
  has_many :orders

  def is_admin?
    self.has_role? :admin
  end

  def is_teacher?
    self.has_role? :teacher
  end
end
