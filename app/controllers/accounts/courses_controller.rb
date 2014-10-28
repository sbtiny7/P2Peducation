class Accounts::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course,  only: [:show, :edit, :update, :destroy]

  layout 'accounts_teacher'

  # GET /courses
  # GET /courses.json
  def index
    @courses = current_user.courses.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
  end

  def new_online
    @course = current_user.courses.new(:course_type => "ONLINE")
  end

  def new_offline
    @course = current_user.courses.new(:course_type => "OFFLINE")
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to :action => :teacher, :id => @course.id}
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to [:accounts, @course], notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to accounts_courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def teacher
    @agreement = Agreement.last
    @teacher = current_user.teachers.last || current_user.teachers.new
    @teacher.agreement = @agreement
    @teacher.course_id = params[:id]
  end

  def teacher_action
    @teacher = Teacher.find_or_create_by(teacher_params)
    if @teacher.id
      redirect_to complate_course_path(params[:id], @teacher.id)
    else
      @agreement = Agreement.last
      render :action => :teacher
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = current_user.courses.find_by_id params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(
        :title,
        :user_id,
        :image,
        :course_type,
        :category,
        :start_time_date,
        :start_time_hour,
        :start_time_min,
        :end_time_date,
        :end_time_hour,
        :end_time_min,
        :students_max,
        :price,
        :detail,
        :address1,
        :address2,
        :address3,
        :address4
        )
    end

    def teacher_params
      params.require(:teacher).permit(
        :user_id,
        :agreement_id,
        :course_id,
        :name,
        :sex,
        :phone,
        :email,
        :organ_name,
        :organ_detail
        )
    end
end
