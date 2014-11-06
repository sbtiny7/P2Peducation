class HomeController < ApplicationController
    before_action :authenticate_user!, :only => [:lesson]

    def index #首页
      @open_lessons = Course.limit(3)
      @live_lessons = Course.limit(5)
    end

    def course #课程信息、报名
        @course = Course.where(:id => params[:course_id], :status => 1).first
    end

    def study #观看视频
    end

end
