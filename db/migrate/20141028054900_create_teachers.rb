# encoding: utf-8
# ==========================================================
#   表结构有待优化！！！
# ==========================================================
class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers, :comment => '教师' do |t|
      t.integer :user_id, :null => false, :comment => '教师的账户id'
      t.string :name, :null => false, :comment => '姓名'
      t.string :sex, :null => false, :comment => '性别'
      t.string :phone, :null => false, :comment => '电话(移动电话)'
      t.string :email, :null => false, :comment => '电子邮件'
      t.string :organ_name, :null => false, :default => '', :comment => '所在机构名称'
      t.text :organ_detail, :null => false, :comment => '所在机构详细介绍'
      t.integer :agreement_id, :null => false, :comment => '协议id'

      #t.text :description, :null => false, :comment => '教师介绍'

      t.timestamps
    end
  end
end
