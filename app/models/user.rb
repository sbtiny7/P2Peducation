class User < ActiveRecord::Base
  DEFAULT_AVATAR_PATH = "/temp.jpg"
  AVATAR_PREVIEW_SIZE = 400
  rolify
  mount_uploader :avatar, AvatarUploader
  mount_uploader :tmp_avatar, TempUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :avatar_x, :avatar_y, :avatar_w, :avatar_h

  has_many :teachers
  has_many :courses
  has_many :lessons, :through => :courses
  has_many :studyships, :as => :student
  has_many :applied_courses, :through => :studyships, :source => :course
  has_many :learnships, :as => :student
  has_many :learned_lessons, :through => :learnships, :source => :lesson
  has_many :bookmarks
  has_many :marked_courses, :through => :bookmarks, :source => :bookmarkable, :source_type => "Course"

  after_update :crop_avatar

  def is_admin?
    self.has_role? :admin
  end

  def is_teacher?
    self.has_role? :teacher
  end


  def crop_avatar
    %w(x y w h).each do |a|
      Rails.logger.info "model.avatar_#{a}: #{self.send("avatar_#{a}")}"
    end
    avatar.recreate_versions! if avatar_x.present?
  end

end
