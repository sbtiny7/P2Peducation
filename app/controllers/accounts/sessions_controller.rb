class Accounts::SessionsController < Devise::SessionsController
    before_filter :set_request_format, :only => [:new]
    private
    def require_no_authentication
        Rails.logger.info "come here "
        respond_to do |format|
            format.json {
                session["warden.user.user.key"] = nil
            }
            format.html {
                session["warden.user.user.key"] = nil
            }
            format.js {
                session["warden.user.user.key"] = nil
            }
        end
    end

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