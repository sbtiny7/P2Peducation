class Api::StreamController < ApplicationController
    def auth
        render text: "true"
    end
    def stream_start
        Rails.logger.info params
        render text: 'ok'
    end
    def stream_stop
        Rails.logger.info params
        render text: 'ok'
    end

    def change_archived_url
        render text: 'ok'
    end
end