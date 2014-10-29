class Accounts::MainController < ApplicationController
    before_action :authenticate_user!
    layout 'accounts'

    def index #已报名课程
    end

    def config_account
        render "config"
    end

    def update_account
        if current_user.update(user_params)
            redirect_to {:action => :config_account}, :notice => '账号设置成功'
        else
            render :action => :config_account
        end
    end

    def upload_avatar_page
        @avatar = current_user.avatar
    end

    def upload_avatar
        current_user.avatar = params[:avatar]
        current_user.save
    end
    private
    def user_params
      params.require(:user).permit(
        :username,
        :email,
        :phone
        )
    end
end