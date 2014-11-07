# encoding: utf-8
# == Schema Information
#
# Table name: teacher_students
#
#  id         :integer          not null, primary key
#  teacher_id :integer          not null
#  student_id :integer          not null
#

#==================================================
# teacher和Student是many-to-many的关系
#==================================================
class TeacherStudent < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :student, class_name: 'User', foreign_key: :student_id
end
