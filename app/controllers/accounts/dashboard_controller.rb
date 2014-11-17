class Accounts::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "accounts"

  def learning
    @courses = Course.limit(7)
    render "union_courses.html.erb"
  end

  def pending
    @courses = Course.limit(3)
    render "union_courses.html.erb"
  end

  def favorite
    @courses = Course.limit(10)
    render "union_courses.html.erb"
  end

  def incoming
    @courses = current_user.courses
    @user = current_user

  end

  #jingtianxiaozhi
  def cashout
    @cash = Cash.new(cash_params)
    @cash.finished=false
    @cash.user_id=current_user.id
    @cash.save
  end

  def cash_detail
    start_time = params[:start_time];
    end_time = params[:end_time];
    @cashes = Cash.where("created_at > ?  AND created_at < ? AND user_id=?", start_time, end_time,current_user.id)
    render 'incoming'
  end

  private
  def cash_params
    #白名单
    params.require(:cash).permit(:sum, :name, :alipay_account)
  end
end