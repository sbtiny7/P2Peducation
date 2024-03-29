# encoding: utf-8
# == Schema Information
#
# Table name: orders # 订单
#
#  id            :integer          not null, primary key        # 订单
#  user_id       :integer          not null                     # 订单所属用户id
#  goods_id      :integer          not null                     # 商品id
#  quantity      :integer          default(1), not null         # 数量
#  price         :decimal(16, 2)   default(0.0), not null       # 价格(元)
#  discount      :decimal(16, 2)   default(0.0), not null       # 打折后的价格(元)
#  trade_no      :string(255)      not null                     # 交易号
#  status        :string(255)      default("pending"), not null # 订单状态
#  created_at    :datetime
#  updated_at    :datetime
#  expired_at    :datetime                                      # 订单作废时间
#  full_pay_path :text
#
# Indexes
#
#  index_orders_on_trade_no  (trade_no) UNIQUE
#

class Order < ActiveRecord::Base

  STATUS = %w(pending paid completed canceled)
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :trade_no
  before_validation :generate_trade_no
  validate do |order|
    order.smaller_then_or_equal_students_max
  end

  after_create :increase_student_count
  # before_destroy :decrease_student_count
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  belongs_to :resource, class_name: 'Course', foreign_key: :goods_id

  scope :not_expired, -> { where("expired_at > ?", Time.now) }

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def pay
    if pending?
      # 订单生效
      update_attribute :status, 'paid'
    end
  end


  def complete
    if pending? or paid?
      puts '订单生效' if pending?

      update_attribute :status, 'completed'
    end
  end

  #
  def cancel
    transaction do # 在这里需要判断订单的状态
      if pending? or paid?
        if paid?
          logger.info '退款...'
        end
        decrease_student_count
        update_attributes(:status => 'canceled', :quantity => 0)
      end
    end
  end

  def set_values(course)
    self.goods_id = course.id
    self.price = course.price
    self.trade_no = Order.generate_uuid
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
  def pay_url(user)
    return unless user.present? or user.phone.present?
    Alipay::Service.create_direct_pay_by_user_url(
      {
        :out_trade_no => trade_no,
        :price => price,
        :quantity => quantity,
        :discount => discount,
        :subject => "商品名称",
        # :logistics_type => 'DIRECT',
        # :logistics_fee => '0',
        # :logistics_payment => 'SELLER_PAY',
        :return_url => Rails.application.routes.url_helpers.successful_accounts_orders_url(host: "#{Settings.host}:#{Settings.port}"),
        :notify_url => Rails.application.routes.url_helpers.alipay_notify_accounts_orders_url(host: "#{Settings.host}:#{Settings.port}"),
        :receive_name => 'xxx',
        :receive_address => 'none',
        :receive_zip => '100000',
        :receive_mobile => '15201248936'
      }
    )
  end

  def self.generate_uuid
    Digest::MD5.hexdigest "#{Time.now.to_i}#{rand(Time.now.to_i)}"
  end

  # 判断学生数量是否已满
  def is_smaller_then_or_equal_students_max?
    resource.present? && (resource.students_count + quantity <= resource.students_max)
  end

  def smaller_then_or_equal_students_max
    errors.add(:quantity, '教室已满') unless is_smaller_then_or_equal_students_max?
  end

  private

  def generate_trade_no
    write_attribute :trade_no, Order.generate_uuid unless trade_no.present?
  end

  def increase_student_count
    resource.update_attribute(:students_count, (resource.students_count || 0) + quantity)
  end

  def decrease_student_count
    target = resource.students_count - quantity
    resource.update_attribute(:students_count, (target < 0 ? 0 : target))
  end


end
