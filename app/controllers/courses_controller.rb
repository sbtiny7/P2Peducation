# encoding: utf-8
class CoursesController < ApplicationController

  before_filter :authenticate_user!, :only => [:enroll_create]
  layout 'home'

  def show
    @course = Course.where(status: true).find(params[:id])
  end

  def enroll
    @course = Course.find(params[:course_id])
    render 'new'
  end

  def enroll_create
    render json: {message: '重复提交'} and return unless check_token
    render json: {success: false}
  end

end
