class Accounts::DashboardController <  ApplicationController
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
    @cash=Cash.new(cash_params)
    @cash.finished=false;
    @cash.save
  end

  private
  def cash_params
    #白名单
    params.require(:cash).permit(:sum, :name , :alipay_account)
  end
end
