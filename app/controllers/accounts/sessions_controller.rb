class Accounts::SessionsController < Devise::SessionsController
    prepend_before_filter :require_no_authentication, only: [ :new, :create ]
    prepend_before_filter :allow_params_authentication!, only: :create
    prepend_before_filter :verify_signed_out_user, only: :destroy
    prepend_before_filter only: [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }
    before_filter :set_request_format, :only => [:new]

    def create
        respond_to do |f| 
            f.html {super}
            f.json {
                auth_options = { scope: resource_name, recall: "#{controller_path}#new" }
                self.resource = warden.authenticate!(auth_options)
                set_flash_message(:notice, :signed_in) if is_flashing_format?
                sign_in(resource_name, resource)
                render json: {token: resource.authentication_token}
            }
        end
    end
    private
    def set_request_format
        if is_mobile_device?
            unless request.format.to_s.include? "json"
                request.format = :mobile
            end
        end
    end
    def is_mobile_device?
        !!mobile_device
    end

    def mobile_device
        request.headers['X_MOBILE_DEVICE']
    end
end
