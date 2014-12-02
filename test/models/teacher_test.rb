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
#  avatar       :string(255)
#

require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
