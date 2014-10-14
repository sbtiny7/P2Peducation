class Accounts::RegistrationsController < Devise::RegistrationsController
    skip_before_filter :require_no_authentication
end