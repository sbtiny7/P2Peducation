class Accounts::MainController < ApplicationController

    def index #已报名课程
    end

    def upload_avatar_page
        @avatar = current_user.avatar
    end

    def upload_avatar
        current_user.avatar = params[:avatar]
        current_user.save
    end
end