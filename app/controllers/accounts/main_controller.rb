class Accounts::MainController < ApplicationController
    def upload_avatar_page
        @avatar = current_user.avatar
    end

    def upload_avatar
        current_user.avatar = params[:avatar]
        current_user.save
    end
end