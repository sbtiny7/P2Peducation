class Accounts::SessionsController < Devise::SessionsController
    prepend_before_filter :require_no_authentication, only: [ :new, :create ]
    prepend_before_filter :allow_params_authentication!, only: :create
    prepend_before_filter :verify_signed_out_user, only: :destroy
    prepend_before_filter only: [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }
    before_filter :set_request_format, :only => [:new]
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