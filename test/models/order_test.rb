# == Schema Information
#
# Table name: orders # 订单
#
#  id         :integer          not null, primary key         # 订单
#  user_id    :integer          not null                      # 订单所属用户id
#  goods_id   :integer          not null                      # 商品id
#  quantity   :integer          default(1), not null          # 数量
#  price      :decimal(16, 2)   default(0.0), not null        # 价格(元)
#  discount   :decimal(16, 2)   default(0.0), not null        # 打折后的价格(元)
#  trade_no   :string(255)      not null                      # 交易号
#  status     :string(255)      default("pendding"), not null # 订单状态
#  created_at :datetime
#  updated_at :datetime
#  expired_at :datetime                                       # 订单作废时间
#
# Indexes
#
#  index_orders_on_trade_no  (trade_no) UNIQUE
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
