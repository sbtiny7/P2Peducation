# encoding: utf-8
class CoursesController < ApplicationController

  before_filter :authenticate_user!, :only => [:enroll_create]

  def index
    conditions = {}
    conditions = conditions.merge(:course_type => params[:course_type]) if params[:course_type] # TODO 讨论：是否在直播中的状态？预告状态？
    conditions = conditions.merge(:category => params[:category]) if params[:category]
    sp_conditions = []
    sp_conditions = ["title like ?", "%#{params[:keyword]}%"] if params[:keyword]
    @courses = Course.published.where(conditions).where(sp_conditions).page(params[:page]).per(per_page)
    @courses_counts = CachedSettings.courses_counts
  end

  def show
    @course = Course.where(status: true).find(params[:id])
    if user_signed_in?
      @tickets_bought = current_user.has_bought? @course.id
      @course_owner = (current_user.id == @course.user.id)
    end
  end

  def show_after_bought
    @course = Course.where(status: true).find(params[:id])
    @tieckts_bought = current_user.has_bought? @course.id
  end

  def enroll
    @course = Course.find(params[:course_id])
    render 'new'
  end

  def enroll_create
    render json: {message: '重复提交'} and return unless check_token
    render json: {success: false}
  end

  private
  def per_page
    15
  end
end
