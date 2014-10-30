# encoding: utf-8
# == Schema Information
#
# Table name: orders # 订单
#
#  id         :integer          not null, primary key  # 订单
#  quantity   :integer          default(1), not null   # 数量
#  price      :decimal(16, 2)   default(0.0), not null # 价格(元)
#  discount   :integer          default(0), not null   # 打折后的价格(元)
#  trade_no   :string(255)      not null               # 交易号
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base
end
