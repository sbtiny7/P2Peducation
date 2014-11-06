class CourseController < ApplicationController
    def index
        conditions = {:status => 1}
        conditions = conditions.merge(:course_type => params[:course_type]) if params[:course_type]
        conditions = conditions.merge(:category => params[:category]) if params[:category]
        @courses = Course.where(conditions).page(params[:page]).per(per_page)
    end

    def show
        @course = Course.find params[:course_id]
    end


    private
    def per_page
        1
    end
end
