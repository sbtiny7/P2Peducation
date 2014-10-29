class Accounts::MainController < ApplicationController
  before_action :authenticate_user!

    def index #已报名课程
    end

    def config_account
        render "config"
    end

    def upload_avatar_page
        @avatar = current_user.avatar
    end

    def upload_avatar
        current_user.avatar = params[:avatar]
        current_user.save
    end
end