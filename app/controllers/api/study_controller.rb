#encoding: utf-8
class Api::StudyController < ApplicationController

    def apply
        course    = Course.find_by_id params[:course_id]
        student   = User.find_by_id params[:student_id]
        studyship = Studyship.new(:course => course, :student => student)
        if course && student && studyship.save
            render :json => {:result => 'ok'}
        else
            render :json => {:result => 'fail', :reason => '报名失败！'}
        end
    end

    def study
        studyship  = Studyship.find_by_token params[:token]
        course_id  = params[:course_id].to_i
        student_id = params[:student_id].to_i
        teacher_id = params[:teacher_id].to_i
        if studyship && studyship.course_id == course_id && studyship.user_id == user_id && studyship.course.user_id == teacher_id
            if !studyship.studied
                studyship.update_attribute(:studied, true)
                render :json => {:result => 'ok'}
            else
                render :json => {:result => 'fail', :reason => '该报名号已被使用'}
            end
        elsif studyship
            render :json => {:result => 'fail', :reason => '报名号与用户身份不符'}
        else
            render :json => {:result => 'fail', :reason => '该报名号不存在'}
        end
    end

end
