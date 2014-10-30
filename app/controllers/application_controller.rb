class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    after_action  :clear_notice

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) << :username
    end

    def check_admin
        if current_user and current_user.has_role?(:admin)
        else
            redirect_to root_path
        end
    end

    def check_teacher
        if current_user and current_user.has_role?(:teacher)
        elsif current_user
            redirect_to accounts_path
        else
            redirect_to root_path
        end
    end

    def clear_notice
        notice = nil
    end
end
