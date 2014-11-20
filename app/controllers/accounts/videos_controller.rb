class Accounts::VideosController < ApplicationController
    before_action :authenticate_user!
    before_action :check_teacher
    before_action :set_videoable#, except: [:index]
    before_action :set_video, only: [:show, :edit, :update, :destroy]

    layout 'accounts'

    def index
        @videos = @videoable.videos
    end

    def show
    end

    def new
        @video = @videoable.videos.new
        @video.stream_name = "#{current_user.id}_#{Time.now.to_i}_#{rand(10..99)}"
        @upload_url = "/api/upload_video.json?X-Progress-ID=#{@video.stream_name}"
        @progress_url = "/api/upload_video_progress.json?X-Progress-ID=#{@video.stream_name}"
    end

    def edit
    end

    def create
        @video = @videoable.videos.new(video_params)

        respond_to do |format|
            if @video.save
                format.html {
                    redi_arr = [:accounts, @course, @lesson, @video].compact
                    redirect_to polymorphic_path(redi_arr) , notice: 'Video was successfully created.'
                }
                format.json { render :show, status: :created, location: @video }
            else
                format.html { render :new }
                format.json { render json: @video.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @video.update(video_params)
                format.html {
                    redi_arr = [:accounts, @course, @lesson, @video].compact
                    redirect_to polymorphic_path(redi_arr), notice: 'Video was successfully updated.'
                }
                format.json { render :show, status: :ok, location: @video }
            else
                format.html { render :edit }
                format.json { render json: @video.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @video.destroy
        respond_to do |format|
            format.html {
                redi_arr = [:accounts, @course, @lesson, Video].compact
                redirect_to polymorphic_path(redi_arr), notice: 'Video was successfully destroyed.'
            }
            format.json { head :no_content }
        end
    end

    private
    def set_video
        @video = @videoable.videos.find(params[:id])
    end

    def video_params
        params.require(:video).permit(:title, :course_id)
    end

    def set_videoable
        @course = @lesson = nil
        if params[:course_id]
            @videoable = @course = Course.find_by_id params[:course_id]
        end
        if params[:lesson_id]
            @videoable = @lesson = Lesson.find_by_id params[:lesson_id]
        end
    end
end