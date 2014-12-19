class Api::StreamController < ApplicationController
    def auth
        render text: "true"
    end
    def stream_start
        @course = Course.find_by(token: params[:token])
        @course.update_attribute(:living, true)
        Rails.logger.info params
        FayeServer::Push.broadcast @course.video_channel,
                                   {cmd: "video_start", token: params[:token],
                                    app_name: params[:app_name]}
        render text: 'ok'
    end
    def stream_stop
        @course = Course.find_by(token: params[:token])
        @course.update_attribute(:living, false)
        @course.videos.create(params.permit(:tid, :preview_addr, :archived_addr))
        FayeServer::Push.broadcast @course.video_channel, {cmd: "video_stop"}
        Rails.logger.info params
        render text: 'ok'
    end

    def change_archived_url
        render text: 'ok'
    end
end
