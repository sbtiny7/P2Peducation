class CourseController < ApplicationController
    def index
        conditions = {:status => 1}
        conditions = conditions.merge(:course_type => params[:course_type]) if params[:course_type] # TODO 讨论：是否在直播中的状态？预告状态？
        conditions = conditions.merge(:category => params[:category]) if params[:category]
        sp_conditions = []
        sp_conditions = ["title like ?", "%#{params[:keyword]}%"] if params[:keyword]
        @courses = Course.where(conditions).where(sp_conditions).page(params[:page]).per(per_page)
    end

    def show
        @course = Course.find params[:course_id]
    end


    private
    def per_page
        15
    end
end
