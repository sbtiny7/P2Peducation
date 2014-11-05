class Accounts::DashboardController <  ApplicationController
  before_action :authenticate_user!
  layout "accounts"
  def student
    @courses = (1..11).to_a
  end
  def learning
    @courses = (1..11).to_a
    render "union_courses.html.erb"
  end
  def pending
    @courses = (1..7).to_a
    render "union_courses.html.erb"
  end
  def favorite
    @courses = (1..3).to_a
    render "union_courses.html.erb"
  end
  def incoming
    @courses = current_user.courses
  end
end
