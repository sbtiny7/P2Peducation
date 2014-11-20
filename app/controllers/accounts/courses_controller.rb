class Accounts::CoursesController < ApplicationController
  include ChinaRegionFu::Helpers
  before_action :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy, :complate, :pub]

  layout 'accounts'

  # GET /courses
  # GET /courses.json
  def index
    @courses = current_user.courses.all.includes(:teacher)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @students = @course.students
    @teacher = @course.teacher
    if @course.course_type == "ONLINE"
      render 'online_show.html.erb'
    end
  end

  # GET /courses/new
  def new
  end

  def new_online
    @course = current_user.courses.new(:course_type => "ONLINE", :user => current_user)
  end

  def new_offline
    @course = current_user.courses.new(:course_type => "OFFLINE", :user => current_user)
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
        format.html { redirect_to :action => :teacher, :id => @course.id }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
      logger.info @course.errors.inspect
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
    @teacher = Teacher.find_or_create_by(teacher_params.except(:course_id))
    if @teacher.id
      redirect_to :action => :complate, :id => params[:id], :teacher_id => @teacher.id
    else
      @agreement = Agreement.last
      render :action => :teacher
    end
  end

  def complate
    @teacher = current_user.teachers.where(:id => params[:teacher_id]).first
    @course.teacher = @teacher
    @course.save
  end

  def pub
    @course.update_column(:status, 1)
    CachedSettings.courses_counts = {
      :all      => Course.published.count,
      :living   => Course.living.count,
      :archived => Course.archived.count,
      :online   => Course.online.count,
      :offline  => Course.offline.count
    }
    redirect_to course_path(@course)
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
      :province_id,
      :city_id,
      :district_id,
      :address
    ).merge(params[:c] || {})
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
