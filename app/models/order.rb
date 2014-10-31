# encoding: utf-8
# == Schema Information
#
# Table name: orders # 订单
#
#  id         :integer          not null, primary key         # 订单
#  quantity   :integer          default(1), not null          # 数量
#  price      :decimal(16, 2)   default(0.0), not null        # 价格(元)
#  discount   :integer          default(0), not null          # 打折后的价格(元)
#  trade_no   :string(255)      not null                      # 交易号
#  status     :string(255)      default("pendding"), not null # 订单状态
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base

  STATUS = %w(pendding paid completed canceled)
  validates_inclusion_of :status, :in => STATUS

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def pay
    if pendding?
      # 订单生效
      update_attribute :status, 'paid'
    end
  end

  def complete
    if pendding? or paid?
      puts '订单生效' if pendding?

      update_attribute :status, 'completed'
    end
  end

  def cancel
    if pendding? or paid?
      puts '取消订单' if paid?

      update_attribute :status, 'canceled'
    end
  end

  def pay_url
    Alipay::Service.create_partner_trade_by_buyer_url(
      :out_trade_no => id.to_s,
      :price => price,
      :quantity => quantity,
      :discount => discount,
      :subject => "Writings.io \"} x #{quantity}",
      :logistics_type => 'DIRECT',
      :logistics_fee => '0',
      :logistics_payment => 'SELLER_PAY',
      :return_url => Rails.application.routes.url_helpers.order_url(self),
      :notify_url => Rails.application.routes.url_helpers.alipay_notify_orders_url,
      :receive_name => 'none', # 这里填写了收货信息，用户就不必填写
      :receive_address => 'none',
      :receive_zip => '100000',
      :receive_mobile => '100000000000'
    )
  end

end
