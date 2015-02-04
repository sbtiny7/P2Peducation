class Accounts::MainController < ApplicationController
    before_action :authenticate_user!

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


    def delete_avatar
        user = current_user
        user.remove_avatar!
        user.save
        redirect_to :back
    end

    def upload_avatar
        @timestamp = Time.now.to_i
        if user_params
            current_user.update(user_params)
            %w(x y w h).each do |a|
                Rails.logger.info("controller.avatar_#{a}:#{current_user.send("avatar_#{a}")}")
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
        if params[:user]
            params.require(:user).permit(
                :username,
                :email,
                :phone,
                :avatar,
                :avatar_x,
                :avatar_y,
                :avatar_w,
                :avatar_h
                )
        else
            false
        end
    end
end