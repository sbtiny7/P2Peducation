# -*- encoding: utf-8 -*-
class Api::ServerController < ApplicationController
    before_action :authenticate_user!
    def send_captcha
        current_user.generate_captcha(params[:phone])
        render json: {}
    end
end
