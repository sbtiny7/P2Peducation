class Accounts::DashboardController <  ApplicationController
  before_action :authenticate_user!
  def learning
    @courses = current_user.bought_courses
    render "union_courses.html.erb"
  end
  def pending
    @courses = current_user.learning_courses
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
end
