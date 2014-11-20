# -*- encoding: utf-8 -*-
class Api::ServerController < ApplicationController
    skip_before_action :verify_authenticity_token
    def upload_video
        video = Video.new(video_params)
        # file upload
        # convert
        # push convert success info with faye to the upload page
        render :json => {result: :ok}
    end
    private
    def video_params
        params.require(:video).permit(
            :stream_name,
            :videoable_type,
            :videoable_id
            )
    end
end
