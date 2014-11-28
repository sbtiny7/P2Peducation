class Api::StreamController < ApplicationController
    def auth
        render text: "true"
    end
    def stream_start
        @course = Course.find_by(comment_token: params[:token])
        @course.update_attribute(:living, true)
        Rails.logger.info params
        render text: 'ok'
    end
    def stream_stop
        @course = Course.find_by(comment_token: params[:token])
        @course.update_attribute(:living, false)
        Rails.logger.info params
        render text: 'ok'
    end

    def change_archived_url
        render text: 'ok'
    end
end
