# encoding: utf-8
class CoursesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    conditions = {:status => 1}
    conditions = conditions.merge(:course_type => params[:course_type]) if params[:course_type] # TODO 讨论：是否在直播中的状态？预告状态？
    conditions = conditions.merge(:category => params[:category]) if params[:category]
    sp_conditions = []
    sp_conditions = ["title like ?", "%#{params[:keyword]}%"] if params[:keyword]
    @courses = Course.where(conditions).where(sp_conditions).page(params[:page]).per(per_page)
  end

  def show
    @course = Course.where(status: true).find(params[:id])
    @teacher = @course.teacher
    @reviews = @course.reviews
    maker = @course.reviews.group_by(&:grade)
    if @reviews.length == 0
      @star_chart = (1..5).map {|x| {index: x, stars: 0, per: 0}}
    else
      @star_chart = (1..5).map {|x|
        {index: x,
         stars: (maker[x] || []).length,
         per: ((maker[x] || []).length / @reviews.length.to_f * 100).round}
      }
    end
    if user_signed_in?
      @tickets_bought = current_user.has_bought? @course.id
      @course_owner = (current_user.id == @course.user.id)
    end
  end

  def show_after_bought
    @course = Course.where(status: true).find(params[:id])
    @tieckts_bought = current_user.has_bought? @course.id
    @chat_channel = @course.chat_channel
    @user = current_user
    gon.faye_server = "http://#{Settings.host}:9292/faye"
    gon.chat_channel = @chat_channel
    gon.user_id =  @user.id 
    gon.comment_token =  @course.comment_token 
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
