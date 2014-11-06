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
  end
end
