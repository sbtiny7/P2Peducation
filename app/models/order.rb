# encoding: utf-8
# == Schema Information
#
# Table name: orders # 订单
#
#  id         :integer          not null, primary key         # 订单
#  user_id    :integer          not null                      # 订单所属用户id
#  quantity   :integer          default(1), not null          # 数量
#  price      :decimal(16, 2)   default(0.0), not null        # 价格(元)
#  discount   :decimal(16, 2)   default(0.0), not null        # 打折后的价格(元)
#  trade_no   :string(255)      not null                      # 交易号
#  status     :string(255)      default("pendding"), not null # 订单状态
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_orders_on_trade_no  (trade_no) UNIQUE
#

class Order < ActiveRecord::Base

  STATUS = %w(pendding paid completed canceled)
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :trade_no
  before_create :generate_trade_no
  belongs_to :owner, class_name: 'User', foreign_key: :user_id

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
  # ==============================================================
  # 生成即时到帐接口
  # service                                       接口名称
  # partner                                       申请支付接口时的partner_id
  # _input_charset                                编码方式
  # out_trade_no                                  商户订单号，唯一决定订单
  # subject                                       订单名称
  # payment_type                                  支付类型,默认值： 1
  # seller_email                                  申请接口时填写的电子邮件
  # price && quantiry                             商品价格和商品数量
  # ===============================================================
  def pay_url
    Alipay::Service.create_direct_pay_by_user_url(
      {
        :out_trade_no => trade_no,
        :price => price,
        :quantity => quantity,
        :discount => discount,
        :subject => "Writings.io \"} x #{quantity}",
        :logistics_type => 'DIRECT',
        :logistics_fee => '0',
        :logistics_payment => 'SELLER_PAY',
        :return_url => Rails.application.routes.url_helpers.accounts_order_url(self, host: "#{Settings.host}:#{Settings.port}"),
        :notify_url => Rails.application.routes.url_helpers.alipay_notify_accounts_orders_url(host: "#{Settings.host}:#{Settings.port}"),
        :receive_name => 'none',
        :receive_address => 'none',
        :receive_zip => '100000',
        :receive_mobile => '100000000000'
      }
    )
  end

  def self.generate_uuid
    Digest::MD5.hexdigest "#{Time.now.to_i}#{rand(Time.now.to_i)}"
  end

  private

  def generate_trade_no
    write_attribute :trade_no, Order.generate_uuid unless trade_no.present?
  end

end
