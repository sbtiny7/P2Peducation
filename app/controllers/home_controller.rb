class HomeController < ApplicationController
  before_action :authenticate_user!, :only => [:lesson]
  include ChinaRegionFu::Helpers
  def index #首页
  end

  def courses #发现课程
    @courses = Course.where(:status => 1)
  end

  def course #课程信息、报名
    @course = Course.where(:id => params[:course_id], :status => 1).first
  end

  def study #观看视频
  end

  # 用于测试
  def test

    render layout: 'home'
  end

end
