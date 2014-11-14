# encoding: utf-8
class CoursesController < ApplicationController

  before_filter :authenticate_user!, :only => [:enroll_create]
  layout 'home'

  def show
    @course = Course.where(status: true).find(params[:id])
    if current_user.bookmarks.where(bookmarkable_id: @course.id, bookmarkable_type: "Course").count == 0
        @marked = false
    else
        @marked = true
    end
  end

  def enroll
    @course = Course.find(params[:course_id])
    render 'new'
  end

  def enroll_create
    render json: {message: '重复提交'} and return unless check_token
    render json: {success: false}
  end

  def mark_course
      course = Course.find(params[:id])
      current_user.bookmarks.create(bookmarkable_id: course.id, bookmarkable_type: "Course")
      redirect_to public_show_course_path(course)
  end

  def cancel_marked_course
      course = Course.find(params[:id])
      current_user.bookmarks.where(bookmarkable_id: course.id, bookmarkable_type: "Course").delete_all
      redirect_to :back
  end
end
