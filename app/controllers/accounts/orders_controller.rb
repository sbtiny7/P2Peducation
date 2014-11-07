# encoding: utf-8
class Accounts::OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:alipay_notify]
  layout 'accounts'

  def index

  end

  def new
    puts params
    @course = Course.find(params[:course_id])
    @order = current_user.orders.build
    @order.set_values @course
    render 'new', layout: 'home'
  end

  def create
    render json: {message: '重复提交'} and return unless check_token
    @course = Course.find(order_params[:goods_id])
    #  现在假设order_params[:quantity]是数字字符串
    if order_params[:quantity].to_i <= @course.just_numbers_left
      success, redirect, message = false, '', ''
      @order = current_user.orders.build order_params
      @order.set_values(@course)
      if @order.save
        success, redirect = true, @order.pay_url(current_user) # and return
      else
        message = '订单保存失败'
      end
    else
      message = '抱歉，库存不足'
    end

    render json: {success: success, redirect: redirect, message: message}
  end

  def show
    @order = current_user.orders.find(params[:id]) #where(:trade_no, params[:trade_no])
  end

  # 支付成功后，返回的地址
  def successful
    result_params = params.except *request.path_parameters.keys
    if Alipay::Sign.verify?(result_params) && Alipay::Notify.verify?(result_params) # 验证加密方式和支付宝发送的请求
      if result_params['is_success'] === 'T'
        @order = current_user.orders.find result_params['trade_no']
        case result_params['trade_status']
          when 'TRADE_SUCCESS'
             @order.pay
          when 'TRADE_FINISHED'
             logger.info '超时'
        end
      end
    end
    redirect_to root_path
  end

  #
  #def settle
  #  @order = current_user.orders.where(:trade_no => params[:trade_no]).first
  #  # puts "#{@order.pay_url(current_user)}"
  #  if @order
  #    redirect_to @order.pay_url(current_user) and return if @order
  #    # render :partial => 'alipay_submit', layout: false, locals: {options: options} # and return
  #  end
  #  render :partial => 'alipay_submit', layout: false, locals: {options: {}}
  #end

  #
  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    # 先校验消息的真实性
    if Alipay::Sign.verify?(notify_params) && Alipay::Notify.verify?(notify_params)
      # 获取交易关联的订单支付宝异步消息接口
      @order = current_user.orders.find params[:out_trade_no]
      logger.info notify_params
      case params[:trade_status]
        when 'WAIT_BUYER_PAY'
          # 交易开启
          @order.update_attribute :trade_no, params[:trade_no]
        when 'WAIT_SELLER_SEND_GOODS'
          # 买家完成支付
          @order.pay
        # 虚拟物品无需发货，所以立即调用发货接口
        # @order.send_good
        when 'TRADE_FINISHED'
          # 交易完成
          @order.complete
        when 'TRADE_CLOSED'
          # 交易被关闭
          @order.cancel
      end

      render :text => 'success' # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。
    else
      render :text => 'error'
    end
  end

  def check_quantity
    course = Course.find(order_params[:goods_id])
    #render text: success and return unless course.present? # 如果没有查询到，则返回false
    logger.info "#{((order_params[:quantity].to_i <= course.just_numbers_left) || false).to_s}  ======================== "
    render text: ((order_params[:quantity].to_i <= course.just_numbers_left) || false).to_s
  end

  private
  def order_params
    params.require(:order).permit(:quantity, :trade_no, :goods_id)
  end

end
