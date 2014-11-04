class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    after_action  :clean_notice, :store_location


    protected
    def after_sign_in_path_for(resource)
        session[:previous_url] || root_path
    end

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

    def clean_notice
        flash[:notice] = nil
    end




    def store_location
        black_list = ["/users/sign_in", "/users/sign_up", "/users/password/new",
            "/users/password/edit", "/users/confirmation", "/users/sign_out"]
        if !(black_list.include?(request.path) or request.xhr?)
            session[:previous_url] = request.fullpath 
        end
    end
end
