class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def check_admin
        if current and current.has_role?(:admin)
        else
            redirect_to root_path
        end
    end
end
