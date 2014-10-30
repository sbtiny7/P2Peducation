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
            flash.now[:notice] => '账号设置成功'
            render :action => :config_account
        else
            render :action => :config_account
        end
    end

    def config_avatar
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