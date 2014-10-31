class Accounts::MainController < ApplicationController
    before_action :authenticate_user!
    layout 'accounts'

    def index #已报名课程
    end

    def config_account
        render "account"
    end

    def update_account
        if current_user.update(user_params)
            flash.now[:notice] = '账号设置成功'
            render "account"
        else
            render :action => :config_account
        end
    end

    def config_avatar
        @timestamp = Time.now.to_i
        render "avatar"
    end

    def upload_avatar
        @timestamp = Time.now.to_i
        if params[:avatar]
            %w(avatar avatar_x avatar_y avatar_w avatar_h).map do |attr|
                Rails.logger.info("======#{attr}:#{params[attr.to_sym]}======")
                current_user.send("#{attr}=", params[attr.to_sym] || nil)
            end
            current_user.save
            flash.now[:notice] = '头像上传成功'
        else
            current_user.avatar = nil
            current_user.save
            flash.now[:notice] = '头像删除成功'
        end
        render "avatar"
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