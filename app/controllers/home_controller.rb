class HomeController < ApplicationController
    before_action :authenticate_user!, :only => [:lesson]
    def index #首页
    end

    def courses #发现课程
    end

    def course #课程信息、报名
    end

    def study #观看视频
    end

end
