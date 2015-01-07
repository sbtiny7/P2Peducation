# == Schema Information
#
# Table name: teachers # 教师
#
#  id           :integer          not null, primary key # 教师
#  user_id      :integer          not null              # 教师的账户id
#  name         :string(255)      not null              # 姓名
#  sex          :string(255)      not null              # 性别
#  phone        :string(255)      not null              # 电话(移动电话)
#  email        :string(255)      not null              # 电子邮件
#  organ_name   :string(255)      default(""), not null # 所在机构名称
#  organ_detail :text             not null              # 所在机构详细介绍
#  agreement_id :integer          not null              # 协议id
#  created_at   :datetime
#  updated_at   :datetime
#  introduce    :string(255)
#  job          :string(255)
#

class Teacher < ActiveRecord::Base
    belongs_to :user
    belongs_to :agreement
    has_many   :courses
    attr_accessor :course_id

    after_save :update_course
    def update_course
        course = Course.find_by_id course_id if self.id && course_id
        if course
            course.teacher = self
            course.save
        end
    end
end
